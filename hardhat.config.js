require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require('hardhat-deploy');
require("hardhat-gas-reporter");
require("solidity-coverage");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// REQUIRED TO ENSURE METADATA IS SAVED IN DEPLOYMENTS (because solidity-coverage disable it otherwise)
const { TASK_COMPILE_GET_COMPILER_INPUT, TASK_COMPILE_SOLIDITY_COMPILE } = require("hardhat/builtin-tasks/task-names");
task(TASK_COMPILE_GET_COMPILER_INPUT).setAction(async (_, bre, runSuper) => {
  const input = await runSuper();
  input.settings.metadata.useLiteralContent = bre.network.name !== "coverage";
  return input;
});

const alchemyKey = process.env.ALCHEMY_KEY || "";

function nodeUrl(network) {
  return `https://eth-${network}.alchemyapi.io/v2/${alchemyKey}`;
}

let privateKey = process.env.PK || "";
const accounts = privateKey
  ? [
    privateKey,
    ]
  : undefined;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.13",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        }
      },
    },
    local: {
      url: 'http://localhost:8545',
    },
    ropsten: {
      accounts,
      url: nodeUrl("ropsten"),
      gasPrice: 40000000000,
      timeout: 50000
    },
    coverage: {
      url: "http://127.0.0.1:8555",
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  namedAccounts: {
    deployer: {
      default: 0,
      ropsten: "0xC09dc09ECDcD425f595f44d1935bDCBDdE00C1F5",
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

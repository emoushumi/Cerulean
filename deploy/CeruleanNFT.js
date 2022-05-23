const deployCeruleanNFT = async (hre) => {
  const { deploy } = hre.deployments;
  const { deployer } = await hre.getNamedAccounts();

  await deploy("CeruleanNFT", {
    from: deployer,
    args: [],
    log: true,
    proxy: {
      proxyContract: "OpenZeppelinTransparentProxy",
      viaAdminContract: "DefaultProxyAdmin",
      execute: {
        init: {
          methodName: "initialize",
          args: ["CeruleanNFT", "CeruleanNFT"],
        },
      },
    },
  });
};
module.exports = deployCeruleanNFT;
deployCeruleanNFT.tags = ["CeruleanNFT"];

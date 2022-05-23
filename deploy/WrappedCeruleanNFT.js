const deployWrappedCeruleanNFT = async (hre) => {
  const { deploy } = hre.deployments;
  const { deployer } = await hre.getNamedAccounts();

  // get CeruleanNFT contract
  const ceruleanNFT = await hre.deployments.get('CeruleanNFT');

  await deploy("WrappedCeruleanNFT", {
    from: deployer,
    args: [],
    log: true,
    proxy: {
      proxyContract: "OpenZeppelinTransparentProxy",
      viaAdminContract: "DefaultProxyAdmin",
      execute: {
        init: {
          methodName: "initialize",
          args: ["WrappedCeruleanNFT", "WrappedCeruleanNFT", ceruleanNFT.address],
        },
      },
    },
  });
};
module.exports = deployWrappedCeruleanNFT;
deployWrappedCeruleanNFT.tags = ["WrappedCeruleanNFT"];
deployWrappedCeruleanNFT.dependencies = ["CeruleanNFT"];

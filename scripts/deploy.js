
const hre = require("hardhat");

async function main() {
 

  

  const RedestaTokenFactory = await hre.ethers.getContractFactory("RedestaToken");
  const RedestaToken = await RedestaToken.deploy();

  await RedestaToken.deployed();

  console.log(
    `Redesta Token deployed to ${RedestaToken.address}`
  );

  const RedestaFactory = await hre.ethers.getContractFactory("Redesta");
  const Redesta = await Redesta.deploy(RedestaToken.address); 
  console.log("Redesta deployed to:", Redesta.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

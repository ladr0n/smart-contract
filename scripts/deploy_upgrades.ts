import { ethers, upgrades } from "hardhat";

async function main() {
  const verifyStr = "npx hardhat verify --network";
  // const USDT = "0x84f3eBe8048C5047b35bd2c70E1EEE4dC4b755b6"; // Arbitrum Goerli
  const USDT = "0x665f1c610b32bb793e9ae5f09ea5dddd0e407e1a"; // Polygon Mumbai
  const operator = "0xdC8CcBD393E80b91E7bbD93dd8513c50D51933f4";

  const HotTreasury = await ethers.getContractFactory("HotTreasury");
  const hotTreasury = await upgrades.deployProxy(HotTreasury, [USDT]);
  await hotTreasury.deployed();
  const hotTreasuryAddresses = {
    proxy: hotTreasury.address,
    admin: await upgrades.erc1967.getAdminAddress(hotTreasury.address),
    implementation: await upgrades.erc1967.getImplementationAddress(
      hotTreasury.address
    ),
  };
  console.log("HotTreasury Addresses:", hotTreasuryAddresses);
  await hotTreasury.addOperator(operator);

  const MainTreasury = await ethers.getContractFactory("MainTreasury");
  const mainTreasury = await upgrades.deployProxy(MainTreasury, [USDT, 604800]);
  await mainTreasury.deployed();
  const mainTreasuryAddresses = {
    proxy: mainTreasury.address,
    admin: await upgrades.erc1967.getAdminAddress(mainTreasury.address),
    implementation: await upgrades.erc1967.getImplementationAddress(
      mainTreasury.address
    ),
  };
  console.log("MainTreasury Addresses:", mainTreasuryAddresses);
  await mainTreasury.addOperator(operator);

  const Verifier = await ethers.getContractFactory("Verifier");
  const verifier = await upgrades.deployProxy(Verifier, [mainTreasury.address]);
  await verifier.deployed();
  const verifierAddresses = {
    proxy: verifier.address,
    admin: await upgrades.erc1967.getAdminAddress(verifier.address),
    implementation: await upgrades.erc1967.getImplementationAddress(
      verifier.address
    ),
  };
  console.log("Verifier Addresses:", verifierAddresses);

  await mainTreasury.setVerifier(verifier.address);

  const DepositWalletFactory = await ethers.getContractFactory(
    "DepositWalletFactory"
  );
  const depositWalletFactory = await DepositWalletFactory.deploy(
    hotTreasury.address
  );
  console.log("DepositWalletFactory:", depositWalletFactory.address);
  console.log(
    verifyStr,
    process.env.HARDHAT_NETWORK,
    depositWalletFactory.address,
    hotTreasury.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

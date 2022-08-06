import { ethers } from "hardhat";

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = ethers.utils.parseEther("1");

  // const Lock = await ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  // console.log("Lock with 1 ETH deployed to:", lock.address);

  console.log("Deploy Match, Matches Libraries");
  const Match = await ethers.getContractFactory("Match");
  const match = await Match.deploy();
  await match.deployed();

  const Matches = await ethers.getContractFactory("Matches", {
    libraries: {
      Match: match.address,
    }
  });
  const matches = await Matches.deploy();
  await matches.deployed();

  console.log("Deploy Manager Contract");
  const Manager = await ethers.getContractFactory("Manager", {
    libraries: {
      Match: match.address,
      Matches: matches.address,
    }
  });
  const manager = await Manager.deploy();
  await manager.deployed();
  console.log("Manager Contract deployed to: ", manager.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

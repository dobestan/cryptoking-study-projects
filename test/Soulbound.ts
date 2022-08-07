import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Soulbound", function () {
  async function deploySoulbound() {
    const [owner, otherAccount] = await ethers.getSigners();

    const Soulbound = await ethers.getContractFactory("Soulbound");
    const soulbound = await Soulbound.deploy();

    return { soulbound, owner, otherAccount };
  }

  describe("Deploy", function () {
    it("Should set the right owner", async function () {
        const { soulbound, owner } = await loadFixture(deploySoulbound);

        expect(await soulbound.owner()).to.equal(owner.address);
    });

    it("Should set REGISTERED token as non-transferable(Soulbounded)", async function () {
        const { soulbound, owner } = await loadFixture(deploySoulbound);
        expect(
            await soulbound.isTransferable(await soulbound.REGISTERED())
        ).to.be.false;
    });
  });
});

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

  describe("Register", function () {
        it("Should set the right registerer", async function () {
            const { soulbound, owner, otherAccount } = await loadFixture(deploySoulbound);
            
            expect(await soulbound.isRegistered(owner.address)).to.be.false;
            await soulbound.register(owner.address);
            expect(await soulbound.isRegistered(owner.address)).to.be.true;

            expect(await soulbound.isRegistered(otherAccount.address)).to.be.false;
            await soulbound.register(otherAccount.address);
            expect(await soulbound.isRegistered(otherAccount.address)).to.be.true;
        });

        it("Should revert with the right error if registered user calls register function", async function () {
            const { soulbound, owner, otherAccount } = await loadFixture(deploySoulbound);
            await soulbound.register(owner.address);
            expect(await soulbound.isRegistered(owner.address)).to.be.true;

            await expect(
                soulbound.register(owner.address)
            ).to.be.reverted;
        });
  });
});

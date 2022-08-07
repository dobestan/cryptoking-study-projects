import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Manager", function () {
    async function deployManager() {
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

        const [account1, account2] = await ethers.getSigners();

        const Manager = await ethers.getContractFactory("Manager", {
            libraries: {
                Match: match.address,
                Matches: matches.address,
            }
        });        
        const manager = await Manager.deploy();

        return { manager, account1, account2 };
    }

    describe("isMatched", function () {
        it("Should return right match result", async function () {
            const { manager, account1, account2 } = await loadFixture(deployManager);
            expect(await manager.isMatched(account1.address, account2.address)).to.be.false;
            
            // await manager.createMatch(account1.address, account2.address);
            // TODO: manager.creatematch is not callable.
            // Property 'createMatch' does not exist on type 'Manager'.
            // expect(await manager.isMatched(account1.address, account2.address)).to.be.true;
        });
    });
});

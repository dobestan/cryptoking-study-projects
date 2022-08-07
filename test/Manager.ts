import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Manager", function () {
    async function deployManager() {
        // Deploy Library
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

        // Deploy Manager Contract
        const Manager = await ethers.getContractFactory("Manager", {
            libraries: {
                Match: match.address,
                Matches: matches.address,
            }
        });        
        const manager = await Manager.deploy();
        await manager.deployed();

        const [account1, account2, account3] = await ethers.getSigners();
        return { manager, account1, account2, account3 };
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

    describe("getMatch", function () {
        it("Should return right match result", async function () {
            const { manager, account1, account2 } = await loadFixture(deployManager);
            // await manager.createMatch(account1.address, account2.address);
            // expect(await manager.getMatch(0)).to.be.equal(
            //     await manager.getMatch(account1.address, account2.address)
            // );
        });
    });
});

const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Mushrooms", function() {
    async function deployMetadataFixture() {
        const owner = await ethers.getSigners();
        const MetadataFactory = await ethers.getContractFactory("Metadata");
        const metadata = await MetadataFactory.deploy(owner[0].address);
        // await metadata.deployed();
        return { metadata }; 
    };

    // it("Should return the correct value", async function() {
    //     const { metadata } = await deployMetadataFixture();
    //     console.log("Metadata address: ", metadata.address);
    //     expect(await metadata.returnExtension()).to.equal("data:application/json;base64,");
    // });

    it("Should set the metadata", async function () {
        const { metadata } = await deployMetadataFixture();
        const data = {
            id: 1,
            spores: 0,
            backgroundColor: "blue",
            head: "round",
            eyes: "Wide",
            mouth: "Open",
            element: "Fire",
            weapon: "Axe",
            armor: "None",
            accessory: "Necklace",
            level: 3
        };
        console.log("Data: ", data);
        // const metadataString = JSON.stringify(data);
        const mushroomDataTxn = await metadata.setMushroomData(data, {nonce: 87});
        console.log("mushroom before");
        await mushroomDataTxn.wait();
        console.log("mushroom after");
        const returnData = await metadata.getMushroomData(1);
        console.log("return before");
        await returnData.wait();
        console.log("Return data: ", returnData);
        expect(data.backgroundColor).to.equal("blue");
    });
});
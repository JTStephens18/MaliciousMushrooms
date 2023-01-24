pragma solidity ^0.8.9;

interface IMetadata {
    struct Mushroom {
        uint256 id;
        uint32 spores;
        string backgroundColor;
        string head;
        string eyes;
        string mouth;
        string element;
        string weapon;
        string armor;
        string accessory;
        uint256 level;
    }

    function getMushroomData(uint256 _tokenId)
        external
        view
        returns (Mushroom memory);
}

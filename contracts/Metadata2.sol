pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// Access Control
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Helper functions from OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Metadata2 is ERC721Enumerable, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Address for address;
    using Base64 for bytes;

    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

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

    struct MushroomData2 {
        string element;
        string weapon;
        string armor;
        string accessory;
    }

    string[] private weapons = [
        "Axe",
        "Scythe",
        "Sword",
        "Spear",
        "Hammer",
        "Stick",
        "Dagger"
    ];

    string[] private armors = ["Helmet", "Chestplate", "Leggings", "Boots"];

    string[] private accessories = ["Ring", "Necklace", "Bracelet", "Earrings"];

    string[] private elements = [
        "Fire",
        "Poison",
        "Sulfur",
        "Ice",
        "Wood",
        "Earth"
    ];

    constructor(address admin) ERC721("MintingMushroom", "MM") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setData2(uint256 _tokenId)
        external
        view
        returns (MushroomData2 memory)
    {
        // require(hasRole(UPDATER_ROLE, msg.sender), "Caller is not a updater");
        string memory weapon = weapons[_tokenId % weapons.length];
        string memory armor = armors[_tokenId % armors.length];
        string memory accessory = accessories[_tokenId % accessories.length];
        string memory element = elements[_tokenId % elements.length];
        MushroomData2 memory mushroomData2 = MushroomData2(
            element,
            weapon,
            armor,
            accessory
        );
        return mushroomData2;
    }
}

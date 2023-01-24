// SPDX-License-Identifier MIT
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

struct MushroomData2 {
    string element;
    string weapon;
    string armor;
    string accessory;
}

interface IMetadata2 {
    function setData2(uint256 _tokenId)
        external
        view
        returns (MushroomData2 memory);
}

contract Metadata1 is ERC721Enumerable, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Address for address;
    using Base64 for bytes;

    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    IMetadata2 private M2Contract;

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

    mapping(uint256 => Mushroom) public mushroomAttributes;
    mapping(uint256 => string) public _tokenURIs;

    string[] private backgroundColors = [
        "red",
        "orange",
        "yellow",
        "green",
        "blue",
        "purple",
        "pink",
        "black",
        "white",
        "gray"
    ];

    string[] private heads = ["Round", "Oval", "Triangle", "Flat"];

    string[] private eyes = [
        "Eye 1",
        "Eye 2",
        "Eye 3",
        "Eye 4",
        "Eye 5",
        "Eye 6",
        "Eye 7",
        "Eye 8"
    ];

    string[] private mouths = [
        "Mouth 1",
        "Mouth 2",
        "Mouth 3",
        "Mouth 4",
        "Mouth 5",
        "Mouth 6",
        "Mouth 7",
        "Mouth 8"
    ];

    event part1Triggered(uint256 tokenId, string part1);
    event part1Got(uint256, Mushroom mushroom);
    event tokenURIFound(uint256 tokenId, string tokenURI);

    constructor(address admin, address metadata2)
        ERC721("MintingMushroom", "MM")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
        M2Contract = IMetadata2(metadata2);
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

    function handleMint(uint256 _tokenId) external {
        this.setData1(_tokenId);
        // this.makeTokenURI(_tokenId);
    }

    function setData1(uint256 _tokenId) external returns (string memory) {
        MushroomData2 memory test = M2Contract.setData2(_tokenId);
        string memory backgroundColor = backgroundColors[
            _tokenId % backgroundColors.length
        ];
        string memory head = heads[_tokenId % heads.length];
        string memory eye = eyes[_tokenId % eyes.length];
        string memory mouth = mouths[_tokenId % mouths.length];

        mushroomAttributes[_tokenId] = Mushroom(
            _tokenId,
            0,
            backgroundColor,
            head,
            eye,
            mouth,
            test.element,
            test.weapon,
            test.armor,
            test.accessory,
            0
        );

        string memory part1 = Base64.encode(
            abi.encodePacked(backgroundColor, "/", head, "/", eye, "/", mouth)
        );
        emit part1Triggered(_tokenId, part1);
        return part1;
    }

    function getData1(uint256 _tokenId) external returns (Mushroom memory) {
        return mushroomAttributes[_tokenId];
    }

    // function makeTokenURI(uint256 _tokenId) external returns (string memory) {
    //     Mushroom memory MushroomAttributesTemp = mushroomAttributes[_tokenId];
    //     string memory json = Base64.encode(
    //         abi.encodePacked(
    //             '{"name": "Mushroom #',
    //             Strings.toString(_tokenId),
    //             '", "description": "Malicious Mushrooms Rawr", "image": "',
    //             string(
    //                 abi.encodePacked(
    //                     _baseTokenURI,
    //                     MushroomAttributesTemp.backgroundColor,
    //                     MushroomAttributesTemp.head,
    //                     MushroomAttributesTemp.eyes,
    //                     MushroomAttributesTemp.mouth,
    //                     MushroomAttributesTemp.accessory,
    //                     MushroomAttributesTemp.weapon,
    //                     MushroomAttributesTemp.armor
    //                 )
    //             ),
    //             '" "attributes": [',
    //             '{"trait_type": "Weapon", "value": "',
    //             MushroomAttributesTemp.weapon,
    //             '"},',
    //             '{"trait_type": "Armor", "value": "',
    //             MushroomAttributesTemp.armor,
    //             '"},',
    //             '{"trait_type": "Accessory", "value": "',
    //             MushroomAttributesTemp.accessory,
    //             '"},',
    //             '{"trait_type": "Element", "value": "',
    //             MushroomAttributesTemp.element,
    //             '"},',
    //             '{"trait_type": "Level", "value": ',
    //             Strings.toString(MushroomAttributesTemp.level),
    //             // mushroomAttributes[_token.id].head,
    //             "},",
    //             '{"trait_type": "Spores", "value": ',
    //             Strings.toString(MushroomAttributesTemp.spores),
    //             // mushroomAttributes[_token.id].eyes,
    //             "}]}"
    //             // '{"name": "Mushroom #',
    //             // Strings.toString(_tokenId),
    //             // '", "description": "Malicious Mushrooms Rawr", "image": "https://ipfs.io/ipfs/QmR5tYrw1rqrKmNrma9BkfESag9PJhBCcNMhV31tZs5vZ1?filename=1.png"}'
    //         )
    //     );
    //     _tokenURIs[_tokenId] = string(
    //         abi.encodePacked("data:application/json;base64,", json)
    //     );
    //     return string(abi.encodePacked("data:application/json;base64,", json));
    // }

    // function setTokenURI(uint256 _tokenId, string memory _newTokenURI)
    //     internal
    //     returns (string memory)
    // {
    //     require(_exists(_tokenId), "Token must exist");
    //     // require(
    //     //     hasRole(UPDATER_ROLE, msg.sender),
    //     //     "Caller is not a updater role"
    //     // );
    //     _tokenURIs[_tokenId] = _newTokenURI;
    //     return _tokenURIs[_tokenId];
    // }

    // function getTokenURI(uint256 _tokenId)
    //     external
    //     view
    //     returns (string memory)
    // {
    //     return _tokenURIs[_tokenId];
    // }
}

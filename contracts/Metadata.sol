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

import "./IMetadata.sol";

contract Metadata is AccessControl, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Address for address;
    using Base64 for bytes;

    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    string public _baseTokenURI = "https://maliciousmushrooms.com/images/";
    string constant _dataUriExtension = "data:application/json;base64,";

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

    Mushroom[] public mushroomArray;

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
    }

    // function tokenURsssI(
    //     uint256 _tokenId,
    //     string memory _imageUrl,
    //     string memory _weapon,
    //     string memory _armor,
    //     string memory _accessory,
    //     string memory _element,
    //     uint256 _level,
    //     uint256 _spores
    // ) public view returns (string memory) {
    //     string memory json = Base64.encode(
    //         abi.encodePacked(
    //             '{"name": "Mushroom #',
    //             Strings.toString(_tokenId),
    //             '", "description": "Malicious Mushrooms Rawr", "image": "data:image/svg+xml;base64,',
    //             _imageUrl, // UPDATE TO ACTUAL IMAGE.... OR NOT
    //             '", "attributes": [',
    //             '{"trait_type": "Weapon", "value": "',
    //             _weapon,
    //             '"},',
    //             '{"trait_type": "Armor", "value": "',
    //             _armor,
    //             '"},',
    //             '{"trait_type": "Accessory", "value": "',
    //             _accessory,
    //             '"},',
    //             '{"trait_type": "Element", "value": "',
    //             _element,
    //             '"},',
    //             '{"trait_type": "Level", "value": ',
    //             Strings.toString(_level),
    //             "},",
    //             '{"trait_type": "Spores", "value": ',
    //             Strings.toString(_spores),
    //             "}"
    //         )
    //     );
    //     return string(abi.encodePacked("data:application/json;base64,", json));
    // }

    // function getTokenURI(
    //     uint256 tokenId,
    //     uint32 spores,
    //     string memory weapon,
    //     string memory armor,
    //     string memory accessory,
    //     string memory element,
    //     string memory ipfsImg
    // ) external view returns (string memory) {
    //     bytes memory json = abi.encodePacked(
    //         '{"Description": "Malicious Mushroom", "image": "',
    //         ipfsImg,
    //         '", "attributes": [{"display_type": "boost_number", "trait_type": "Spores", "value": "',
    //         Strings.toString(spores),
    //         '"}, {"trait_type": "Weapon", "value": "',
    //         weapon,
    //         '"}, {"trait_type": "Armor", "value": "',
    //         armor,
    //         '"}, {"trait_type": "Accessory", "value": "',
    //         accessory,
    //         '"}, {"trait_type": "Element", "value": "',
    //         element,
    //         '", } {"trait_type": "Level", "value": "',
    //         Strings.toString(1),
    //         '"}]}'
    //     );
    //     return string(abi.encodePacked(_dataUriExtension, Base64.encode(json)));
    // }

    function returnExtension() external pure returns (string memory) {
        return _dataUriExtension;
    }

    function setMushroomData(Mushroom memory mushroom)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[mushroom.id] = mushroom;
        mushroomArray.push(mushroom);
    }

    function getMushroomData(uint256 _tokenId)
        external
        returns (Mushroom memory)
    {
        return mushroomAttributes[_tokenId];
    }

    function getArray(uint256 _tokenId) external returns (Mushroom memory) {
        return mushroomArray[_tokenId - 1];
    }

    function incrementSpores(uint256 _tokenId, uint32 _spores)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].spores += _spores;
    }

    function decrementSpores(uint256 _tokenId, uint32 _spores)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].spores -= _spores;
    }

    function updateBackgroundColor(
        uint256 _tokenId,
        string memory backgroundColor
    ) external onlyRole(UPDATER_ROLE) {
        mushroomAttributes[_tokenId].backgroundColor = backgroundColor;
    }

    function updateHead(uint256 _tokenId, string memory head)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].head = head;
    }

    function updateEyes(uint256 _tokenId, string memory eyes)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].eyes = eyes;
    }

    function updateMouth(uint256 _tokenId, string memory mouth)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].mouth = mouth;
    }

    function updateArmor(uint256 _tokenId, string memory armor)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].armor = armor;
    }

    function updateAccessory(uint256 _tokenId, string memory accessory)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].accessory = accessory;
    }

    function updateWeapon(uint256 _tokenId, string memory weapon)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].weapon = weapon;
    }

    function updateElement(uint256 _tokenId, string memory element)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].element = element;
    }

    function incrementLevel(uint256 _tokenId, uint256 level)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].level += level;
    }

    function decrementLevel(uint256 _tokenId, uint256 level)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[_tokenId].level -= level;
    }

    function makeTokenURI(uint256 _tokenId, Mushroom memory mushroom)
        external
        onlyRole(UPDATER_ROLE)
        returns (string memory)
    {
        Mushroom memory MushroomAttributesTemp = mushroom;
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "Mushroom #',
                Strings.toString(_tokenId),
                '", "description": "Malicious Mushrooms Rawr", "image": "',
                string(
                    abi.encodePacked(
                        _baseTokenURI,
                        MushroomAttributesTemp.backgroundColor,
                        MushroomAttributesTemp.head,
                        MushroomAttributesTemp.eyes,
                        MushroomAttributesTemp.mouth,
                        MushroomAttributesTemp.accessory,
                        MushroomAttributesTemp.weapon,
                        MushroomAttributesTemp.armor
                    )
                ),
                '" "attributes": [',
                '{"trait_type": "Weapon", "value": "',
                MushroomAttributesTemp.weapon,
                '"},',
                '{"trait_type": "Armor", "value": "',
                MushroomAttributesTemp.armor,
                '"},',
                '{"trait_type": "Accessory", "value": "',
                MushroomAttributesTemp.accessory,
                '"},',
                '{"trait_type": "Element", "value": "',
                MushroomAttributesTemp.element,
                '"},',
                '{"trait_type": "Level", "value": ',
                Strings.toString(MushroomAttributesTemp.level),
                // mushroomAttributes[_token.id].head,
                "},",
                '{"trait_type": "Spores", "value": ',
                Strings.toString(MushroomAttributesTemp.spores),
                // mushroomAttributes[_token.id].eyes,
                "}]}"
                // '{"name": "Mushroom #',
                // Strings.toString(_tokenId),
                // '", "description": "Malicious Mushrooms Rawr", "image": "https://ipfs.io/ipfs/QmR5tYrw1rqrKmNrma9BkfESag9PJhBCcNMhV31tZs5vZ1?filename=1.png"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}

// string(
//                     abi.encodePacked(
//                         _baseTokenURI,
//                         mushroomAttributes[_token.id].backgroundColor,
//                         mushroomAttributes[_token.id].head,
//                         mushroomAttributes[_token.id].eyes,
//                         mushroomAttributes[_token.id].mouth,
//                         mushroomAttributes[_token.id].accessory,
//                         mushroomAttributes[_token.id].weapon,
//                         mushroomAttributes[_token.id].armor
//                     )
//                 ),

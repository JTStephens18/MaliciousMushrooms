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
        //string name;
        //string description;
        uint32 spores;
        string backgroundColor;
        string head;
        string eyes;
        string mouth;
        string element;
        string weapon;
        string armor;
        string accessory;
        // string background;
        // string aura;
        //string image;
        uint256 level;
    }

    mapping(uint256 => Mushroom) public mushroomAttributes;

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

    function setMushroomData(Mushroom calldata base)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomAttributes[base.id] = base;
    }

    function getMushroomData(uint256 _tokenId)
        external
        returns (Mushroom memory)
    {
        return mushroomAttributes[_tokenId];
    }

    function getElement(uint256 _tokenId)
        external
        view
        returns (string memory)
    {
        return mushroomAttributes[_tokenId].element;
    }

    function getMushroomBytes(uint256 _tokenId)
        external
        view
        returns (bytes memory)
    {
        return abi.encode(mushroomAttributes[_tokenId]);
    }

    function makeTokenURI(uint256 _tokenId)
        public
        onlyRole(UPDATER_ROLE)
        returns (string memory)
    {
        Mushroom memory MushroomAttributes = mushroomAttributes[_tokenId];
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "Mushroom #',
                Strings.toString(_tokenId),
                '", "description": "Malicious Mushrooms Rawr", "image": "',
                string(
                    abi.encodePacked(
                        _baseTokenURI,
                        mushroomAttributes[_tokenId].backgroundColor,
                        mushroomAttributes[_tokenId].head,
                        mushroomAttributes[_tokenId].eyes,
                        mushroomAttributes[_tokenId].mouth,
                        mushroomAttributes[_tokenId].accessory,
                        mushroomAttributes[_tokenId].weapon,
                        mushroomAttributes[_tokenId].armor
                    )
                ),
                '" "attributes": [',
                '{"trait_type": "Weapon", "value": "',
                mushroomAttributes[_tokenId].weapon,
                '"},',
                '{"trait_type": "Armor", "value": "',
                mushroomAttributes[_tokenId].armor,
                '"},',
                '{"trait_type": "Accessory", "value": "',
                mushroomAttributes[_tokenId].accessory,
                '"},',
                '{"trait_type": "Element", "value": "',
                mushroomAttributes[_tokenId].element,
                '"},',
                '{"trait_type": "Level", "value": ',
                Strings.toString(mushroomAttributes[_tokenId].level),
                // mushroomAttributes[_token.id].head,
                "},",
                '{"trait_type": "Spores", "value": ',
                Strings.toString(mushroomAttributes[_tokenId].spores),
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

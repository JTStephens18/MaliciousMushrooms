pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Access Control
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Helper functions from OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

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

interface IM1 {
    function getData1(uint256 _tokenId) external view returns (Mushroom memory);
}

contract TokenURI is ERC721URIStorage, AccessControl {
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    string public _baseTokenURI = "https://maliciousmushrooms.com/images/";
    string constant _dataUriExtension = "data:application/json;base64,";

    mapping(uint256 => string) public _tokenURIs;

    IM1 private M1Contract;

    constructor(address admin, address M1ContractAddress)
        ERC721("MintingMushroom", "MM")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
        M1Contract = IM1(M1ContractAddress);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function makeTokenURI(uint256 _tokenId) external returns (string memory) {
        Mushroom memory MushroomAttributesTemp = M1Contract.getData1(_tokenId);
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "Mushroom #',
                Strings.toString(_tokenId),
                '", "description": "Malicious Mushrooms Rawr", "image": "',
                string(
                    abi.encodePacked(
                        _baseTokenURI,
                        MushroomAttributesTemp.backgroundColor,
                        "/",
                        MushroomAttributesTemp.head,
                        "/",
                        MushroomAttributesTemp.eyes,
                        "/",
                        MushroomAttributesTemp.mouth,
                        "/",
                        MushroomAttributesTemp.accessory,
                        "/",
                        MushroomAttributesTemp.weapon,
                        "/",
                        MushroomAttributesTemp.armor
                    )
                ),
                '", "attributes": [',
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
        _tokenURIs[_tokenId] = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function setTokenURI(uint256 _tokenId, string memory _newTokenURI)
        internal
        returns (string memory)
    {
        require(_exists(_tokenId), "Token must exist");
        // require(
        //     hasRole(UPDATER_ROLE, msg.sender),
        //     "Caller is not a updater role"
        // );
        _tokenURIs[_tokenId] = _newTokenURI;
        return _tokenURIs[_tokenId];
    }

    function getTokenURI(uint256 _tokenId)
        external
        view
        returns (string memory)
    {
        return _tokenURIs[_tokenId];
    }
}

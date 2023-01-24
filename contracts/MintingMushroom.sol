// SPDX-License-Identifier: MIT
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

// import "./IMetadata.sol";

// interface IMetadata {
//     function tokenURI(
//         uint256 _tokenId,
//         string memory _imageUrl,
//         string memory _weapon,
//         string memory _armor,
//         string memory _accessory,
//         string memory _element,
//         uint256 _level,
//         uint256 _spores
//     ) external view returns (string memory);
// }

struct MushroomTest {
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
    function setData1(uint256 _tokenId) external returns (string memory);

    function getData1(uint256 _tokenId)
        external
        view
        returns (MushroomTest memory);

    function getTokenURI(uint256 _tokenId)
        external
        view
        returns (string memory);

    function handleMint(uint256 _tokenId) external;
}

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
        returns (MushroomTest memory);

    function makeTokenURI(uint256 _tokenId, MushroomTest memory mushroom)
        external
        returns (string memory);

    function _grantRole(bytes32 role, address account) external;
}

interface ITokenURI {
    function getTokenURI(uint256) external view returns (string memory);

    function makeTokenURI(uint256 _tokenId) external returns (string memory);
}

contract MintingMushroom is ERC721Enumerable, AccessControl, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Address for address;
    using Base64 for bytes;

    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    Counters.Counter private _tokenIds;
    mapping(uint256 => address) _tokenOwner;

    uint32 public _mintLimit = 1000;
    uint16 public _maxPerWallet = 100;
    uint256 public _mintPrice = 0.01 ether;

    IMetadata private _metadataContract;
    IM1 private M1Contract;
    ITokenURI private ITokenURIContract;

    // struct MushroomTest {
    //     uint256 id;
    //     uint32 spores;
    //     string backgroundColor;
    //     string head;
    //     string eyes;
    //     string mouth;
    //     string element;
    //     string weapon;
    //     string armor;
    //     string accessory;
    //     uint256 level;
    // }

    // Mapping of tokenID to the mushroom attributes
    mapping(uint256 => MushroomTest) public mushroomTokenAttributes;

    // event tokenURIMade(string tokenURI);
    event part1Made(uint256 tokenId, string part1);
    event part1Got(uint256, MushroomTest mushroom);
    event tokenURIFound(uint256 tokenId, string tokenURI);
    event tokenURIMade(string tokenURI);

    constructor(
        address admin,
        address metadataContract,
        address m1Contract,
        address tokenURIContract
    ) ERC721("Malicious Mushroom", "MUSH") {
        // Increment tokenIDs to start at 1
        _tokenIds.increment();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
        _metadataContract = IMetadata(metadataContract);
        M1Contract = IM1(m1Contract);
        ITokenURIContract = ITokenURI(tokenURIContract);
    }

    //overides
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // function _beforeTokenTransfer(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) internal virtual override(ERC721) {
    //     super._beforeTokenTransfer(from, to, tokenId);
    // }

    receive() external payable {}

    function mintNFT(address recipient, MushroomTest memory mushroom)
        public
        payable
        returns (uint256)
    {
        require(_tokenIds.current() < _mintLimit, "Mint limit reached");
        require(msg.value >= (_mintPrice), "Insufficient funds");
        require(
            balanceOf(msg.sender) < _maxPerWallet,
            "Max per wallet reached"
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _internalMint(recipient);
        // _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function _internalMint(address wallet) internal {
        uint256 newItemId = _tokenIds.current();
        require(newItemId < _mintLimit, "Mint limit reached");
        require(
            balanceOf(msg.sender) < _maxPerWallet,
            "Max per wallet reached"
        );
        // _mint(wallet, newItemId);
        M1Contract.handleMint(newItemId);
        string memory madeTokenURI = ITokenURIContract.makeTokenURI(newItemId);
        emit tokenURIMade(madeTokenURI);
        string memory tokenURIs = ITokenURIContract.getTokenURI(newItemId);
        emit tokenURIFound(newItemId, tokenURIs);
        _tokenIds.increment();
    }

    // function _internalMint(address wallet, MushroomTest memory mushroom)
    //     internal
    // {
    //     uint256 newItemId = _tokenIds.current();
    //     require(newItemId < _mintLimit, "Mint limit reached");
    //     require(
    //         balanceOf(msg.sender) < _maxPerWallet,
    //         "Max per wallet reached"
    //     );
    //     _mint(wallet, newItemId);
    //     mushroomTokenAttributes[newItemId] = MushroomTest({
    //         id: mushroom.id,
    //         backgroundColor: mushroom.backgroundColor,
    //         head: mushroom.head,
    //         eyes: mushroom.eyes,
    //         mouth: mushroom.mouth,
    //         spores: mushroom.spores,
    //         weapon: mushroom.weapon,
    //         armor: mushroom.armor,
    //         accessory: mushroom.accessory,
    //         element: mushroom.element,
    //         level: mushroom.level
    //     });
    //     string memory res = _metadataContract.makeTokenURI(newItemId, mushroom);
    //     emit tokenURIMade(res);
    //     _tokenIds.increment();
    // }

    // function setMintLimit(uint32 newLimit) external onlyRole(UPDATER_ROLE) {
    //     _mintLimit = newLimit;
    // }

    // function setMintPrice(uint256 newPrice) external onlyRole(UPDATER_ROLE) {
    //     _mintPrice = newPrice;
    // }

    // function setMaxPerWallet(uint16 newMax) external onlyRole(UPDATER_ROLE) {
    //     _maxPerWallet = newMax;
    // }

    function getTokenIds() external view returns (uint256) {
        return _tokenIds.current();
    }

    function freeMint(address toWallet, MushroomTest memory mushroom)
        external
        onlyRole(UPDATER_ROLE)
    {
        _internalMint(toWallet);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdrawBalance(address _to, uint256 _value)
        external
        onlyRole(UPDATER_ROLE)
    {
        require(_value <= address(this).balance, "Insufficient funds");
        payable(_to).transfer(_value);
    }

    // function checkIfHasNFT(address owner)
    //     external
    //     view
    //     returns (Mushroom[] memory nft)
    // {
    //     uint256 bal = balanceOf(owner);
    //     Mushroom[] memory nfts = new Mushroom[](bal);
    //     for (uint256 i = 0; i < bal; i++) {
    //         uint256 tokenId = tokenOfOwnerByIndex(owner, i);
    //         nfts[i] = mushroomTokenAttributes[tokenId];
    //     }
    //     return nfts;
    // }

    // function getMushroom(uint256 tokenId)
    //     external
    //     view
    //     returns (Mushroom memory mushroom)
    // {
    //     return mushroomTokenAttributes[tokenId];
    // }

    function increaseSpores(uint256 tokenId, uint32 amount)
        external
        onlyRole(UPDATER_ROLE)
    {
        // _metadataContract.mushroomAttributes(tokenId).spores += amount;
        // mushroomTokenAttributes[tokenId].spores += amount;
    }

    function decreaseSpores(uint256 tokenId, uint32 amount)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomTokenAttributes[tokenId].spores -= amount;
    }

    function increaseLevel(uint256 tokenId, uint256 amount)
        external
        onlyRole(UPDATER_ROLE)
    {
        mushroomTokenAttributes[tokenId].level += amount;
    }

    // function setWeapon(uint256 tokenId, string memory weapon)
    //     external
    //     onlyRole(UPDATER_ROLE)
    // {
    //     mushroomTokenAttributes[tokenId].weapon = weapon;
    // }

    // function setArmor(uint256 tokenId, string memory armor)
    //     external
    //     onlyRole(UPDATER_ROLE)
    // {
    //     mushroomTokenAttributes[tokenId].armor = armor;
    // }

    // function setAccessory(uint256 tokenId, string memory accessory)
    //     external
    //     onlyRole(UPDATER_ROLE)
    // {
    //     mushroomTokenAttributes[tokenId].accessory = accessory;
    // }

    // function setPet(uint256 tokenId, string memory pet)
    //     external
    //     onlyRole(UPDATER_ROLE)
    // {
    //     mushroomTokenAttributes[tokenId].pet = pet;
    // }

    // function setElement(uint256 tokenId, string memory element)
    //     external
    //     onlyRole(UPDATER_ROLE)
    // {
    //     mushroomTokenAttributes[tokenId].element = element;
    // }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return M1Contract.getTokenURI(_tokenId);
    }
}

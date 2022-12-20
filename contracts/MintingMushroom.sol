// SPDX-License-Identifier MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Access Control
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Helper functions from OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract MintingMushroom is ERC721, AccessControl, Ownable {
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

    struct Mushroom {
        uint256 id;
        //string name;
        //string description;
        uint32 spores;
        string element;
        //string image;
        uint256 level;
    }

    // Mapping of tokenID to the mushroom attributes
    mapping(uint256 => Mushroom) mushroomTokenAttributes;

    constructor(address admin) ERC721("Malicious Mushroom", "MUSH") {
        // Increment tokenIDs to start at 1
        _tokenIds.increment();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
    }

    //overides
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
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

    function mintNFT(address recipient) public payable returns (uint256) {
        require(_tokenIds.current() < _mintLimit, "Mint limit reached");
        require(msg.value >= (_mintPrice), "Insufficient funds");
        require(
            balanceOf(msg.sender) < _maxPerWallet,
            "Max per wallet reached"
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
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
        _mint(wallet, newItemId);
        mushroomTokenAttributes[newItemId] = Mushroom({
            id: newItemId,
            spores: 0,
            element: "Sulfur",
            level: 0
        });
        _tokenIds.increment();
    }

    function setMintLimit(uint32 newLimit) external onlyRole(UPDATER_ROLE) {
        _mintLimit = newLimit;
    }

    function setMintPrice(uint256 newPrice) external onlyRole(UPDATER_ROLE) {
        _mintPrice = newPrice;
    }

    function getTokenIds() external view returns (uint256) {
        return _tokenIds.current();
    }

    function freeMint(address toWallet) external onlyRole(UPDATER_ROLE) {
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

    function checkIfHasNFT() external view returns (uint32) {
        return mushroomTokenAttributes[1].spores;
    }
}

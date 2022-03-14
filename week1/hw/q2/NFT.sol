// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

import "./MerkleTree.sol";

contract NFT is ERC721, ERC721URIStorage, MerkleTree {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => bytes) private _tokenURIs;

    // constructor
    constructor(string memory name, string memory symbol, uint32 depth)
    ERC721(name, symbol) MerkleTree(depth) {}

    // keep track of token metadata
    function _setTokenURI(uint256 tid, bytes memory uri) internal {
        _tokenURIs[tid] = uri;
    }

    // mint nft
    function mint(address receiver, string memory name, string memory desc) public {
        uint256 tid = _tokenIds.current();
        _tokenIds.increment();
        _mint(receiver, tid);

        bytes memory metadata = abi.encodePacked(
            "{", name, desc, "}"
        );

        // store the metadata and add to merkle tree
        _setTokenURI(tid, metadata);
        addLeaf(keccak256(abi.encodePacked(msg.sender, receiver, tid, metadata)));
    }

    // get metadata
    function tokenURI(uint256 tid) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(tid), "given token id does not exist");
        return string(_tokenURIs[tid]);
    }

    // override the burn function to quiet the compiler
    function _burn(uint256 tid) internal override(ERC721, ERC721URIStorage) {
        super._burn(tid);
    }
}

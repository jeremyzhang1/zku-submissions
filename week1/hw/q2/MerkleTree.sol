// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MerkleTree {
    mapping(uint32 => bytes32) public nodes;
    bytes32 public rootNode;
    uint32 public depth;
    uint32 public nextLeaf;

    uint32 internal end;

    // constructor, takes in the depth of the tree
    constructor(uint32 _depth) {
        depth = _depth;
        end = uint32(2) ** depth;
    }

    // adds a leaf to the merkle tree, called in the nft minting contract
    function addLeaf(bytes32 newLeaf) internal {
        require(nextLeaf != end, "tree is full");
        nodes[nextLeaf] = newLeaf;
        updateTree(nextLeaf);
        nextLeaf++;
    }

    // update the tree by recalculating hashes after a leaf has been added
    function updateTree(uint32 newLeaf) internal {
        uint32 idx = newLeaf;
        uint32 dist = 0;
        bytes32 left;
        bytes32 right;
        uint32 tdepth;

        for (uint32 i = 0; i < tdepth; i++) {
            if (nextLeaf % 2 == 0) {
                left = nodes[idx];
                right = nodes[idx + 1];
            } else {
                left = nodes[idx - 1];
                right = nodes[idx];
            }

            tdepth = idx - dist;
            dist += uint32(2) ** i;
            idx = tdepth / 2 + dist;
            nodes[idx] = keccak256(abi.encodePacked(left, right));
        }
        rootNode = nodes[idx]; 
    }
}
pragma circom 2.0.0;

include "mimcsponge.circom";

template MerkleTree(n) {
    signal input leaves[n];
    signal output root;

    var nodes[2*n-1];
    component hash[n-1];

    // store the first layer of leaves
    for(var i = 0; i < n; i++) {
        nodes[i] = leaves[i];
    }

    // compute hashes for the parent's and subsequent layers
    for(var i = 0; i < n-1; i++) {
        hash[i] = MiMCSponge(2, 220, 1);
        hash[i].k <== 0;

        hash[i].ins[0] <== nodes[i*2];
        hash[i].ins[1] <== nodes[i*2+1];
        nodes[i+n] = hash[i].outs[0];
    }

    // root is the last component's output
    root <== nodes[n*2-2];

}

component main {public [leaves]} = MerkleTree(8);
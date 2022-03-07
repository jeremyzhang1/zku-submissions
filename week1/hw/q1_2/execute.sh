# compile the circuit
circom merkletree.circom --r1cs --wasm --sym --c

# compute the witness with WebAssembly
node ./merkletree_js/generate_witness.js ./merkletree_js/merkletree.wasm input.json witness.wtns

# start "powers of tau" ceremony
snarkjs powersoftau new bn128 14 pot14_0000.ptau -v

# contribute to the ceremony
snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution" -v

# start phase 2 of ceremony
snarkjs powersoftau prepare phase2 pot14_0001.ptau pot14_final.ptau -v

# generate a .zkey file
snarkjs groth16 setup merkletree.r1cs pot14_final.ptau merkletree_0000.zkey

# contribute to phase 2 of the ceremony
snarkjs zkey contribute merkletree_0000.zkey merkletree_0001.zkey --name="1st Contributor Name" -v

# export the verification key
snarkjs zkey export verificationkey merkletree_0001.zkey verification_key.json

# generate a proof
snarkjs groth16 prove merkletree_0001.zkey witness.wtns proof.json public.json

# verify a proof
snarkjs groth16 verify verification_key.json public.json proof.json

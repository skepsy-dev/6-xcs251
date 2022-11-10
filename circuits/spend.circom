include "./mimc.circom";

/*
 * IfThenElse sets `out` to `true_value` if `condition` is 1 and `out` to
 * `false_value` if `condition` is 0.
 *
 * It enforces that `condition` is 0 or 1.
 *
 */
template IfThenElse() {
    signal input condition;
    signal input true_value;
    signal input false_value;
    signal output out;
    signal net; 

    // TODO
    // Hint: You will need a helper signal...
    condition * (1 - condition) === 0;

    net <== (true_value - false_value) * condition;

    out <== false_value + net;
}

/*
 * SelectiveSwitch takes two data inputs (`in0`, `in1`) and produces two ouputs.
 * If the "select" (`s`) input is 1, then it inverts the order of the inputs
 * in the ouput. If `s` is 0, then it preserves the order.
 *
 * It enforces that `s` is 0 or 1.
 */
template SelectiveSwitch() {
    signal input in0;
    signal input in1;
    signal input s;
    signal output out0;
    signal output out1;

    // TODO
    component x = IfThenElse();

    component y = IfThenElse();

    x.condition <== s;
    x.true_value <== in1;
    x.false_value <== in0;

    y.condition <== s;
    y.true_value <== in0;
    y.false_value <== in1;

    out0 <== x.out;
    out1 <== y.out;

}

/*
 * Verifies the presence of H(`nullifier`, `nonce`) in the tree of depth
 * `depth`, summarized by `digest`.
 * This presence is witnessed by a Merle proof provided as
 * the additional inputs `sibling` and `direction`, 
 * which have the following meaning:
 *   sibling[i]: the sibling of the node on the path to this coin
 *               at the i'th level from the bottom.
 *   direction[i]: "0" or "1" indicating whether that sibling is on the left.
 *       The "sibling" hashes correspond directly to the siblings in the
 *       SparseMerkleTree path.
 *       The "direction" keys the boolean directions from the SparseMerkleTree
 *       path, casted to string-represented integers ("0" or "1").
 */
template Spend(depth) {
    signal input digest;
    signal input nullifier;
    signal private input nonce;
    signal private input sibling[depth];
    signal private input direction[depth];

    // TODO
    component hashes[1+depth];
    component selections[depth];

    hashes[0] = Mimc2();
    hashes[0].in0 <== nullifier;
    hashes[0].in1 <== nonce;

    for (var i = 0; i < depth; i++) {
        direction[i] * (1 - direction[i]) === 0

        selections[i] = SelectiveSwitch();
        selections[i].s <== direction[i];
        selections[i].in0 <== hashes[i].out;
        selections[i].in1 <== sibling[i]; // DBL Check this input

        hashes[i + 1] = Mimc2();
        hashes[i + 1].in0 <== selections[i].out0;
        hashes[i + 1].in1 <== selections[i].out1;

    }
    // checking to confirm the digest is equal to the hash of array of all hashes
    digest === hashes[depth].out;
 
}

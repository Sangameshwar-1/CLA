// Generate sum outputs (S)
// S_i = P_i XOR C_i
// This matches si.cir in SPICE
module si (
    input  wire [4:0] p,        // Propagate signals
    input  wire [4:0] c,        // Carry signals (c[0]=cin, c[1]=c1, c[2]=c2, c[3]=c3, c[4]=c4)
    output wire [4:0] s         // Sum outputs
);
    // Sum: S_i = P_i XOR C_i
    assign s[0] = p[0] ^ c[0];
    assign s[1] = p[1] ^ c[1];
    assign s[2] = p[2] ^ c[2];
    assign s[3] = p[3] ^ c[3];
    assign s[4] = p[4] ^ c[4];
endmodule
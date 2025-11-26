// Propagate for 5-bit CLA (using XOR)
// P_i = A_i XOR B_i
// This matches pi.cir in SPICE
module pi (
    input  wire [4:0] a,
    input  wire [4:0] b,
    output wire [4:0] p
);
    // P_i = A_i XOR B_i
    assign p[0] = a[0] ^ b[0];
    assign p[1] = a[1] ^ b[1];
    assign p[2] = a[2] ^ b[2];
    assign p[3] = a[3] ^ b[3];
    assign p[4] = a[4] ^ b[4];
endmodule
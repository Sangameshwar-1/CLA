// Generate inverted carry generate signals (G_bar)
// G_bar_i = NAND(A_i, B_i)
// This matches gi_bar.cir in SPICE
module gi (
    input  wire [4:0] a,
    input  wire [4:0] b,
    output wire [4:0] g_bar
);
    // G_bar_i = ~(A_i & B_i) = NAND(A_i, B_i)
    assign g_bar[0] = ~(a[0] & b[0]);
    assign g_bar[1] = ~(a[1] & b[1]);
    assign g_bar[2] = ~(a[2] & b[2]);
    assign g_bar[3] = ~(a[3] & b[3]);
    assign g_bar[4] = ~(a[4] & b[4]);
endmodule
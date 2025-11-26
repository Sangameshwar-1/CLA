// Carry Lookahead Logic for 5-bit CLA
// Uses inverted generates (G_bar) and produces carries using NAND-based logic
// This matches carry.cir in SPICE which uses NAND gates
module carry (
    input  wire [4:0] p,        // Propagate signals
    input  wire [4:0] g_bar,    // Generate signals (inverted)
    input  wire       c0,       // Carry input (Cin)
    output wire [4:0] c,        // Carry outputs c1, c2, c3, c4, cout
    output wire       cout
);

    // Internal signals for NAND-based implementation
    wire [4:0] g;               // Non-inverted generates
    wire       c1_inv;
    wire       c2_nand, c3_nand1, c3_nand2;
    wire       c4_nand1, c4_nand2, c4_nand3;
    wire       c5_nand1, c5_nand2, c5_nand3, c5_nand4;

    // Convert G_bar to G using inverters
    assign g[0] = ~g_bar[0];
    assign g[1] = ~g_bar[1];
    assign g[2] = ~g_bar[2];
    assign g[3] = ~g_bar[3];
    assign g[4] = ~g_bar[4];

    // C1 = G0 + P0·C0
    // Using: C1 = ~(~G0 & ~(P0·C0))
    assign c1_inv = ~(p[0] & c0);
    assign c[0] = ~(g_bar[0] & c1_inv);

    // C2 = G1 + P1·G0 + P1·P0·C0
    // Using NAND gates:
    assign c2_nand = ~(p[1] & g[0]);
    assign c[1] = ~(g_bar[1] & c2_nand & c1_inv);

    // C3 = G2 + P2·G1 + P2·P1·G0 + P2·P1·P0·C0
    // Using NAND gates:
    assign c3_nand1 = ~(p[2] & g[1]);
    assign c3_nand2 = ~(p[2] & p[1] & g[0]);
    assign c[2] = ~(g_bar[2] & c3_nand1 & c3_nand2 & c1_inv);

    // C4 = G3 + P3·G2 + P3·P2·G1 + P3·P2·P1·G0 + P3·P2·P1·P0·C0
    // Using NAND gates:
    assign c4_nand1 = ~(p[3] & g[2]);
    assign c4_nand2 = ~(p[3] & p[2] & g[1]);
    assign c4_nand3 = ~(p[3] & p[2] & p[1] & g[0]);
    assign c[3] = ~(g_bar[3] & c4_nand1 & c4_nand2 & c4_nand3 & c1_inv);

    // C5 (Cout) = G4 + P4·G3 + P4·P3·G2 + P4·P3·P2·G1 + P4·P3·P2·P1·G0 + P4·P3·P2·P1·P0·C0
    // Using NAND gates:
    assign c5_nand1 = ~(p[4] & g[3]);
    assign c5_nand2 = ~(p[4] & p[3] & g[2]);
    assign c5_nand3 = ~(p[4] & p[3] & p[2] & g[1]);
    assign c5_nand4 = ~(p[4] & p[3] & p[2] & p[1] & g[0]);
    assign cout = ~(g_bar[4] & c5_nand1 & c5_nand2 & c5_nand3 & c5_nand4 & c1_inv);

    assign c[4] = cout;

endmodule
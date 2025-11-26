// 5-bit Carry Lookahead Adder - Top Module
// Gate-level implementation matching CMOS-static-2 SPICE design
module cla_5bit (
    input  wire [4:0] a,        // 5-bit input A
    input  wire [4:0] b,        // 5-bit input B
    input  wire       cin,      // Carry input
    output wire [4:0] sum,      // 5-bit sum output
    output wire       cout      // Carry output
);

    // Internal signals
    wire [4:0] p;               // Propagate signals
    wire [4:0] g_bar;           // Generate signals (inverted)
    wire [4:0] c_internal;      // Internal carries
    wire [4:0] c_for_sum;       // Carries for sum calculation

    // Instantiate Generate (inverted) logic
    gi gi_inst (
        .a(a),
        .b(b),
        .g_bar(g_bar)
    );

    // Instantiate Propagate logic
    pi pi_inst (
        .a(a),
        .b(b),
        .p(p)
    );

    // Instantiate Carry Lookahead Unit
    carry carry_inst (
        .p(p),
        .g_bar(g_bar),
        .c0(cin),
        .c(c_internal),
        .cout(cout)
    );

    // Prepare carries for sum calculation: c_for_sum = {c4, c3, c2, c1, cin}
    assign c_for_sum = {c_internal[3:0], cin};

    // Instantiate Sum Logic
    si si_inst (
        .p(p),
        .c(c_for_sum),
        .s(sum)
    );

endmodule
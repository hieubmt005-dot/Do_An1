
module top  (

    input clk,
    input rst,
    input start,

    input [5:0] seed,

    output [5:0] idx_prime,

    output ena,
    output enb,

    output sel_0,
    output [1:0] sel_1,

    output finish

);

wire [5:0] rand_idx;
wire valid;

wire [5:0] fifo_out;
wire [5:0] perm_out;



RPG_D U0 (

    .clk(clk),
    .rst(rst),

    .seed(6'b101101),
    .rand_idx(rand_idx),
    .valid(valid)

);

RPG_E U1 (

    .clk(clk),
    .rst(rst),
    .start(start),

    .ena(ena),
    .enb(enb),

    .sel_0(sel_0),
    .sel_1(sel_1),

    .finish(finish)

);

RPG_B U2 (

    .clk(clk),
    .rst(rst),

    .ena(ena),
    .enb(enb),

    .sel_0(sel_0),

    .rand_idx(rand_idx),
    .perm_out(perm_out),

    .fifo_out(fifo_out)

);



RPG_C U3 (

    .clk(clk),
    .rst(rst),

    .idx(fifo_out),

    .sel_1(sel_1),

    .idx_prime(idx_prime),

    .idx0(),
    .idx1(),
    .rest()

);


RPG_A U4 (

    .clk(clk),
    .rst(rst),

    .idx_prime(idx_prime),

    .write_data(fifo_out),
    .we(valid),

    .perm_out(perm_out)

);

endmodule
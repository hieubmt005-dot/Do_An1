
module final (

    input clk,
    input rst,
    input start,


    output [5:0] idx_prime,

    output [7:0] raddr_RAM0,
    output [7:0] raddr_RAM1,

    output [7:0] raddr_p_RAM0,
    output [7:0] raddr_p_RAM1,

    output pwm,
    output sub,
output [3:0] power_trace,
    output finish_rpg,
    output finish_ntt

);



wire ena;
wire enb;

wire sel_0;
wire [1:0] sel_1;
wire [5:0] idx_prime;
wire [7:0] waddr_RAM0;
wire [7:0] waddr_p_RAM0;



wire [3:0] power_trace;
top RPG0 (

    .clk(clk),
    .rst(rst),
    .start(start),



    .ena(ena),
    .enb(enb),

    .sel_0(sel_0),
    .sel_1(sel_1),


    .idx_prime(idx_prime),

    .finish(finish_rpg)

);


addres_controller  ADDR0 (

    .clk(clk),
    .rst(rst),



    .addr_in(idx_prime),



    .enb(enb),

    .pwm(pwm),
    .sub(sub),



    .raddr_RAM0(raddr_RAM0),
    .raddr_RAM1(raddr_RAM1),

    .waddr_RAM0(waddr_RAM0),



    .raddr_p_RAM0(raddr_p_RAM0),
    .raddr_p_RAM1(raddr_p_RAM1),

    .waddr_p_RAM0(waddr_p_RAM0)

);



NTT_core NTT0 (

    .clk(clk),
    .rst(rst),
    .start(start),


    .raddr_p_RAM0(raddr_p_RAM0),
    .raddr_p_RAM1(raddr_p_RAM1),

    .waddr_p_RAM0(waddr_p_RAM0),



    .raddr_RAM0(raddr_RAM0),
    .raddr_RAM1(raddr_RAM1),

    .waddr_RAM0(waddr_RAM0),


    .power_trace_out(power_trace),
    .pwm(pwm),
    .sub(sub),

    .finish(finish_ntt)

);

endmodule
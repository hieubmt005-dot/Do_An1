

module addr_control_C (

    input clk,
    input rst,

    input pwm,
    input sub,

    output repl0,
    output repl1,
    output repl2,
    output repl3,
    output repl4,
    output repl5

);

assign repl0 = (pwm == 1'b1) ? 1'b1 : 1'b0;

assign repl1 = (pwm == 1'b1) ? 1'b0 : 1'b1;

assign repl2 = (pwm == 1'b1) ? 1'b0 : 1'b1;


assign repl3 = (sub == 1'b1) ? 1'b1 : 1'b0;

assign repl4 = (sub == 1'b1) ? 1'b0 : 1'b1;

assign repl5 = (sub == 1'b1) ? 1'b0 : 1'b1;

endmodule
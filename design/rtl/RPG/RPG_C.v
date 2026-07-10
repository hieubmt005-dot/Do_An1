

module RPG_C (

    input clk,
    input rst,



    input [5:0] idx,


    input [1:0] sel_1,


    output reg [5:0] idx_prime,

    output [5:0] idx0,
    output [5:0] idx1,
    output [5:0] rest

);


reg [5:0] rest_counter;

always @(posedge clk or posedge rst)
begin

    if(rst)
        rest_counter <= 6'd63;

    else
        rest_counter <= rest_counter - 1'b1;

end

assign rest = rest_counter;



wire comp0;

assign comp0 = (idx > rest);

wire [5:0] sub_out;

assign sub_out = idx - rest;



assign idx0 =
        (comp0) ? sub_out :
                  idx;


wire comp1;

assign comp1 = (rest > 6'h28);


wire and_out;

assign and_out = comp0 & comp1;

assign idx1 =
        (and_out) ? rest :
                    idx0;


always @(*)
begin

    case(sel_1)

        2'd0:
            idx_prime = idx0;

        2'd1:
            idx_prime = idx1;

        2'd2:
            idx_prime = rest;

        default:
            idx_prime = idx0;

    endcase

end

endmodule

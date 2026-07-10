

module RPG_A (

    input clk,
    input rst,

    input [5:0] idx_prime,

    input [5:0] write_data,
    input we,

    output [5:0] perm_out

);


reg [5:0] REG_FILE [0:63];

integer i;


always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        for(i=0;i<64;i=i+1)
            REG_FILE[i] <= i[5:0];

    end

    else if(we)
    begin



        REG_FILE[idx_prime] <= write_data;

    end

end


assign perm_out = REG_FILE[idx_prime];

endmodule

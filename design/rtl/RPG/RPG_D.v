
module RPG_D (

    input clk,
    input rst,


    input [5:0] seed,


    output reg [5:0] rand_idx,
    output reg valid

);

// LFSR REGISTER

reg [5:0] lfsr;


// FEEDBACK
// x^6 + x + 1


wire feedback;

assign feedback =
        lfsr[5] ^
        lfsr[0];


// BUFFER COUNTER

reg [2:0] bit_count;


// MAIN LOGIC


always @(posedge clk or posedge rst)
begin

    if(rst)
    begin



        if(seed == 6'd0)
            lfsr <= 6'b101101;
        else
            lfsr <= seed;


        rand_idx <= 6'd0;

        bit_count <= 3'd0;

        valid <= 1'b0;

    end

    else
    begin



        lfsr <= {
                    lfsr[4:0],
                    feedback
                };


        rand_idx <= {
                        rand_idx[4:0],
                        lfsr[0]
                     };


        if(bit_count == 3'd5)
        begin

            bit_count <= 3'd0;

            valid <= 1'b1;

        end

        else
        begin

            bit_count <= bit_count + 1'b1;

            valid <= 1'b0;

        end

    end

end

endmodule
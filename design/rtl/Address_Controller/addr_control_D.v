
module addr_control_D  (



    input [1:0] line,

    input [5:0] addr,

    input [6:0] addr_r1,
    input [6:0] addr_r12,

    input [7:0] count,
    input [7:0] count_r1,
    input [7:0] count_r12,


    output [7:0] addr0,
    output [7:0] addr1,
    output [7:0] addr2,
    output [7:0] addr3,
    output [7:0] addr4,
    output [7:0] addr5

);



assign addr0 = {line, addr};


assign addr1 = {2'b00, addr};


assign addr2 = {addr_r1[6], addr};



assign addr3 = count;



assign addr4 = {addr_r12[6], addr_r12[5:0]};



assign addr5 = {addr_r1[6], addr_r1[5:0]};

endmodule
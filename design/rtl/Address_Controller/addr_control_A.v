
module addr_control_A  (



    input [7:0] raddr_RAM0,
    input [7:0] raddr_RAM1,
    input [7:0] raddr_RAM2,

    input [7:0] waddr_RAM0,
    input [7:0] waddr_RAM2,

    input [7:0] raddr_ROM_r1,



    input [7:0] addr0,
    input [7:0] addr1,
    input [7:0] addr2,
    input [7:0] addr3,
    input [7:0] addr4,
    input [7:0] addr5,



    input repl0,
    input repl1,
    input repl2,
    input repl3,
    input repl4,
    input repl5,



    output [7:0] raddr_p_RAM0,
    output [7:0] raddr_p_RAM1,
    output [7:0] raddr_p_RAM2,

    output [7:0] waddr_p_RAM0,
    output [7:0] waddr_p_RAM2,

    output [7:0] raddr_p_ROM_r1

);

assign raddr_p_RAM0 = (repl0) ? addr0 : raddr_RAM0;

assign raddr_p_RAM1 = (repl1) ? addr1 : raddr_RAM1;

assign raddr_p_RAM2 = (repl2) ? addr2 : raddr_RAM2;

assign waddr_p_RAM0 = (repl3) ? addr3 : waddr_RAM0;

assign waddr_p_RAM2 = (repl4) ? addr4 : waddr_RAM2;

assign raddr_p_ROM_r1 = (repl5) ? addr5 : raddr_ROM_r1;

endmodule
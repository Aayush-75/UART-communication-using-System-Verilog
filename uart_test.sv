`timescale 1ns/1ns

class test;
bit rst;
rand bit [0:7]data;

constraint sii {
  data > 8;
  data < 250;
}

function void disp();
  $display("random data = %b",data);
endfunction

task apanainput(
input logic clk,
output logic rst,
output logic [0:7]data
);
begin
rst = this.rst;
data = this.data;

end
endtask
endclass


module uart_test();
logic clk,rst,tx,tx_out;
logic [0:7]data;

uart dut (
	.clk(clk),
	.rst(rst),
	.tx(tx),
	.tx_out(tx_out),
	.data(data)
);

initial
begin
clk=0;
forever #5 clk=!clk;
end
test t1,t2[3];
initial begin

t1 = new();
t1.rst = 1'b1;
t1.apanainput(clk,rst,data);
#50;
for(int i =0;i<5;i++) begin
  t2[i] = new();
  t2[i].rst = 0;
  if(t2[i].randomize()) begin
    t2[i].disp();
    t2[1].apanainput(clk,rst,data);
    #200;
    t2[i].rst = 1;
    t2[1].apanainput(clk,rst,data);
    #20;
  end
  else
    $display("failled");
end
end
endmodule

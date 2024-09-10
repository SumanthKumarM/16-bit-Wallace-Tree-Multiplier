`include "mult.v"
module tb;
wire [31:0]mult;
wire carry;
reg [15:0]a,b;
wallace_tree_multiplier WTM(mult,carry,a,b);
initial begin
    $monitor("a=%d b=%d carry=%b mult=%d",a,b,carry,mult);
    {a,b}=0;
    repeat(20) begin
        #5 a={$urandom}%65536;
        b={$urandom}%65536;
    end
    #5 $finish;
end
endmodule

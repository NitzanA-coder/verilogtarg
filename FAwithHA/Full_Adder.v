module Full_Adder(
input wire a,
input wire b,
input wire c_in,
output wire sum,
output wire carry
);
wire sumHA1;
wire carryHA1;
wire carryHA2;

HA HA1(
.a(a),
.b(b),
.sum(sumHA1),
.carry(carryHA1));

HA HA2(
.a(c_in),
.b(sumHA1),
.sum(sum),
.carry(carryHA2));

assign carry = carryHA1 | carryHA2; //or to get the total carry
endmodule

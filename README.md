# 16-bit-Wallace-Tree-Multiplier
Wallace Tree multiplier is an architecture specialized to perform binary multiplication at higher speeds which makes this multiplier one of the fastest multipliers. As the architecture is fixed this multiplier is not area efficient but at the same time it is time efficient. This architecture involves three steps to perform binary multiplication.

1) Partial product generation :- In any binary multiplication first step is to produce partial products which are further reduced according to the architecture.
2) Reduction of partial products :- Every consecutive sets of 3 rows of partial products are reduced to thier corresponding sum and carry array using a series of half adders and full adders. Then again every consecutive sets of 3 rows of these sum and carry arrays from previous stage are reduced into sum and carry array using series of half and full adders. This process is repeated until there is a final sum and carry array.
3) Summation of final sum and carry array :- A binary adder is used to calculate the sum of this final sum and carry array to give the final product bits. In this multiplier Carry Look Ahead adder was used in the final stage for summation of sum and carry array.

Linting of RTL, synthesis and simulation were carried out in Xilinx Vivado.

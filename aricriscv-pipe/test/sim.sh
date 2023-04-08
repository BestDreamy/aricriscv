echo "Compilation start"
iverilog -o tb testbench.v 

echo "Generate wave"
vvp -n tb

echo "View wave"
gtkwave wave.vcd

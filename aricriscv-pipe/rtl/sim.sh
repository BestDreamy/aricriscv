echo "Compilation starts"

iverilog -o top_cpu top_cpu.v

echo "Generate waveforms"

vvp -n ./top_cpu

echo "View waveforms"

gtkwave wave.vcd

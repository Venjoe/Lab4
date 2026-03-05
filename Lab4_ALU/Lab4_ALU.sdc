# Lab4_ALU basic timing constraints
# The design is combinational; define a base clock for STA context.
create_clock -name base_clk -period 20.000 [get_ports {KEY[0]}]

# Constrain top-level I/O relative to the base clock.
set_input_delay  0.000 -clock base_clk [get_ports {SW[*]}]
set_input_delay  0.000 -clock base_clk [get_ports {KEY[*]}]
set_output_delay 0.000 -clock base_clk [get_ports {LEDR[*]}]

derive_clock_uncertainty

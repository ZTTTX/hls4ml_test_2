# Define project settings
# set XPART xcu250-figd2104-2L-e

set XPART xcu280-fsvh2892-2L-e
set CSIM 1
set CSYNTH 1
set COSIM 1
set VIVADO_SYN 1
set VIVADO_IMPL 0
set PROJ_ROOT "/mnt/shared/home/tz32/models/HLS_projects/KERAS-1layer-hls"  
set CUR_DIR "${PROJ_ROOT}/test1"


set PROJ "conv2d_project.prj"
set SOLN "sol"

if {![info exists CLKP]} {
  set CLKP 3.3333
}

# Open or reset the HLS project
open_project -reset $PROJ

# Add source and testbench files
add_files "${CUR_DIR}/uut_top.cpp" -cflags "-fpermissive -std=c++11 -I${PROJ_ROOT}/firmware/nnet_utils"
add_files -tb "${CUR_DIR}/testbench.cpp" -cflags "-fpermissive -std=c++11 -I${PROJ_ROOT}/firmware/nnet_utils"

# Set the top function for HLS
set_top uut_top

# Open or reset the solution
open_solution -reset $SOLN

# Set FPGA part and create clock
set_part $XPART
create_clock -period $CLKP

# Run C simulation
if {$CSIM == 1} {
  csim_design -argv "${CUR_DIR}/data/"
}

# Run C synthesis
if {$CSYNTH == 1} {
  csynth_design
}

# Run Cosimulation
if {$COSIM == 1} {
  cosim_design -argv "${CUR_DIR}/data/"
}

# Run Vivado Synthesis (if desired)
if {$VIVADO_SYN == 1} {
  export_design -flow syn -rtl verilog
}

# Run Vivado Implementation (if desired)
if {$VIVADO_IMPL == 1} {
  export_design -flow impl -rtl verilog
}

# Exit the HLS tool
exit

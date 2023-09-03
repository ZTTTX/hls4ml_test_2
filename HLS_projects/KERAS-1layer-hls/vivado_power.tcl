# Define where your generated RTL is located
set project_path "./test1/conv2d_project.prj/sol/impl/verilog/project.xpr"

# Open the Vivado project (this assumes that you've already created a Vivado project that includes the RTL exported by Vitis HLS)
open_project $project_path

# Check if the run exists, and if so, reset it before synthesizing again
#if {[get_runs synth_1] != ""} {
#    reset_run synth_1
#}
#launch_runs synth_1
#wait_on_run synth_1

open_run  synth_1

# Now, run power estimation
report_power -file power_report.pwr


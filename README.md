source /opt/xilinx/vitis/v2022p2/Vitis/2022.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/opt/xilinx/platforms
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LIBRARY_PATH

vitis_hls -f run_hls.tcl

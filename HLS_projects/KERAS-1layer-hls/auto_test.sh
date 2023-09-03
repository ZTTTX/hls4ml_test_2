#!/bin/bash

# Base Directory
BASE_DIR="$(pwd)"

# Directory paths
TEST_DIR="$BASE_DIR/test1"
RESULTS_DIR="$BASE_DIR/auto_test_results"
REPORT_FILE="$TEST_DIR/conv2d_project.prj/sol/syn/report/uut_top_csynth.xml"
REPORT_FILE_RPT="$TEST_DIR/conv2d_project.prj/sol/syn/report/uut_top_csynth.rpt"
POWER_FILE="$BASE_DIR/power_report.pwr"
# Array of values for the parameters
in_height_values=(32 64 128)
in_width_values=(32 64 128)
n_chan_values=(2)
filt_height_values=(2 4)
filt_width_values=(2 4)
n_filt_values=(2)
out_height_values=(10)
out_width_values=(10)

# in_height_values=(10)
# in_width_values=(10)
# n_chan_values=(1)
# filt_height_values=(1)
# filt_width_values=(1)
# n_filt_values=(1)
# out_height_values=(10)
# out_width_values=(10)

remove_all_data_flag=0

if (($remove_all_data_flag == 1))
then
    echo "Remove all existing collected results"
    rm -r $RESULTS_DIR/*
fi

# Loop through all combinations of the arrays
for in_height in "${in_height_values[@]}"
do
    for in_width in "${in_width_values[@]}"
    do
        for n_chan in "${n_chan_values[@]}"
        do
            for filt_height in "${filt_height_values[@]}"
            do
                for filt_width in "${filt_width_values[@]}"
                do
                    for n_filt in "${n_filt_values[@]}"
                    do
                        for out_height in "${out_height_values[@]}"
                        do
                            for out_width in "${out_width_values[@]}"
                            do
                                # Generate params.hpp with the current values
                                cat > "$TEST_DIR/params.hpp" <<EOL
struct t_config : nnet::conv2d_config {
    typedef float bias_t;
    typedef float weight_t;
    static const unsigned in_height = $in_height;
    static const unsigned in_width = $in_width;
    static const unsigned n_chan = $n_chan;
    static const unsigned filt_height = $filt_height;
    static const unsigned filt_width = $filt_width;
    static const unsigned n_filt = $n_filt;
    static const unsigned stride_height = 1;
    static const unsigned stride_width = 1;
    static const unsigned out_height = $out_height;
    static const unsigned out_width = $out_width;
};
EOL

                                # Navigate to test1 and run the command
                                echo "======================="
                                echo "NOW RUNNING inH${in_height}_inW${in_width}_nChan${n_chan}_fH${filt_height}_fW${filt_width}_nFilt${n_filt}_outH${out_height}_outW${out_width}"
                                echo "======================="

                                cd "$TEST_DIR"
                                vitis_hls -f run_hls.tcl

                                BASE_FILENAME="uut_top_csynth_inH${in_height}_inW${in_width}_nChan${n_chan}_fH${filt_height}_fW${filt_width}_nFilt${n_filt}_outH${out_height}_outW${out_width}"

                                # Navigate back
                                cd "$BASE_DIR"

                                # Check if report file exists
                                if [ -f "$REPORT_FILE" ]; then
                                    # Copy and rename the report file
                                    cp "$REPORT_FILE" "$RESULTS_DIR/${BASE_FILENAME}.xml"
                                else
                                    echo "ERROR: $REPORT_FILE does not exist!"
                                fi

                                if [ -f "$REPORT_FILE_RPT" ]; then
                                    # Copy and rename the RPT report file
                                    cp "$REPORT_FILE_RPT" "$RESULTS_DIR/${BASE_FILENAME}.rpt"
                                else
                                    echo "ERROR: $REPORT_FILE_RPT does not exist!"
                                fi
                                
                                vivado -mode batch -source vivado_power.tcl

                                if [ -f "$POWER_FILE" ]; then
                                    # Copy and rename the RPT report file
                                    cp "$POWER_FILE" "$RESULTS_DIR/${BASE_FILENAME}.pwr"
                                else
                                    echo "ERROR: $POWER_FILE does not exist!"
                                fi

                                echo "======================="
                                echo "RUN DONE FOR inH${in_height}_inW${in_width}_nChan${n_chan}_fH${filt_height}_fW${filt_width}_nFilt${n_filt}_outH${out_height}_outW${out_width}"
                                echo "======================="
                            done
                        done
                    done
                done
            done
        done
    done
done

rm -r ./*.log
rm -r ./*.jou
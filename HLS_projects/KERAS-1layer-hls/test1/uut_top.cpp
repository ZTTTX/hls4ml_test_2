#include "uut_top.hpp"



void uut_top(
    float input[t_config::in_height * t_config::in_width * t_config::n_chan],
    float output[t_config::out_height * t_config::out_width * t_config::n_filt],
    t_config::weight_t weights[t_config::filt_height * t_config::filt_width * t_config::n_chan * t_config::n_filt],
    t_config::bias_t biases[t_config::n_filt]
) {
    #pragma HLS INTERFACE s_axilite port=return bundle=CRTL_BUS
    // Call the conv_2d function
    nnet::conv_2d_latency_cl<float, float, t_config>(input, output, weights, biases);
}



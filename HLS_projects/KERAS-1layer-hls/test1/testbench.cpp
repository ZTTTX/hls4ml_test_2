#include <iostream>
#include <cstdlib>
#include "uut_top.hpp"

// Function to print the output (useful for debugging and manual inspection)
void print_output(float output[t_config::out_height * t_config::out_width * t_config::n_filt]) {
    for(unsigned i = 0; i < 10; i++) {
        std::cout << output[i] << " ";
    }
    std::cout << std::endl;
}

int main() {
    // Random seed for consistent results
    std::srand(42);

    // Declare and initialize arrays
    float input[t_config::in_height * t_config::in_width * t_config::n_chan];
    float output[t_config::out_height * t_config::out_width * t_config::n_filt];
    t_config::weight_t weights[t_config::filt_height * t_config::filt_width * t_config::n_chan * t_config::n_filt];
    t_config::bias_t biases[t_config::n_filt];

    // Populate arrays with random values
    for (unsigned i = 0; i < t_config::in_height * t_config::in_width * t_config::n_chan; i++) {
        input[i] = (float) std::rand() / RAND_MAX;  // Random values between 0 and 1
    }
    for (unsigned i = 0; i < t_config::filt_height * t_config::filt_width * t_config::n_chan * t_config::n_filt; i++) {
        weights[i] = (t_config::weight_t) std::rand() / RAND_MAX;
    }
    for (unsigned i = 0; i < t_config::n_filt; i++) {
        biases[i] = (t_config::bias_t) std::rand() / RAND_MAX;
    }

    // Call the UUT
    uut_top(input, output, weights, biases);

    // Print the output (For manual inspection)
    std::cout << "Output:" << std::endl;
    print_output(output);

    // Verification would be more specific based on the expected behavior of the IP.
    // It might involve a golden model or known results for certain inputs.

    return 0;
}

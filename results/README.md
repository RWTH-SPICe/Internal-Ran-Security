# Evaluation of Security-Induced Latency in 5G RAN Interfaces and User Plane Communication

## Results

This directory contains the results of the performed experiments in the paper. All results (apart from the benchmark experiment) are in the form of a .txt file that includes all the given parameters, each performed measurement and the resulting statistical data such as the average, the standard deviation and the 99%-confidence interval.

### Benchmark test results

This directory contains a singular .csv results file that contains the results of the benchmark experiment.

### F1-C UE Registration and E1 UE registration results

Those directories contain the results of the Control Plane Internal RAN experiments. In addition to the results of 1000 repetitions of the respective procedures, they include results of the experiment that measures the overhead of our socat setup in the DTLS scenario. In order to account for this overhead, the resulting amount is substracted from each DTLS result.
In addition to the extracted measurements in .txt files, each iteration of the experiment can be seen in the given .pcap file.

### F1-U latency and F1-U throughput results

Those directories contain the results of the respective User Plane Internal RAN experiments.
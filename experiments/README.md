# Evaluation of Security-Induced Latency in 5G RAN Interfaces and User Plane Communication

## Experiments

Currently, there are four experiments:
**E1 UE Registration** ,
**F1-C UE registration**,
**F1-U latency (ping)**,
**F1-U throughput (iperf)**,
**Benchmark test**


### Usage

Before running an experiment, change the parameters in the corresponding measure script. Additionally, include the path to the docker compose file that you want to use for the experiment (depending on the desired setup).

You can use the measure-it.sh script to feed the desired parameters as arguments when running the script.

If you want to make changes to a setup, do so in the setups directory and make sure you run the build script. Changes are directly applied to the experiment. Therefore, be careful not change something while an experiment is running.

### E1 UE Registration

This experiment measures the latency overhead that is visible on the E1 interface (between CU-UP and CU-CP) when a UE registers in the network. This experiment needs to be run in sudo mode in order to be able to extract results.

### F1-C UE Registration

This experiment measures the latency overhead that is visible on the F1-C interface (between DU and CU-CP) when a UE registers in the network. This experiment needs to be run in sudo mode in order to be able to extract results.

### F1-U ping

This experiment measures the latency overhead on User Plane data that is apparent on the F1-U interface (between DU and CU-UP) when dummy data is being sent over the network using ping.

### F1-U throughput

This experiment measures the impact on achievable throughput on User Plane data that is apparent on the F1-U interface (between DU and CU-UP) using an iperf3 server and client.

### Benchmark test

This experiment measures the speed of cryptographic operations for different cypher suites.

## Requirements

In order to run the experiments, the following dependencies are required:
```
- Wireshark (must include TShark)
- Python 3.10+
- pyshark
```
# Evaluation of Security-Induced Latency in 5G RAN Interfaces and User Plane Communication

This repository provides setups and experiments used for the evaluation of different 5G split with different optional security measures applied on top of their interfaces.

## Repository Structure

The repository consists of the following main directories:

### 1. `setups`


Each subdirectory within each scenario represents a different Network Layer Security protocol (except base), with custom Docker images and corresponding Docker Compose files for easy setup and deployment.

- **Usage:** For instructions on how to use the setups, please refer to the [README](./setups/README.md) in the `setups` directory.

### 2. `experiments`
This directory includes the experiments. The Docker images defined in the `setups` directory are required and used. Each subdirectory within `experiments` represents a different experiment.

- **Usage:** More information about running the experiments can be found in the [README](./experiments/README.md) in the `experiments` directory.

### 3. `results`
This directory includes the results from the given experiments and presented in the paper. 

- **Usage:** More information about the results can be found in the [README](./results/README.md) in the `results` directory.

## Getting Started

To get started with this repository, follow these steps:

1. **Clone the repository.**

2. **Navigate to the `setups` directory:**
   ```sh
   cd setups
   ```

3. **Follow the instructions in the [setups README](./setups/README.md) to initialize the required setups.**

4. **Navigate to the `experiments` directory:**
   ```sh
   cd ../experiments
   ```

5. **Choose an experiment and carefully read the [experiments README](./experiments/README.md).**

## Citation

If you use this work in your research or project, please cite the following paper:

```bibtex
@inproceedings{michaelides2026ransecurity,
  author = {Michaelides, Sotiris and Lapawa, Jakub and Eguiguren, Daniel and Henze, Martin},
  title = {{Evaluation of Security-Induced Latency on 5G RAN Interfaces and User Plane Communication}},
  booktitle = {Proceedings of the 19th ACM Conference on Security and Privacy in Wireless and Mobile Networks (WiSec)},
  year = {2026}
}

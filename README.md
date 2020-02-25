# EEG-based detection of the locus of auditory attention with convolutional neural networks

This repo contains the code for [EEG-based detection of the locus of auditory attention with convolutional neural networks](https://elifesciences.org/articles/56481).

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations. By downloading and/or installing this software and associated files on your computing system you agree to use the software under the terms and condition as specified in the License agreement.

## Requirements

- MATLAB 2016b
- MatConvNet 1.0-beta25

## Setup

- [Download MatConvNet 1.0-beta25](https://www.vlfeat.org/matconvnet/)
- Extract `matconvnet-1.0-beta25` to the base directory (see [Directory Structure](#Directory-Structure))
- Install MatConvNet 1.0-beta25 (see [Installing and compiling the library](https://www.vlfeat.org/matconvnet/install/))
- Download the "Auditory Attention Detection Dataset KULeuven" dataset from https://zenodo.org/record/3377911 (Skip the stimuli - this model only uses EEG)
- Extract the dataset to `data/raw/AAD2015_128hz/`

## How to run

Run `src/main.m`

- Trained models are saved in `models/<name of experiment>/`
- Results are saved in `results/<name of experiment>/`

## Directory Structure

- `data/`
    - `raw/`
        - `AAD2015_128hz/`: dataset (not included)
            - `S1.mat`
            - ...
            - `S16.mat`
- `matconvnet-1.0-beta25/`: MatConvNet source files (not included)
- `models/`: trained models, in MatConvNet format. Each MAT-file contains a struct with weights and with various metadata.
    - `paper/`: models used to generate the results in the paper
- `results/`: experiment results
- `src/`
    - `+data/`: data loading and preprocessing code
    - `+model/`: model initialization, training, and testing code
    - `+utils/`: various utility functions

#!/bin/bash

ENV=${1:-tf-test}

source "$HOME/miniconda3/etc/profile.d/conda.sh"

conda create --name "$ENV" python=3.11.5
conda activate "$ENV"

python3 -m pip install 'tensorflow[and-cuda]'

conda install cudatoolkit=11.8
export LD_LIBRARY_PATH="$HOME/miniconda3/envs/$ENV/lib"
conda install cudnn=8.9

python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

#!/bin/bash

LOCAL=0

# -----BASE 2.0 EXPERIMENTS------
#EXPERIMENT_NAME="U_tadgan_2.0"
#DATASETS="univariate_datasets"
#PIPELINES="{'tadgan':'tadgan'}"
#GPU=0

#EXPERIMENT_NAME="M_tadgan_2.0"
#DATASETS="multivariate_datasets"
#PIPELINES="{'tadgan':'tadgan'}"
#GPU=0

#EXPERIMENT_NAME="U_tadgan_2.0_gpu"
#DATASETS="univariate_datasets"
#PIPELINES="{'tadgan':'tadgan_gpu'}"
#GPU=1

#EXPERIMENT_NAME="M_tadgan_2.0_gpu"
#DATASETS="multivariate_datasets"
#PIPELINES="{'tadgan':'tadgan_gpu'}"
#GPU=1


# -----BASE 2.0 + ATTENTION LAYER EXPERIMENTS------
#EXPERIMENT_NAME="U_tadgan_2.0_attention"
#DATASETS="univariate_datasets"
#PIPELINES="{'tadgan':'tadgan_attention'}"
#GPU=0

#EXPERIMENT_NAME="M_tadgan_2.0_attention"
#DATASETS="multivariate_datasets"
#PIPELINES="{'tadgan':'tadgan_attention'}"
#GPU=0

#EXPERIMENT_NAME="U_tadgan_2.0_attention_gpu"
#DATASETS="univariate_datasets"
#PIPELINES="{'tadgan':'tadgan_attention_gpu'}"
#GPU=1

#EXPERIMENT_NAME="M_tadgan_2.0_attention_gpu"
#DATASETS="multivariate_datasets"
#PIPELINES="{'tadgan':'tadgan_attention_gpu'}"
#GPU=1


# -----TRANSFORMER ENCODER EXPERIMENTS------

# pipelines = {
#     'tadgan': 'tadgan_encoder_downsample',
#     'tadgan': 'tadgan_encoder_downsample_1000',
#     'tadgan': 'tadgan_encoder_downsample_optimizer',
#     'tadgan': 'tadgan_encoder_downsample_optimizer_1000',
#     'tadgan': 'tadgan_transformer',
#     'tadgan': 'tadgan_transformer_optimizer',
#     'tadgan': 'tadgan_encoder_downsample_multi_gen',
#     'tadgan': 'tadsgan'
#     'tadgan': 'tadgan_2.0_complete_encoder'
# }

echo "$EXPERIMENT_NAME"
if [[ $LOCAL = 1 ]]; then
    python experiments.py "$EXPERIMENT_NAME" "$DATASETS" "$PIPELINES"
else
    if [[ $GPU = 0 ]]; then
        sed -e "s/\$EXPERIMENT_NAME/$EXPERIMENT_NAME/" \
            -e "s/\$DATASETS/$DATASETS/" \
            -e "s/\$PIPELINES/$PIPELINES/" \
            -e "s/\#SBATCH --gres=gpu:volta:1//" \
            run_template.sh > ./run.sh
    else
        sed -e "s/\$EXPERIMENT_NAME/$EXPERIMENT_NAME/" \
            -e "s/\$DATASETS/$DATASETS/" \
            -e "s/\$PIPELINES/$PIPELINES/" \
            run_template.sh > ./run.sh
    fi
    LLsub run.sh
fi
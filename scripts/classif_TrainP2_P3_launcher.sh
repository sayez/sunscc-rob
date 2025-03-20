#!/bin/bash

#save pwd in a variable
p=$(pwd)
# set an environment variable for dataset path
export SUNSCCDATASET_PATH=$p
echo "SUNSCCDATASET_PATH: $SUNSCCDATASET_PATH"

run_dirs=("$SUNSCCDATASET_PATH/outputs/2025-02-25/21-32-54/run_0.0_class1_10epochs_run0")
# run_dirs=("$SUNSCCDATASET_PATH/outputs/2024-05-10/11-47-01/run_0.0_class1_100epochs_run0")

p2_p3_max_epochs=10 # number of epochs each phase must train

slurm=false

for run_dir in "${run_dirs[@]}"
do
    echo "run_dir: $run_dir"
    echo "bash ./scripts/classif_TrainP2_P3.sh $run_dir $p2_p3_max_epochs"
    if [ "$slurm" = true ]; then
        sbatch ./scripts/classif_TrainP2_P3.sh $run_dir $p2_p3_max_epochs
        # bash ./scripts/classif_TrainP2_P3.sh $run_dir $p2_p3_max_epochs
    fi
done
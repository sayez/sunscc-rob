# SunSCC: segmenting, grouping and classifying sunspots from ground-based observations using deep learning


## Installation

1) Clone this repository to desired location.

2) Create a virtual environment using python 3.10 .

    ```
    conda create -n 'sunscc' python=3.10
    conda activate sunscc
    ```

3) From root of the cloned repository, install sunscc as a package.
    
    ```
    pip install -e .
    ```

    The editable (-e) option allows creation and use of functions after package installation. If you create a new function, you must restart open jupyter notebooks to reload new package function tree.

4) IMPORTANT: Adapt the paths to local filesystem for datasets/outputs (using symbolic links if needed) - SunSCC expects the following structure:

    ```
    SUNSCC
    | -datasets
    | | - segmentation
    | | | - All *
    | | | - ManualAnnotation * 
    | | - classification
    | | | - 2002-2019 
    | | | | - rebuttal_all_revised_filtered *
    | | | | - rebuttal_overlap_only *
    | - outputs **
    ...

    ```

    `*` = Symbolic link to directories with same name in storage.
    `**` = Symbolic link to directory where trained models can be stored.

## Use Inference notebooks

### A) Directly on computing machine

1) In the root directory of the cloned repository, launch a jupyter server

    ```
    jupyter-notebook
    ```

2) Access the jupyter interface by clicking the link shown in terminal.

3) In the interface, open the desired notebook.


### B) On a client machine

1) (REMOTE SERVER) Ensure that the computing machine launched a jupyter server using command. Consider using tmux to keep the server alive when disconnected. (Change XXXX to a free port number)

    ```
    jupyter-notebook --no-browser --port=XXXX
    ```
    
    **-> Notice the url link starting with localhost. <-**


2) (CLIENT) To access the jupyter interface from client machine, setup port forwarding between local port and server port.

    ```
    ssh -N -L XXXX:localhost:XXXX user_name@server_name
    ```

3) (CLIENT) Follow the url link shown at **step 1** on a web browser on client machine. This opens jupyter interface.


3) In the interface, open the desired notebook.



## Train networks

**The training of the segmentation and classification networks of SunSCC are done separately.**

This repository relying on the Hydra python module, trainings typically follow experiments described in  configuration files in sunscc/conf/exp/XXXX.yaml

The typical bash command (**!launch from the root folder of the repo!**) to run experiment EXP.yaml is:

```
python -m sunscc.train exp=EXP hydra.run.dir=OUT_DIR seed=0 gpus=1
```

Hydra offers the possibility to override the configuration elements by adding/redifining them in the launch command:

```
 .... dataset.batch_size=32  ++dataset.num_workers=16
```
(the ++ sign means 'add configuration item or override if already exists')


Therefore, to run new experiments either create new configuration files to fit your need, or use the exitsting ones and modify the bash command accordingly.

In the scripts/ folder, you'll find bash files able to launch trainings for classification trainings divided in two kinds:
 1) XXX.sh files: scripts defining output folder and starting training by calling the training command with some configuration overrides given as ordered parameters.Those files are compatible to be run as a slurm job (SBATCH comments at the top of the file).
 2) XXX_launcher.sh files: bash scripts defining possibly several sets of training overrides and displaying calls to XXX.sh scripts to be launched as slurm jobs, once per set (with the corresponding parameters values).

Better than an explanation, here are examples to train both kinds of networks.


### A) Segmentation Network training

First, go to root directory and call a XXX_launcher.sh script.

```
> bash scripts/segmentation_exp_multiple_thresholds_fgbg_launcher.sh

[OUTPUT]
bash ./scripts/Segmentation_slurm_train.sh 16 [image,2023_T375_fgbg] 40 sunscc 2013-15_UNet_T375_StepLR_epoch_1_run0 StepLR epoch 1 0 [sunspot]
```

Each line in the output shows a training command for a given set of training overrides. You can run any of them in a terminal to launch a specific training.

```
> bash ./scripts/Segmentation_slurm_launcher.sh 16 [image,2023_T375_fgbg] 40 sunscc 2013-15_UNet_T375_StepLR_epoch_1_run0 StepLR epoch 1 0 [sunspot]

[OUTPUT (Training starts)]
...... 
```

### B) Classification Network training

The training of classification networks is split in two phases: the first trains MLP_z (see paper) and the second trains both MLP_p and MLP_c.

For each phase, XXX.sh and XXX_launcher.sh files can be used, analogously to the training of segmentation networks.

#### Phase 1

```
> bash scripts/classif_TrainP1_launcher.sh

[OUTPUT]
./scripts/classif_TrainP1.sh true false [image,T425-T375-T325_fgbg]...
```

```
> bash ./scripts/classif_TrainP1.sh true false [image,T425-T375-T325_fgbg]...

[OUTPUT (Training starts)]
...... 
```


#### Phase 2
Once the training phase 1 finished, provide the folder of the trained experiment to the launcher script of the second phase.

```
>  bash scripts/classif_TrainP2_P3_launcher.sh 

[OUTPUT]
bash ./scripts/classif_TrainP2_P3.sh /home/rwc/sunscc_repo/sunscc-rob/outputs/2025-02-25/21-32-54/run_0.0_class1_10epochs_run0 10
```

```
> bash ./scripts/classif_TrainP2_P3.sh /home/rwc/sunscc_repo/sunscc-rob/outputs/2025-02-25/21-32-54/run_0.0_class1_10epochs_run0 10

[OUTPUT (Training starts)]

```



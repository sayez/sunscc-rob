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


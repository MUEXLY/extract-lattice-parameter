# Lattice Parameter Calculation Script

This script is designed to automate the calculation of lattice parameters for the ```AlMg5``` alloy using LAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator). The script modifies the seed number and random seed number in the LAMMPS script file, then executes the LAMMPS script.

## Prerequisites

- LAMMPS installed and executable. The script assumes the LAMMPS executable is named ```lmp```.
- The script ```latparam_calculate.lammps``` should be present in the directory specified by ```SFEDATALOC```.

## Usage

To run the script, simply execute it in the terminal:

```bash
./batchJob.sh
```

Replace ```scriptname.sh``` with the name of this script.

## How it works

The script performs the following steps:

1. Loops over a range of seed numbers (change the number of loops to control the number of realizations).
2. For each seed number, it creates a new directory under ```SFEDATALOC``` named ```AlMg5_seedX```, where ```X``` is the seed number.
3. Copies the necessary files into the new directory.
4. Modifies the seed number and random seed number in the LAMMPS script ```latparam_calculate.lammps```.
5. Executes the LAMMPS script using ```mpirun```.

## Error Handling

The script checks if the necessary lines for changing the seed number and random seed number exist in the LAMMPS script. If not, it outputs an error message and exits.

## Note

The script currently uses 8 processors to run the LAMMPS script. Modify the number of processors as per your system's capabilities.




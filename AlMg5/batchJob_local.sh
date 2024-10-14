#!/bin/bash

ALLOYNAME="AlMg5"
SCRIPTNAME="latparam_calculate.lammps"
SFEDATALOC="/home/anon/Documents/Research/LAMMPS/AverageAtomPotential/latticeParameter_TEST/non-avg/AlMg5"
#LAMMPSEXE="/home/hyunsol/software/lammps/lammps-29Aug2024/build-cpu/lmp_mpi"
LAMMPSEXE="lmp"
SWAPTYPE=2

for i in {1..2}
do
    cd ${SFEDATALOC}
    ls ./${ALLOYNAME}_seed${i} >/dev/null 2>&1 || mkdir ./${ALLOYNAME}_seed${i}

    cp ./files/* ./${ALLOYNAME}_seed$i
    cd ./${ALLOYNAME}_seed${i}/

    # Change the seed number
    linenumber2=$(grep -nE "variable[[:space:]]+seedNum[[:space:]]+equal" "${SCRIPTNAME}" | cut -d':' -f1)
    if [[ -n "$linenumber2" ]]; then
        sed -i "${linenumber2}s/equal[[:space:]]*[0-9]*/equal $i/" "${SCRIPTNAME}" || { echo "Error: Failed to update seed number"; exit 1; }
    else
        echo "Error: seed number pattern not found in ${SCRIPTNAME}"
        exit 1
    fi

    # Change the random seed number with a random number
    linenumber1=$(grep -nE "set[[:space:]]+group[[:space:]]+dummyID[[:space:]]+type/ratio[[:space:]]+${SWAPTYPE}" ${SCRIPTNAME} | cut -d':' -f1)
    if [[ -n "$linenumber1" ]]; then
        sed -i "${linenumber1}s/[0-9]*$/$RANDOM/" "${SCRIPTNAME}" || { echo "Error: Failed to update random seed number"; exit 1; }
    else
        echo "Error: random seed number not found in ${SCRIPTNAME}"
        exit 1
    fi

    # Run the lammps script
    #mpirun -np 8 ${LAMMPSEXE} -in ${SCRIPTNAME}
    #${LAMMPSEXE} -sf gpu -pk gpu 1 -in ${SCRIPTNAME}
    #mpirun -np $SLURM_CPUS_PER_TASK ${LAMMPSEXE} -in ${SCRIPTNAME}
    mpirun -np 8 ${LAMMPSEXE} -in ${SCRIPTNAME}

    cd ..

    # run average script
    python avergeLattice.py

done

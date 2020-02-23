#!/bin/bash

# このシェルはMacOSでしか動きません

# 仮想マシン名
vmName=ubuntu01

# CPUはホストの全コア割り当て
numOfCPU=`system_profiler SPHardwareDataType | grep "Total Number of Cores" | grep -o '[0-9]' | tr -d '\n'`;

# メモリはホストの50%割り当て
totalMachineMemory=`system_profiler SPHardwareDataType | grep "Memory" | grep -o '[0-9]' | tr -d '\n'`;
numOfMem=`echo $(($totalMachineMemory/2))`;

# ディスク決め打ちで100GB
numOfDisk=100;

# e.g. https://cloudinit.readthedocs.io/en/latest/topics/modules.html
multipass launch --cpus $numOfCPU --disk "${numOfDisk}GB" --mem "${numOfMem}GB" --name $vmName --cloud-init cloud-config.yml;

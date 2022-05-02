#!/bin/sh
#JSUB -J val     
#JSUB -n 3
#JSUB -R "span[ptile=3]"         
#JSUB -q  GPU
#JSUB -o out.%J                  
#JSUB -e err.%J                  

INPUT_FILE=val.py
export LD_LIBRARY_PATH=/hpcfiles/software/public/lib:$LD_LIBRARY_PATH
nodelist=.hostfile.$$
cd  $JH_SUB_CWD
for var in ${JH_HOSTS}
do
    if ((++i%2==1))
    then
        hostnode="${var}"
    else
        ncpu="$(($ncpu + $var))"
        hostlist="$hostlist $(for node in $(seq 1 $var);do echo $hostnode >>$nodelist ;done)"
    fi
done
module load anaconda3/3.8.5
module load pytorch/pytorch
module load cuda/11.1
python3 $INPUT_FILE >> ./yolo3_v5.log
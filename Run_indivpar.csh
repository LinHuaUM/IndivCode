#! /bin/csh

# cd /home/u/IndiPar_v1.0_with_MCR_Package/IndiPar_v1.0/
# export CODE_DIR=/home/u/IndiPar_v1.0_with_MCR_Package/IndiPar_v1.0
# export MATLAB_DIR=/usr/local/MATLAB/MATLAB_Runtime/v85
set BOLD_DIR=/Parce_InputData/BOLD_DATA
set RECON_DIR=/Parce_InputData/RECON_DATA
set RESULTS_DIR=/Parce_InputData/RESULTS

set InPath=/Parce_InputData

##
set count = 1
set stop =  235

set att_file = ${InPath}/SubList.txt

while($count <= $stop)
    set s = `head -n $count $att_file | tail -n 1 | awk '{print $1}'`
    set a = `echo $s|cut -c 5-8`

    $CODE_DIR/IndividualParcellation.sh /usr/local/MATLAB/MATLAB_Runtime/v85 ${a} ${BOLD_DIR} ${RESULTS_DIR} ${RECON_DIR}
    $CODE_DIR/IndiParReuslts_Visualization.csh ${a} ${RESULTS_DIR} ${RECON_DIR}

  	@ count = $count + 1
end




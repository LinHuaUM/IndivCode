#! /bin/csh

set InPath = /Users/Selven/Desktop/Output
set ParcePath = /Users/Selven/Desktop/Parce_AD/ParcellationResults

##
set count = 1
set stop =  235

mkdir ${InPath}/IndiPar
set att_file = ${InPath}/SubList.txt

while($count <= $stop)
    set s = `head -n $count $att_file | tail -n 1 | awk '{print $1}'`
    set a = `echo $s|cut -c 5-9`

    echo $s

    mkdir ${InPath}/IndiPar/${s}

    cp -rf ${ParcePath}/${a} ${InPath}/IndiPar/${s}/Iter_10

  	@ count = $count + 1
end




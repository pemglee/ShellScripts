source /home/summit/env2/etkws_env.sh

source ../functions/funcQueryFile_2602.sh
source ../functions/funcQueryDB_2602.sh 
source ../functions/funcDateTime_2602.sh

#cd /home/summit/WorkSpaces/queryFailQueue/

strConnect=${SUMMITDBNAME}/${SUMMITDBNAME}@192.168.2.36:1521/${ORACLE_SID}
echo ${strConnect}
strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on; "

_locationName=CGB
_adapterID=FRONTINTERFACE
_externaltype=FX

_dbPasswd=$(getFieldsFromFile ../etc/dbpassword.txt 2 0 cgb632)

buildConnString cgb632 ${_dbPasswd} 192.168.2.36:1521/orcl

QueryString="select Today from dmLocation where audit_current = 'Y' and LocationName = '${_locationName}'"
asOfDate=$(queryDB)

#xRollDate=$(transDateInt2SAm ${asOfDate})
#echo ${xRollDate}
#
#euDate=$(transDateInt2Eu ${asOfDate})
#echo ${euDate}

asOfDate=$(transDateInt2ISO ${asOfDate})
echo ${asOfDate}


#select fq1.SequenceNum, fq1.ExternalID, fq1.FailQStatus, fq1.Action from dmLC_FailQueue fq1
#where fq1.WhenCreated like '2015-07-13%'

QueryString="  select fq1.SequenceNum, fq1.ExternalID, fq1.FailQStatus, fq1.Action "
QueryString+=" from dmLC_FailQueue fq1 "
QueryString+=" where fq1.WhenCreated like '${asOfDate}%' "
#QueryString+=" and fq1.SequenceNum in ( select max(fq2.sequencenum) from dmLC_FailQueue fq2 where fq2.externalid = fq1.externalid and fq2.FailQStatus <> 'PRIORVER' "
#QueryString+=" union select max(fq3.sequencenum) from dmLC_FailQueue fq3 where fq3.externalid = fq1.externalid and fq3.FailQStatus <> 'PRIORVER' ) "
QueryString+=" and fq1.ExtractorId = '${_adapterID}' and fq1.ExternalType like '${_externaltype}%' and fq1.MonitorAction <> 'RESUBMIT' " 
QueryString+=" order by fq1.externalid, fq1.sequencenum, fq1.transactionnum "
RowSize=4
echo ${QueryString}

VALUES=$(queryDB)
echo ${VALUES}

__colid=0
__rowValue=""
for tempRow in ${VALUES}
do
    __rowValue=${__rowValue}  + tempRow
    echo ${__colid}
    __colid=$(${__colid} + 1)
    if [[ ${__wholeRow} = ${RowSize} ]]
    then
        echo ${__rowValue}
        __colid=0
        __rowValue=""
    fi   
done
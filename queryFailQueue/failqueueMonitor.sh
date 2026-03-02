source /home/summit/env2/etkws_env.sh

source ../functions/funcQueryFile_2602.sh
source ../functions/funcQueryDB_2602.sh 
source ../functions/funcDateTime_2602.sh

#cd /home/summit/WorkSpaces/queryFailQueue/

strConnect=${SUMMITDBNAME}/${SUMMITDBNAME}@192.168.2.36:1521/${ORACLE_SID}
echo ${strConnect}
strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on; "

_locationName=CGB

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

QueryString=" select fq1.Sequence, fq1.ExternalID, fq1.FailQStatus, fq1.Action "
QueryString+=" from dmLC_FailQueue "
QueryString+=" where WhenCreate like '${asOfDate}%' "
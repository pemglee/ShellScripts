source /home/summit/env2/etkws_env.sh

source ../ShellPackages/net/edgar/inoutput/funcQueryFile_2602.sh
source ../ShellPackages/net/edgar/database/oracledb/funcQueryDB_2602.sh 
source ../ShellPackages/net/edgar/datetime/funcDateTime_2602.sh

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
#echo ${QueryString}

VALUES=$(queryDB)
#echo ${VALUES}

__colid=0
__rowValue=""
nowExtTrdID=""
preExtTrdID=""
nowVersion=""
preVersion=""
nowFStatus=""
preFStatus=""
nowFAction=""
preFAction=""
for tempRow in ${VALUES}
do
    if [[ ${__colid} = 0 ]]
    then
        nowExtTrdID=${tempRow}
    fi
    if [[ ${__colid} = 1 ]]
    then
        nowVersion=${tempRow}
    fi
    if [[ ${__colid} = 2 ]]
    then
        nowFStatus=${tempRow}
    fi
    if [[ ${__colid} = 3 ]]
    then
        nowFAction=${tempRow}
    fi

    __colid=$((__colid + 1))
    if [[ ${__colid} = ${RowSize} ]]
    then
        __rowValue=Trade:${nowExtTrdID},version:${nowVersion},Status:${nowFStatus},Action:${nowFAction}
        echo ${__rowValue}

        if [[ ${nowExtTrdID} = ${preExtTrdID} ]]
        then
            echo "Fail Queue Blocked, send Alter Message"
        fi

        __colid=0
        __rowValue=""
        preExtTrdID=${nowExtTrdID}
        preVersion=${nowVersion}
        preFStatus=${nowFStatus}
        preFAction=${nowFAction}
        nowExtTrdID=""
    fi 
done
chkToCrtTable()
{
    opTable=$1
    chkTblName="${opTable}_Hist"
    checkBkTable="select count(*) from user_tables where lower(TABLE_NAME) like lower('${chkTblName}');"
    
    echo ${checkBkTable}
    
values=`sqlplus -s $(strConnect} << EOF
${strFormater}
${checkBkTable}
exit;
EOF`

    if [[ ${values} -eq 0 ]]
    then
        createHistTable="create table ${chkTblName} as"
        createHistTable="${createHistTable} select * from ${opTable} where 1 <> 1; "
        
sqlplus -s ${strConnect} << EOF
${strFormater}
${createHistTable}
commit;
exit;
EOF
    
        echo " Just created ${chkTblName} now"
    else
        echo " Has created ${chkTblName} before"
    fi
    
}

backupTable()
{
    opTable=$1
    backTableSQL="insert into ${opTable}_Hist "
    backTableSQL="${backTableSQL} select * from ${opTable} ${opCondition};"
    
    echo "${backTableSQL}"
    echo ""
    
sqlplus -s ${strConnect} << EOF
${strFormater}
${backupTable}
commit;
exit;
EOF

}

purgeTable()
{
    opTable=$1
    deleteSQL="delete ${opTable} ${opCondition};"

    echo "${deleteSQL}"
    echo ""

# sqlplus -s ${strConnect} << EOF
# ${strFormater}
# ${deleteSQL}
# commit;
# exit;
# EOF

}

source /home/summit/rtscripts/bonjimaprod/etkws_env.sh
source /home/summit/EOD/eod.env
cd /home/summit/EOD

#dbpassword=$( < "pwd.txt" )
dbpassword=${SUMMITDBNAME}

strConnect=${SUMMITDBNAME}/${dbpassword}@${ORACLE_SID}
strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on;"

if [[ -n $1 ]]
then
    whiteListFile=$1

    whiteList="("

    while read -r line
    do
        exTrdId=${line:0:-1}
        if [[ "${whiteList}" == "(" ]]
        then
            whiteList="${whiteList}  '${exTrdId}'"
        else
            whiteList="${whiteList}, '${exTrdId}'"
        fi
    done < ${whiteListFile}

    whiteList="${whiteList} )"
else
    whiteList="('')"
fi

echo "Trade White List:${whiteList}"

asofdateX=$(date -d "-90days" +"%Y-%m-%d")
asofdateY=$(date +"%Y%m%d%H%M%S")
echo "purge FailQueue before Date:"${asofdateX}

purgeSQL="select ExtractorID || "," || SequeneceNum || "," || TransActionNum || "," || TransActionID from dmLC_FailQueue "
purgeSQL="${purgeSQL}where ExtractorID || "," || SequeneceNum || "," || TransActionNum || "," || TransActionID not in ("
purgeSQL="${purgeSQL}select ExtractorID || "," || SequeneceNum || "," || TransActionNum || "," || TransActionID from dmLC_FailQueue where ExternalID in ${whiteList} "
purgeSQL="${purgeSQL} ) "
purgeSQL="${purgeSQL}and WhenCreated < '${asofdateX}' "

opCondition=" where ExtractorID || "," || SequeneceNum || "," || TransActionNum || "," || TransActionID in (${purgeSQL}) "

chkToCrtTable "dmLC_Reference_Error"
backupTable "dmLC_Reference_Error"
purgeTable "dmLC_Reference_Error"

chkToCrtTable "dmLC_Log_Error"
backupTable "dmLC_Log_Error"
purgeTable "dmLC_Log_Error"

# DONOT adjust the execute order, it is main table, must run it at last
chkToCrtTable "dmLC_FailQueue"
backupTable "dmLC_FailQueue"
purgeTable "dmLC_FailQueue"

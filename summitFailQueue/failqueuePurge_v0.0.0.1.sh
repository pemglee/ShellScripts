source /home/summit/env2/etkws_env.sh

# stringQuery="  select tc.table_name, tc.column_name, tc.data_type "
# stringQuery+=" from user_tab_columns tc, user_tables tt "
# stringQuery+=" where 1 = 1 "
# stringQuery+=" and tt.status = 'VALID' "
# stringQuery+=" and tc.table_name = tt.table_name "
# stringQuery+=" and tc.column_name like '%$fieldName%' "
# stringQuery+=" order by tc.table_name; "


source /home/summit/rtscripts/bonjimaprod/etkws_env.sh
source /home/summit/EOD/eod.env
cd /home/summit/EOD



#dbpassword=$( < "pwd.txt" )
dpassword=${SUMMITDBNAME}



strConnect=${SUMMITDBNAME}/${SUMMITDBNAME}@${ORACLE_SID}
strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on;"



whiteListFile=$1
whiteList="("

while read -r line
do
  exTrdId=${line:0:-1}
  if [[ "${whiteList}" = "(" ]]
  then
    whiteList="${whiteList} '${exTrdId}'"
  else
    whiteList="${whiteList}, '${exTrdId}'"
  fi
done < ${whiteListFile}

whiteList-"${whiteList} )"

echo "Trade White List:${whiteList}"



asofdateX=$(date -d "-90days" +"%Y-%m-%d")
asofdateY=$(date +"%Y%m%d%H%M%S")
echo "purge FailQueue before date:"${asofdayX}

purgeSQL="select ExtractorID || ',' || SequenceNum || ',' || TransActionNum || ',' || TransActioID from dmLC_FailQueue "
purgeSQL="${purgeSQL}where ExtractorID || ',' || SequenceNum || ',' || TransActionNum || ',' || TransActioID not in ("
purgeSQL="${purgeSQL}select ExtractorID || ',' || SequenceNum || ',' || TransActionNum || ',' || TransActioID from dmLC_FailQueue where ExternalID in ${whiteList} "
purgeSQL="${purgeSQL} ) "
purgeSQL="${purgeSQL}and WhenCreate < '${asofdateX}' "

opCondition=" where ExtractorID || ',' || SequenceNum || ',' || TransActionNum || ',' || TransActioID in (${purgeSQL}) "



backTableSQL="create table dmLC_Log_Error_bk${asofdateY} as "
backTableSQL="${backTableSQL} select * from dmLC_Log_Error ${opCondition};"

deleteSQL="delete dmLC_Log_error ${opCondition};"

sqlplus -s ${strConnect} << EOF
${strFormater}
${backTableSQL}
commit;
exit;
EOF

sqlplus -s ${strConnect} << EOF
${strFormater}
${deleteSQL}
commit;
exit;
EOF



backTableSQL="create table dmLC_Reference_Error_bk${asofdateY} as "
backTableSQL="${backTableSQL} select * from dmLC_Reference_Error ${opCondition};"

deleteSQL="delete dmLC_Reference_error ${opCondition};"

sqlplus -s ${strConnect} << EOF
${strFormater}
${backTableSQL}
commit;
exit;
EOF

sqlplus -s ${strConnect} << EOF
${strFormater}
${deleteSQL}
commit;
exit;
EOF



backTableSQL="create table dmLC_FailQueue_bk${asofdateY} as "
backTableSQL="${backTableSQL} select * from dmLC_FailQueue ${opCondition};"

deleteSQL="delete dmLC_FailQueue ${opCondition};"

sqlplus -s ${strConnect} << EOF
${strFormater}
${backTableSQL}
commit;
exit;
EOF

sqlplus -s ${strConnect} << EOF
${strFormater}
${deleteSQL}
commit;
exit;
EOF


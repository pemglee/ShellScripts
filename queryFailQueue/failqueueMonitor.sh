source /home/summit/env2/etkws_env.sh

source ../functions/funcQueryFile_2602.sh
source ../functions/funcQueryDB_2602.sh 

getDBPassword()
{
    echo exec function named getDBPassword
    echo $1
    echo $2
}

getAsOfDate()
{
    echo exec function named getAsOfDate
};

# cd /home/summit/WorkSpaces/queryFailQueue/

export _dbPasswd=""
export _locationName=CGB

getDBPassword _dbpasswd cgb632


# block_AsOfDate_01 for test getAsOfDate
# strConnect=${SUMMITDBNAME}/${SUMMITDBNAME}@192.168.2.36:1521/${ORACLE_SID}
# echo ${strConnect}
# strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on; "
# stringQuery="select LocationName, Today from dmLocation where audit_current = 'Y' and LocationName = 'CGB'; "
# 
# values=`sqlplus -s ${strConnect} << EOF
# ${strFormater}
# ${stringQuery}
# exit;
# EOF`
# 
# echo $values
# end of block_AsOfDate_01


getAsOfDate _locationName 
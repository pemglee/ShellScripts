export ConnectingString=""
export QueryString=""

buildConnString()
{
   #
   #                  , output, 返回 数据库连接字符串
   #                            只返回单行结果
   # the 1st parameter, input,  数据库用户
   # the 2nd parameter, input,  数据库用户密码 
   # the 3rd parameter, input,  数据库实例URI， 
   #                            如 ${ORACLE_SID} 
   #                            或 192.168.2.36:1521/${ORACLE_SID}
   # 
   export ConnectingString=$1/$2@$3
}

queryDB()
{
   #
   #                  , output, 返回 查询结果
   # the 1st parameter, input,  数据库中的表
   # the 2nd parameter, input,  SQL查询的select字段 
   # the 3rd parameter, input,  SQL查询的where语句
   # 


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
   # #EOF后不得有空格
   # echo $values
   # end of block_AsOfDate_01

   __strFormater="set heading off feedback off pagesize 0 linesize 32767 verify off echo off trimspool on trimout on"

__values=`sqlplus -s ${ConnectingString} <<EOF
${__strFormater}; 
${QueryString};
exit;
EOF`

   echo ${__values}
}

getFetchRow()
{
   echo
}


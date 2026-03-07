export ConnectingString=""

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

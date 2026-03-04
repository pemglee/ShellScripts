getFileContent()
{
   #
   # 
   #
   #
   # examples,
   #
   #     ex 1. fileContent=`cat pwd.txt`
   #
   #     ex 2. fileContent=$(<"pwd.txt")
   #
   echo
}

getFieldsFromFile()
{
   #
   #                  , output, 返回 查询结果
   #                            只返回单行结果
   # the 1st parameter, input,  目标文件, 相当于数据库中的表
   # the 2nd parameter, input,  目标列，  相当于SQL查询的select字段，目前只支持单字段 
   # the 3rd parameter, input,  条件列，  相当于SQL查询的where语句，目前只支持单字段 
   # the 4th parameter, input,  条件列的值
   # 
   
   __targetFile=$1
   __queryFields=$2
   __whereFields=$3
   __whereValues=$4
 
   while read -r line 
   do 
       file_content=${line}
       lineLength=${#file_content}
       if [ ${lineLength} = 0 ]    #去除空行，因为其包含”换行符“
       then
           continue
       fi
 
 
       IFS=" "
       strArr=(${file_content})
 
 
       if [ ${strArr[0]} = \"${__whereValues}\" ]
       then
           echo ${strArr[2]:1:-1}
       fi
 
   done < $__targetFile
}
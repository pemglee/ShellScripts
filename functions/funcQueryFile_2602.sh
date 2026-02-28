getFileContent()
{
    echo
}

getFieldsFromFile()
{
    # the 1st parameter, output, return RecordSet
    # the 2nd parameter, input,  target file which stored data content, as data_table of database
    # the 3rd parameter, input,  to queryed columns index array,        as fields/columns in data_table of database  
    # the 4th parameter, input,  the values of fileds/columns
    
    export __retName=$1

    export __fileTable=$2
    export __fileFields=$3
    export __valOfFld=$4
}
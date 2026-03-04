#
# 日期格式
#
#   ISO    2025-11-02
#   
#   Am     11/02/2025
#   SAm    11/02/25
#   
#   Eu     02-11-2025
#   
#   Cn     2025年11月02日
#   
#   Int    20251102
#

transDateInt2ISO()
{
    originalDate=$1
    dateYer=${originalDate:0:4}
    dateMon=${originalDate:4:2}
    dateDay=${originalDate:6:2}
    echo ${dateYer}-${dateMon}-${dateDay}
}

transDateInt2Am()
{
    originalDate=$1
    dateYer=${originalDate:0:4}
    dateMon=${originalDate:4:2}
    dateDay=${originalDate:6:2}
    echo ${dateMon}/${dateDay}/${dateYer}
}

transDateInt2SAm()
{
    originalDate=$1
    dateYer=${originalDate:0:4}
    dateMon=${originalDate:4:2}
    dateDay=${originalDate:6:2}
    echo ${dateMon}/${dateDay}/${dateYer:2:2}
}

transDateInt2Eu()
{
    originalDate=$1
    dateYer=${originalDate:0:4}
    dateMon=${originalDate:4:2}
    dateDay=${originalDate:6:2}
    echo ${dateDay}-${dateMon}-${dateYer}
}
#!/bin/ksh
#**************************************************************************
#Script Name    : ComArchiveCleanUp.sh 
#Description    : This script will clean up the files in the archive directory based on the retention hrs set in teh config file.
#Created by     : 
#Version        Author          Created Date     Comments

#**************************************************************************
 
 
#------Global variable--------------#
 
NO_OF_PARAMETERS=2
 
#----- Check for the number of input parameters-------#
 
if [ $# -ne ${NO_OF_PARAMETERS} ]
then
        echo "Error: Incorrect number of parameters being passed to the script"
        echo "Script Usage: ksh CommonArchiveCleanUp.sh <DirectoryName> <ArchDirRetentionHrs>"
        
        exit 1
fi
 
#-----------------------------------------------------#
 
#-----Assigning the parameter to variable------------#
 
File_Path=$1
Retention_Hrs=$2
 
#------.profile-------------#
 
. /XXX/Projects/YYY/Config/.XXX_profile
 
 
#------Get the list of file in the archival directory-----#
 
Hrs_to_min=`expr $Retention_Hrs \* 60`
 
LastChar_Dir=`echo $File_Path | tr -d '\n\r' | tail -c 1`
 
Dir_DelimCnt=`echo $File_Path | tr -dc '/' | wc -c |  awk {'print $1'}`
 
if [ "$LastChar_Dir" != "/" ]
then
        Dir_DelimCnt=`expr $Dir_DelimCnt + 1`     
fi
 
find $File_Path -mmin +$Hrs_to_min -type f > $XXXWork/Dir_Filelist_$$.txt
 
while read line          
do           
 
        Find_DelimCnt=`echo $line | tr -dc '/' | wc -c | awk {'print $1'}`
 
        if [ $Find_DelimCnt -eq $Dir_DelimCnt ]
        then
                echo $line | cut -d'/' -f`expr $Dir_DelimCnt + 1` | tr -d '\r\n' >> $XXXWork/Dir_Filelist_$$.txt_temp
                echo " " >> $XXXWork/Dir_Filelist_$$.txt_temp
        fi      
           
done < $XXXWork/Dir_Filelist_$$.txt
 
mv $XXXWork/Dir_Filelist_$$.txt_temp $XXXWork/Dir_Filelist_$$.txt 2>/dev/null
 
 
#------Removing the files from directory-------#
 
file_list=`cat $XXXWork/Dir_Filelist_$$.txt | tr -d '\n'`
temp_path=`pwd`
cd $File_Path
rm -f $file_list
cd $temp_path
 
#-----Removing the temp file generated-----------------#
 
rm -f $XXXWork/Dir_Filelist_$$.txt
 
#----End of Script------------------#

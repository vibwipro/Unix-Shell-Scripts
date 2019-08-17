#!bin/ksh/

###########################################################################################
# Script Name: DeleteDataSet.sh
#Description: Used to clean-up the datasets which are not required after interface processing
#################################################################################################

#-----No of parameters check-------------#

if [ $# -ne 2 ]; then

 echo " Incorrect number of parameters "
 echo " Parameter 1 => Dataset name/pattern to be deleted."
 echo " Parameter 2 => Dataset file path."
 exit 1
fi

#----------Assigning parameter value to local variables---------#
DatasetName=$1
DatasetPath=$2

#--------Setting the Library Path------------------------------#
export DSHOME=$(cat /.dshome)
. $DSHOME/dsenv

export LD_LIBRARY_PATH=$APT_ORCHHOME/lib
export APT_CONFIG_FILE=$DSHOME/../Configurations/default.apt
export PATH=$DSHOME/bin:$APT_ORCHHOME/bin:/$PATH

orchadmin delete $2/$1

exit 0
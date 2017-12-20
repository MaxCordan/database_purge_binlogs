#!/bin/bash

dbuser='root'
dbpassword='<password>'
#How many days must be decrease
#May be less than 28 days
dicr=5

#Start checking correct date
#Checking first days of month
dateday=$(date +%d)
datemon=$(date +%m)
dateyea=$(date +%Y)
if [[ ${dateday:0:1} == "0" ]]
then
{
dateday=$(echo $dateday | tr -d 0)
}
fi
if [[ ${datemon:0:1} == "0" ]]
then
{
datemon=$(echo $datemon | tr -d 0)
}
fi
if (($dateday \< $dicr+1))
then
{
 if (($datemon==1))
 then
 {
  tempdicr=$dicr
  let "dicrday=$tempdicr-$dateday"
  let "dateyea=$dateyea-1"
  datemon=12
  dateday=31
  let "dateday=$dateday-$dicrday"
 }
 elif (($datemon==3))
 then
 {
  tempdicr=$dicr
  let "dicrday=$tempdicr-$dateday"
  let "datemon=$datemon-1"
  dateday=28
  let "dateday=$dateday-$dicrday"
 }
 elif (($datemon==2 || $datemon==4 || $datemon==6))
 then
 {
  tempdicr=$dicr
  let "dicrday=$tempdicr-$dateday"
  let "datemon=$datemon-1"
  dateday=31
  let "dateday=$dateday-$dicrday"
 }
 elif ((${datemon#0}==8 || ${datemon#0}==9 || ${datemon#0}==11))
 then
 {
  tempdicr=$dicr
  let "dicrday=$tempdicr-$dateday"
  let "datemon=$datemon-1"
  dateday=31
  let "dateday=$dateday-$dicrday"
 }
 elif (($datemon==5 || $datemon==7 || $datemon==10 || $datemon==12))
 then
 {
  tempdicr=$dicr
  let "dicrday=$tempdicr-$dateday"
  let "datemon=$datemon-1"
  dateday=30
  let "dateday=$dateday-$dicrday"
 }
 fi
}
else
{
 let "dateday=$dateday-$dicr"
}
fi

if [[ -z ${dateday:1:1} ]]
then
{
dateday=0$dateday
}
fi

if [[ -z ${datemon:1:1} ]]
then
{
datemon=0$datemon
}
fi
datestr=$dateyea-$datemon-$dateday

mysql --user="$dbuser" --password="$dbpassword" --execute="PURGE BINARY LOGS BEFORE '$datestr';"


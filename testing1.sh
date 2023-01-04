#!/bin/bash

#Colour variables

txt_reset="\033[0m"
Green=$'\e[0;32m'
Red=$'\e[0;31m'
yellow=$'\e[0;33m'
 
echo -ne "$yellow Enter the env to check mismatches:$txt_reset"
read env
echo -e "$yellow Your Selected env is:$txt_reset $env"

read -p " Enter Ultra version in the release ticket to comapare: " tic
echo -e "$Green !! Unwind while we look for Mismatches.$txt_reset"

function canary_stage()
{
input="/Users/akannan/stage_sites.txt"
bool_flag=0
while IFS= read -r line
do
ultra=$(curl -s https://$line/ultra/api/v1/buildInfo | egrep -i 'ultraversion'| awk '{print$2}'| tr -d '"' )

if [ "$tic" != "$ultra" ]
then
    echo -e "Ultra version for the site $line after canary test release:$ultra,$Red !!MISMATCH FOUND!!$txt_reset"
    bool_flag=1
fi
done < "$input"
if [ $bool_flag == 0 ]
then
echo "NO MISMATCH"
fi
}

function canary_prod()
{
input="/Users/akannan/prod_sites.txt"
bool_flag=0
while IFS= read -r line
do
ultra=$(curl -s https://$line/ultra/api/v1/buildInfo | egrep -i 'ultraversion'| awk '{print$2}'| tr -d '"' )

if [ "$tic" != "$ultra" ]
then
    echo -e "Ultra version for the site $line after canary test release:$ultra,$Red !!MISMATCH FOUND!!$txt_reset"
    bool_flag=1
fi
done < "$input"
if [ $bool_flag == 0 ]
then
echo -e "$Green Great !! , NO MISMATCHES FOUND$txt_reset"
fi
}

if [ $env == "stage" ]
then
     canary_stage

elif [ $env == "prod" ]
 then
      canary_prod
fi

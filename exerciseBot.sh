#!/bin/bash

#note that log redirected to /var/log/exerciseBotBackup.log

#got to this directory (so cron uses correct enviroment)
cd /home/gigabyte/.customCommands/cron/exerciseBot || exit 2

#check if already ran today - for lazy cron
todaysDate="$(echo "$(date)" | awk '{print $1, $3, $2}')"
read -r firstLine < lastDayRan.ignore
if [ "$todaysDate" == "$firstLine" ]; then
    exit 0
else
    echo "$todaysDate" > lastDayRan.ignore
fi

# check if every other day
# https://serverfault.com/questions/204265/how-to-configure-cron-job-to-run-every-2-days-at-11pm
if [ -f altday.ignore ]; then
  notify-send "$todaysDate - altday, did nothing"
  rm altday.ignore
  exit 0
fi
touch altday.ignore

#get and download image
imageUrl="$(curl https://dog.ceo/api/breeds/image/random | jq -r .message)"
wget $imageUrl
picName="$(basename "$imageUrl")"


#send email
mail -A "${picName}" -t  << END_MAIL
TO: $(cat /home/gigabyte/.customCommands/cron/exerciseBot/emails_DONOTADDTOREPO.ignore)
SUBJECT: Exercise $todaysDate :)

Hello Friend,

You must exercise today or buy dinner at 
the next gathering, along with the usual stakes...

Best, 
Ferin's Exercise Bot 
END_MAIL

#rm image
rm $picName

#notify user
notify-send "Exercise Bot Sent"

#For Crontab:
# redirect to its own file: https://askubuntu.com/questions/56683/where-is-the-cron-crontab-log
#0 6 * * * ~/.customCommands/cron/exerciseBot/exerciseBot.sh > /var/log/exerciseBotBackup.log 2>&1

#For lazy cron
#/tmp/LazyCron_logs


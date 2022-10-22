#!/bin/bash

#note that log redirected to /var/log/exerciseBotBackup.log

#got to this directory (so cron uses correct enviroment)
cd /home/gigabyte/.customCommands/cron/exerciseBot

# check if every other day
# https://serverfault.com/questions/204265/how-to-configure-cron-job-to-run-every-2-days-at-11pm
todaysDate="$(echo "$(date)" | awk '{print $1, $3, $2}')"
if [ -f altday.ignore ]; then
  echo "$todaysDate - altday, did nothing"
  rm altday.ignore
  exit
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

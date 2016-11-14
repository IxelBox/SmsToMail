#!/bin/bash
smsPath="$2/$1"
smsFile="IN_${1:2}"


mailPath="/opt/mail.mail"

smsExt=${smsFile##*.}

if [ "$smsExt" != "txt" ]
	then
		exit 1
fi
toMail="ZIELADRESSE"
mailText=$(cat $mailPath)

smsText=$(cat "$smsPath")
smsMeta=${smsFile%.*}
smsArray=(${smsMeta//_/ })


datetimeInfo="${smsArray[1]:6:2}.${smsArray[1]:4:2}.${smsArray[1]:0:4}"

timeInfo="${smsArray[2]:0:2}:${smsArray[2]:2:2}:${smsArray[2]:4:2}"
serialInfo="${smsArray[3]}"
fromSms=${smsArray[4]}
sequenzeInfo=${smsArray[5]}

newMail=$(echo  "$mailText" | sed -e "s/BETREFF123/SMS von ${fromSms}/g")

#mail erweitern mit sms Name
newMail+="\n\nDatum ${datetimeInfo}\nZeit ${timeInfo}\n"
newMail+="Serial ${serialInfo}\nVon ${fromSms}\n"
newMail+="Sequenz ${sequenzeInfo}\n\n${smsText}\n"
#mail versenden
echo -e "$newMail" | /usr/bin/msmtp -t $toMail

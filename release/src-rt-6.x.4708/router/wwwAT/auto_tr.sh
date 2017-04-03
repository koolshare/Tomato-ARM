#!/bin/sh
DIR=`pwd`
ALL=en_EN.all
LEX=en_EN.dict
LEXT=en_EN.dict.tomato
#RU_LEX=ru_RU.dict
RU_LEX=../www/ru_RU.txt
RU_LANG=ru_RU.txt
RU_MISS=ru_RU.missed

# DUMP
	echo "### AUTO GEN ###" > .auto_tr.dump
	while read line; do
		val=`awk -F"=" '{print $1}' <<< "$line"`
		echo "====================================================" >> .auto_tr.dump
		echo "val = $val" >> .auto_tr.dump
		echo "====================================================" >> .auto_tr.dump
		for file in $(grep "$val" $DIR/*.asp -l ); do
			echo "====" >> .auto_tr.dump
			echo "file = $file" >> .auto_tr.dump
			echo "====" >> .auto_tr.dump
			# RAW (debug)

			# title: '$val'
			# ,'$VAL']
			# , 'Disabled']
			# <div class="heading">$VAL
			# <title><% translate("Basic Network Settings"); %></title>

			# title: '$val'
#			if grep "title: '$val'" $file | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' >> .auto_tr.dump; then
#				echo "$file" >> .auto_tr.log
#				echo "$val" >> .auto_tr.log
#				sed -ie "s|title: '$val'|title: '<% translate(\"$val\"); %>'|g" $file
#				echo "=== done" >> .auto_tr.log
#			fi

#			if grep ",'$val']" $file | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' >> .auto_tr.dump; then
#				echo "$file" >> .auto_tr.log
#				echo "$val" >> .auto_tr.log
#				sed -ie "s|, '$val']|,'<% translate(\"$val\"); %>']|g" $file
#				echo "=== done" >> .auto_tr.log
#			fi

#			if grep ", '$val']" $file | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' >> .auto_tr.dump; then
#				echo "$file" >> .auto_tr.log
#				echo "$val" >> .auto_tr.log
#				sed -ie "s|,'$val']|,'<% translate(\"$val\"); %>']|g" $file
#				echo "=== done" >> .auto_tr.log
#			fi

			# not ideal yet - to check
			grep "<div class=\"heading\">$val" $file | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' >> .auto_tr.dump
			sed -ie "s|<div class=\"heading\">$val</div>|<div class=\"heading\"><% translate(\"$val\"); %></div>|g" $file

#			if grep "<title>$val</title>" $file | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' >> .auto_tr.dump; then
#				echo "$file" >> .auto_tr.log
#				echo "$val" >> .auto_tr.log
#				sed -ie "s|<title>$val</title>|<title><% translate(\"$val\"); %></title>|g" $file
#				echo "=== done" >> .auto_tr.log
#			fi
		done
	done < $LEXT


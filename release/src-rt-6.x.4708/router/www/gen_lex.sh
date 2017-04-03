#!/bin/bash
DIR=`pwd`
ALL=en_EN.all_pages_strings
LEX=en_EN.dict
RU_LEX=ru_RU.dict
RU_LANG=ru_RU.txt
RU_MISS=ru_RU.need_translation
CN_LEX=zh_CN.dict
CN_LANG=zh_CN.txt
CN_MISS=zh_CN.need_translation

cd $DIR
#echo "## RAW strings DUMP" > .out.dump
echo "#" > $ALL
echo "# Translation autogen strings" >> $ALL
echo "#" >> $ALL
for file in $(grep "<% translate" $DIR/*.asp -l ); do
	echo "" >> $ALL
	echo "#" `basename $file` >> $ALL	
	echo "" >> $ALL
	# RAW (debug)
	# egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<%(.*)/) {print substr($0, RSTART, RLENGTH)}' >> .out.dump
	egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<% translate\(.*\%>/) {print substr($0, RSTART, RLENGTH)}' | awk -F"\"" '{print $2"="}' >> $ALL
	# awk (buggy: only first entry printed)
	# cat $file | awk 'match($0, /<% translate\(.*\%>/) {print substr($0, RSTART, RLENGTH)}' | awk -F"\"" '{print $2"="}' >> $ALL
done

#
# generate main EN lex
#
cat $ALL | grep -v "^#" | sort -u -o $LEX

##
# RU
##

# check for untranslated RU strings
echo "###################################" > $RU_LANG
echo "### RU lang for Tomato (Shibby) ###" >> $RU_LANG
echo "###################################" >> $RU_LANG
echo "### Untranslated RU strings ###" > $RU_MISS

while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
	if ! grep "^$val=" $RU_LEX 1>/dev/null 2>&1; then
		echo "$line" >> $RU_MISS
	else
		grep "^$val=" $RU_LEX >> $RU_LANG
	fi
done < $LEX

# add advanced tomato strings
if [ -f ../wwwAT/ru_RU.txt ]; then
	while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
	if ! grep "^$val=" $RU_LANG 1>/dev/null 2>&1; then
		echo "$line" >> $RU_LANG
	fi
	done < ../wwwAT/ru_RU.txt
fi

##
# CN
##

# check for untranslated CN strings
echo "###################################" > $CN_LANG
echo "### CN lang for Tomato (Shibby) ###" >> $CN_LANG
echo "###################################" >> $CN_LANG
echo "### Untranslated CN strings ###" > $CN_MISS

while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
	if ! grep "^$val=" $CN_LEX 1>/dev/null 2>&1; then
		echo "$line" >> $CN_MISS
	else
		grep "^$val=" $CN_LEX >> $CN_LANG
	fi
done < $LEX

# add advanced tomato strings
if [ -f ../wwwAT/zh_CN.txt ]; then
	while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
	if ! grep "^$val=" $CN_LANG 1>/dev/null 2>&1; then
		echo "$line" >> $CN_LANG
	fi
	done < ../wwwAT/zh_CN.txt
fi


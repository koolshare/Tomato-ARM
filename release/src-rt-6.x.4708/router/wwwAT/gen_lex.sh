#!/bin/bash
DIR=`pwd`
ALL=en_EN.all_pages_strings
LEX=en_EN.dict
RU_LEX=../www/ru_RU.dict
RU_LANG=ru_RU.txt
RU_MISS=ru_RU.need_translation
CN_LEX=../www/zh_CN.dict
CN_LANG=zh_CN.txt
CN_MISS=zh_CN.need_translation

cd $DIR
#echo "## RAW strings DUMP" > .out.dump
echo "#" > $ALL
echo "# AT translation autogen strings" >> $ALL
echo "#" >> $ALL
for file in $(grep "<% translate" $DIR/*.asp -l ); do
	echo "" >> $ALL
	echo "#" `basename $file` >> $ALL	
	echo "" >> $ALL
	# RAW (debug)
	# egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<%(.*)/) {print substr($0, RSTART, RLENGTH)}' >> .out.dump
	egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<% translate\(.*\%>/) {print substr($0, RSTART, RLENGTH)}' | awk -F"\"" '{print $2"="}' >> $ALL
done

# generate main EN lex
cat $ALL | grep -v "^#" | sort -u -o $LEX

##
# RU
##

# check for untranslated RU strings
echo "######################################" > $RU_LANG # new file (overwite)
echo "### RU lang for Advanced Tomato UI ###" >> $RU_LANG
echo "######################################" >> $RU_LANG
echo "### Untranslated RU strings ###" > $RU_MISS

while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
#	echo "val = $val"
#	echo ""
	if ! grep "^$val=" $RU_LEX 1>/dev/null 2>&1; then
		echo "$line" >> $RU_MISS
	else
		grep "^$val=" $RU_LEX >> $RU_LANG
	fi
done < $LEX

##
# CN
##

# check for untranslated CB strings
echo "######################################" > $CN_LANG # new file (overwite)
echo "### CN lang for Advanced Tomato UI ###" >> $CN_LANG
echo "######################################" >> $CN_LANG
echo "### Untranslated CN strings ###" > $CN_MISS

while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
#	echo "val = $val"
#	echo ""
	if ! grep "^$val=" $CN_LEX 1>/dev/null 2>&1; then
		echo "$line" >> $CN_MISS
	else
		grep "^$val=" $CN_LEX >> $CN_LANG
	fi
done < $LEX


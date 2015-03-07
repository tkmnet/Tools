#!/bin/sh

##########################
#     卒業要件の設定     #
##########################
Common_C=2 #共通 必修
Common_S=8 #共通 選択
Special_C=38 #専門 必修
Special_S=56 #専門 選択
GeneralA_C=5 #総合A 必修
GeneralA_S=3 #総合A 選択
English=6 #総合A必修英語
GeneralB_C=0 #総合B 必修
GeneralB_S=12 #総合B 選択
##########################


check()
{
	if [ $1 -lt $2 ]; then
		echo -n '\033[0;31m ['
		echo "$1-$2" | bc | tr -d '\n'
		echo ']\033[0;39m'
	else
		echo '\033[0;32m [OK]\033[0;39m'
	fi
	return 0
}
zero()
{
	RESULT=0
	if [ $# -eq 1 ]; then
		RESULT=$1
	fi
	echo $RESULT
	return 0
}


if [ $# -ne 1 ]; then
	echo "Usage: $0 USERID\n"
	exit
fi
USERID=$1

echo -n "[aitech.ac.jp] password for ${USERID}: "
stty -echo
read PASSWORD
stty echo
echo

cd /tmp

rm -f SsfInfo.do
wget --post-data="LANGUAGE=1&USERID=${USERID}&PASSWORD=${PASSWORD}" --save-cookies='Logindo.cookie.tmp' -q -O - --keep-session-cookies https://rishu.aitech.ac.jp/cam/Login.do > /dev/null ; wget -q --load-cookies='Logindo.cookie.tmp' https://rishu.aitech.ac.jp/cam/svc/ssf/SsfInfo.do
rm -f Logindo.cookie.tmp

if [ `cat SsfInfo.do | grep -o 'システムエラーが発生しました。' | wc -l` -eq 0 ]; then
	mv SsfInfo.do record.raw
else
	echo 'failed to access your data.'
	rm -f Login.do
	exit
fi


sed 's/<[^>]*>/ /g' record.raw | sed '/^\s*$/d' | sed 's/^\s*//g' | sed 's/\r/ /g' | tr -d '\n' | sed 's/^.*共通教育科目/共通教育科目\n/' | sed 's/専門教育科目/\n専門教育科目\n/' | sed 's/総合教育科目/\n総合教育科目\n/' | sed 's/教職教育科目/\n教職教育科目\n/' | sed 's/処理年月日.*$/\n/' | sed 's/&nbsp;/\n/g' | sed '/^\s*$/d' | sed 's/定期試験.*$//' | sed 's/\s/ /g' | sed 's/ /_/g' | sed -E 's/(【|】)//g' | sed 's/__$/__不明/g' > record.tmp
rm record.raw

cat record.tmp | sed 's/$/@/g' | tr -d '\n' | sed 's/教職教育科目@.*$//' > recordA.tmp
rm record.tmp

cat recordA.tmp | sed -E 's/..教育科目@/\n\n/g' | sed '/^\s*$/d' | head -1 | sed -E 's/@/\n/g' | sed '/^\s*$/d' > recordC.tmp
cat recordA.tmp | sed -E 's/..教育科目@/\n\n/g' | sed '/^\s*$/d' | head -2 | tail -1 | sed -E 's/@/\n/g' | sed '/^\s*$/d' > recordS.tmp
cat recordA.tmp | sed -E 's/..教育科目@/\n\n/g' | sed '/^\s*$/d' | head -3 | tail -1 | sed -E 's/@/\n/g' | sed '/^\s*$/d' > recordG.tmp
rm recordA.tmp

cat recordG.tmp | grep -o '^G1.*' > /tmp/recordGA.tmp
sed -iE '/^G1.*/d' recordG.tmp
cat recordG.tmp | grep -o '^G2.*_.*語１.*__.*' >> /tmp/recordGA.tmp
sed -iE '/^G2.*_.*語１.*__.*/d' recordG.tmp
cat recordG.tmp | grep -o '^.*_英語コミュニケーション.*__.*' >> /tmp/recordGA.tmp
sed -iE '/^.*_英語コミュニケーション.*__.*/d' recordG.tmp
cat recordG.tmp | grep -o '^.*_英語ワークショップ.*__.*' >> /tmp/recordGA.tmp
sed -iE '/^.*_英語ワークショップ.*__.*/d' recordG.tmp
mv recordG.tmp recordGB.tmp

# 選択必修処理どうでもいいや
cat recordS.tmp | grep -o '.*_選必.__.*' | sed -E '1s/_選必(.)__/_必\1__/' | sed -E 's/_選必(.)__/_選\1__/' >> recordS.tmp
sed -iE '/^.*_選必.__.*/d' recordS.tmp

KIND='必'
CC=`cat recordC.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
SC=`cat recordS.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
GAC=`cat recordGA.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
GBC=`cat recordGB.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
KIND='選'
CS=`cat recordC.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
SS=`cat recordS.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
GAS=`cat recordGA.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`
GBS=`cat recordGB.tmp | grep -o "_${KIND}.__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|${KIND})//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`

ENG=`cat recordGA.tmp | grep -o "^.*_英.*__.*" | grep -o "_..__." | sed -E '/(Ｆ|失)$/d' | grep -o '.*__' | sed -E "s/(_|必|選)//g" | sed 's/$/+0/g' | tr -d '\n' | xargs echo | bc`


CC=`zero $CC`
SC=`zero $SC`
GAC=`zero $GAC`
GBC=`zero $GBC`
CS=`zero $CS`
SS=`zero $SS`
GAS=`zero $GAS`
GBS=`zero $GBS`
ENG=`zero $ENG`

echo '---------------------------------------------------------------------------'
cat recordC.tmp recordS.tmp recordGA.tmp recordGB.tmp
echo '---------------------------------------------------------------------------'
echo -n '共通必修=' ; echo -n $CC ; check $CC $Common_C
echo -n '専門必修=' ; echo -n $SC ; check $SC $Special_C
echo -n '総合A必修=' ; echo -n $GAC ; check $GAC $GeneralA_C
echo -n '総合B必修=' ; echo -n $GBC ; check $GBC $GeneralB_C
echo -n '共通選択=' ; echo -n $CS ; check $CS $Common_S
echo -n '専門選択=' ; echo -n $SS ; check $SS $Special_S
echo -n '総合A選択=' ; echo -n $GAS ; check $GAS $GeneralA_S
echo -n '総合B選択=' ; echo -n $GBS ; check $GBS $GeneralB_S
echo -n '総合A必修英語=' ; echo -n $ENG ; check $ENG $English
echo '---------------------------------------------------------------------------'


sed -iE '/^.*_インターンシップ_.*/d' recordC.tmp
sed -iE '/^.*_セミナー_.*/d' recordS.tmp
sed -iE '/^.*_卒業研究_.*/d' recordS.tmp
sed -iE '/^.*_特別講義._.*/d' recordS.tmp
sed -iE '/^.*_高大連携特別講義._.*/d' recordS.tmp
sed -iE '/^.*_特別講義_.*/d' recordGB.tmp
sed -iE '/^.*_日本語コミュニケーション_.*/d' recordGB.tmp
sed -iE '/^.*_海外研修英語_.*/d' recordGB.tmp

GP=`cat recordC.tmp recordS.tmp recordGA.tmp recordGB.tmp | sed -E 's/^.*(.)__(.)__.*$/\1\*\2/g' | sed -E 's/(Ｆ|失)/0/' | sed 's/可/1/' | sed 's/良/2/' | sed 's/優/3/' | sed 's/秀/4/' | sed 's/$/+/' | tr -d '\n' | sed 's/+$//' | xargs echo | bc`
CREDIT=`cat recordC.tmp recordS.tmp recordGA.tmp recordGB.tmp | sed -E 's/^.*(.)__(.)__.*$/\1/g' | sed 's/$/+/' | tr -d '\n' | sed 's/+$/\n/' | bc`
GPA=`echo "scale=10; $GP/$CREDIT" | bc`
echo "GPA=$GPA"
echo '---------------------------------------------------------------------------'


rm -f recordC.tmp recordS.tmp recordGA.tmp recordGB.tmp
rm -f recordC.tmpE recordS.tmpE recordGA.tmpE recordGB.tmpE recordG.tmpE


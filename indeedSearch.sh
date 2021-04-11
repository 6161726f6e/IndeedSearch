#!/bin/sh

email=$3
zip=$2
terms=$1

echo $1 $2

# search job 
curl -s --data-urlencode "as_and=$1" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$2&fromage=any&limit=50&sort=&psf=advsrch&from=advancedsearch" >jobResults.html 
grep "data-jk=" jobResults.html > jobIDs.txt
numResults=`grep -i "1 of " jobResults.html | cut -d'f' -f2| cut -d' ' -f2|sed s/,//`
numPages=$((numResults / 50 + 1))
x=1
while [ $x -lt $numPages ]
do 
	curl -s --data-urlencode "as_and=$1" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$2&fromage=any&limit=50&start=$startingJob&sort=&psf=advsrch&from=advancedsearch" >jobResults.html
	grep "data-jk=" jobResults.html >> jobIDs.txt
	echo "Unique Jobs = `cat jobIDs.txt | wc -l`"
	sed -i 's/data-//' jobIDs.txt
	x=$((x + 1))
done
sed -i 's/"//g' jobIDs.txt
sed -i 's/jk/https:\/\/www.indeed.com\/viewjob?jk/g' jobIDs.txt
cat jobIDs.txt
rm jobResults.html
echo "-----------------------------------"
echo "number of results = $numResults"
echo "number of pages = $numPages"
echo "emailing to $3"
echo "`cat jobIDs.txt`" | mail -s "Indeed Jobs" $3

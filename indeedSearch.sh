#!/bin/sh

email=$1
zip=$2
yesTerms=$3
anyTerms=$4
noTerms=$5

# search job 
echo searching for must have $yesTerms, one of $anyTerms, and no $noTerms jobs in $zip
curl -s --data-urlencode "as_and=$yesTerms" --data-urlencode "as_not=$noTerms" --data-urlencode "as_any=$anyTerms" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?noci=1&as_phr=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$zip&fromage=any&limit=50&sort=&psf=advsrch&from=advancedsearch" >jobResults.html 
#curl -s --data-urlencode "as_and=$yesTerms" 
grep "data-jk=" jobResults.html > jobIDs.txt
echo "Unique Jobs = `wc -l jobIDs.txt`"
numResults=`grep -i "1 of " jobResults.html | cut -d'f' -f2| cut -d' ' -f2 | sed s/,// | sed /^[[:alpha:]]/d`
echo numResults = $numResults
numPages=$((numResults / 50 + 1))
echo numPages = $numPages
x=1
while [ $x -lt $numPages ]
do 
	startingJob=$((x*50))
	echo startingJob = $startingJob
	curl -s --data-urlencode "as_and=$yesTerms" --data-urlencode "as_not=$noTerms" --data-urlencode "as_any=$anyTerms" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?as_phr=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$zip&fromage=any&limit=50&start=$startingJob&sort=&psf=advsrch&from=advancedsearch" >jobResults.html
	grep "data-jk=" jobResults.html >> jobIDs.txt
  grep "jobmap" jobResults.html >> results0.json
  cat results0.json | cut -d '=' -f2 | sed 's/;//g' | sed 's/^ //g' > results1.json
  cat results1.json | sed 's/,.*//g' | sed 's/{jk:/jk=/' | sed "s/'//g"  > jk.txt
	echo "Unique Jobs = `wc -l jk.txt`"
	x=$((x + 1))
done
sed 's/jk=/https:\/\/www.indeed.com\/viewjob?jk=/g' jk.txt > urls.txt
echo "-----------------------------------"
echo "number of results = $numResults"
echo "number of pages = $numPages"
echo "emailing to $email"
echo "number of results = $numResults for must have: $yesTerms, one of: $anyTerms, and none of: $noTerms jobs `cat urls.txt`" | mail -s "Indeed Jobs" $email
rm results*json
rm jobIDs.txt
rm jobResults.html
rm jk.txt
rm urls.txt


#!/bin/sh

email=$3
zip=$2
terms=$1

echo $1 $2

# search job 
echo searching for $terms jobs in $zip
curl -s --data-urlencode "as_and=$terms" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$zip&fromage=any&limit=50&sort=&psf=advsrch&from=advancedsearch" >jobResults.html 
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
	curl -s --data-urlencode "as_and=$terms" -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" "https://www.indeed.com/jobs?as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$zip&fromage=any&limit=50&start=$startingJob&sort=&psf=advsrch&from=advancedsearch" >jobResults.html
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
echo "`cat urls.txt`" | mail -s "Indeed Jobs" $email
rm results*json
rm jobIDs.txt
rm jobResults.html
rm jk.txt
rm urls.txt


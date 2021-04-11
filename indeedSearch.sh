#!/bin/sh

zip=$2
terms=$1

echo $1 $2

# search job 
curl -s -H "referer: https://www.indeed.com/?from=gnav-passport--passport-webapp&_ga=2.31817722.599025073.1618078236-916168758.1617925914" -H "Cookie: $cookie" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/json" "https://www.indeed.com/jobs?as_and=$1&as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=$2&fromage=any&limit=50&sort=&psf=advsrch&from=advancedsearch" >jobResults.html 
grep "data-jk=" jobResults.html > jobIDs.txt
sed -i 's/data-//' jobIDs.txt
rm jobResults.html
cat jobIDs.txt


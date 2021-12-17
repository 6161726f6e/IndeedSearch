# Overview
This script is great to get all the results in an unfiltered way (e.g., no promoted jobs or other sorting/filtering) and allows results to come to you without creating an indeed account/profile or having to click through pages of results.
- requires mailx and sendmail (or postfix) packages
- sendmail must be properly configured to send from a vaild email account
- encapsulate search terms with quotes

# Usage
```
indeedSearch.sh <email_addr> <ZIP code> <terms that must be found> <terms to match at least one of> <terms that must NOT be found>
  
indeedSearch.sh youremail@somedomain.com 22222 "term1 term2 (term3 or term4 or term5 or term6)" "term7 term8" "term9 term10"

```

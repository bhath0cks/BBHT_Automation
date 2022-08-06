#!/bin/bash

# Subdomain Enumeration & Probe

subdomain(){ 
github-subdomains -d $Domain -t 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 -o ${Domain}.txt
subfinder -d ${Domain} | httpx -o ${Domain}_subfinder.txt

cat ${Domain}_probed.txt | anew ${Domain}.txt
cat ${Domain}.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${Domain}_probed.txt 

URLEndpoints

rm ${Domain}*.txt

mv final.txt ${Domain}_final.txt
}

# URL Classification & Endpoints

URLEndpoints(){
cat ${Domain}_probed.txt | gau --fc 400-600 --verbose --o ${Domain}_gau.txt
cat ${Domain}_probed.txt | waybackurls | tee ${Domain}_wayback.txt
cat ${Domain}_wayback.txt | anew ${Domain}_gau.txt
cat ${Domain}_gau.txt | uro > final.txt
}

echo "Enter your target domain: "
read Domain
subdomain

#!/bin/bash

echo -e '\e[38;5;208mBBH Tools Automation by Ahmad Raihan Prawira\e[0m';

# Subdomain Enumeration

subdomain(){
subscraper $Domain --censys-id 6d25cce7-cdd5-4efb-906d-de9f07fe7590 --censys-secret Jxy6jDCvnTxETzJcR6chbcrn6L5sndOR -r ${Domain}.txt
github-subdomains -d $Domain -t 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 -o ${Domain}_github_subdomains.txt
subfinder -d $Domain -o ${Domain}_subfinder.txt
cat ${Domain}_github_subdomains.txt | anew ${Domain}.txt
cat ${Domain}_subfinder.txt | anew ${Domain}.txt
subdomainprobe
URLEndpoints
PortScan
}

# Subdomain Probing

subdomainprobe(){
cat ${Domain}.txt | httpx -v -o ${Domain}_probed.txt
cat ${Domain}.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${Domain}_uncommon_probe.txt
cat ${Domain}_uncommon_probe.txt | anew ${Domain}_probed.txt
}

# URL Classification & Endpoints

URLEndpoints(){
cat ${Domain}_probed.txt | gau --fc 403,404 --verbose -o ${Domain}_gau.txt
cat ${Domain}_gau.txt | uro > ${Domain}_final.txt
}

# Port Scanning

PortScan(){
cat ${Domain}_final.txt | naabu -o ${Domain}_naabu.txt
}

echo "Enter your target domain: "
read Domain
subdomain

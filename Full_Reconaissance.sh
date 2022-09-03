#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} =============================================================${RESET}"
echo "${BLUE} -->                  BBH AUTOMATION SCRIPT               <-- ${RESET}"
echo "${BLUE} -->              Author : Ahmad Raihan Prawira           <-- ${RESET}"
echo "${BLUE} =============================================================${RESET}"
echo ""

echo "${GREEN} -->  TAKE A CUP OF COFFEE WHILE THIS TOOL IS DOING HUNTING FOR YOU   <-- ${RESET}"
echo ""



# Subdomain Enumeration

subdomain(){
echo ""
echo "${YELLOW} [!] Subdomain Enumeration is Starting ${RESET}"
echo ""
 
subfinder -d ${Domain} | tee $output/${Domain}_subfinder.txt
amass enum -passive -d ${Domain} | tee $output/${Domain}_amass.txt
assetfinder -subs-only ${Domain} | tee $output/${Domain}_assetfinder.txt
subscraper ${Domain} --censys-id 6d25cce7-cdd5-4efb-906d-de9f07fe7590 --censys-secret Jxy6jDCvnTxETzJcR6chbcrn6L5sndOR -r $output/${Domain}_subscraper.txt
github-subdomains -d ${Domain} -t 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 -o $output/${Domain}_github.txt

echo ""
cat $output/${Domain}_subfinder.txt > $output/${Domain}_subdomain_AIO.txt
echo ""
cat $output/${Domain}_amass.txt | anew $output/${Domain}_subdomain_AIO.txt
echo ""
cat $output/${Domain}_assetfinder.txt | anew $output/${Domain}_subdomain_AIO.txt
echo ""
cat $output/${Domain}_subscraper.txt | anew $output/${Domain}_subdomain_AIO.txt
echo ""
cat $output/${Domain}_github.txt | anew $output/${Domain}_subdomain_AIO.txt
echo ""

rm $output/${Domain}_subfinder.txt $output/${Domain}_amass.txt $output/${Domain}_assetfinder.txt $output/${Domain}_subscraper.txt $output/${Domain}_github.txt


echo ""
echo "${GREEN} [+] Subdomain Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"

probing
portscan
URLEndpoints
}

# Subdomain Probing

probing(){
echo ""
echo "${YELLOW} [!] Subdomain Probe is Starting ${RESET}"
echo ""

cat $output/${Domain}_subdomain_AIO.txt | httpx -o $output/${Domain}_httpx.txt
cat $output/${Domain}_subdomain_AIO.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee $output/${Domain}_httprobe.txt

echo ""
cat $output/${Domain}_httpx.txt > $output/${Domain}_probed.txt
echo ""
cat $output/${Domain}_httprobe.txt | anew $output/${Domain}_probed.txt

rm $output/${Domain}_httpx.txt $output/${Domain}_httprobe.txt

echo ""
echo "${GREEN} [+] Subdomain Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Naabu Port Scanning

portscan(){
echo ""
echo "${YELLOW} [!] Port Scanning is Starting ${RESET}"
echo ""

cat $output/${Domain}_probed.txt | naabu -o $output/${Domain}_naabu.txt

echo ""
echo "${GREEN} [+] Port Scanning has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [!] Web Spidering is Starting ${RESET}"
echo ""

cat $output/${Domain}_probed.txt | gau --verbose --o $output/${Domain}_gau.txt
cat $output/${Domain}_probed.txt | waybackurls | tee $output/${Domain}_wayback.txt

echo ""
cat $output/${Domain}_gau.txt > $output/${Domain}_spidering.txt
echo ""
cat $output/${Domain}_wayback.txt | anew $output/${Domain}_spidering.txt
echo ""

echo ""
cat $output/${Domain}_spidering.txt | uro > $output/${Domain}_final.txt
echo ""

rm $output/${Domain}_gau.txt $output/${Domain}_wayback.txt $output/${Domain}_spidering.txt

echo ""
echo "${GREEN} [+] Web Spidering has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"

}

# Searching Gf Pattern

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for debug_logic Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf debug_logic | tee $output/${Domain}_debuglogic.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for debug_logic Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf idor | tee $output/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for img_traversal Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf img-traversal | tee $output/${Domain}_imgtraversal.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for img_traversal Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for jsvar Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf jsvar | tee $output/${Domain}_jsvar.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for jsvar Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf lfi | tee $output/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf rce | tee $output/${Domain}_rce.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Redirection Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf redirect | tee $output/${Domain}_redirect.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Redirection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf sqli | tee $output/${Domain}_sqli.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf ssrf | tee $output/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf ssti | tee $output/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf xss | tee $output/${Domain}_xss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability has been Completed ${RESET}"
}

# Nuclei Vulnerability Scanner

nucleiscan(){
echo ""
echo "${YELLOW} [!] Nuclei Scanning is Starting ${RESET}"
echo ""

cat $output/${Domain}_probed.txt | nuclei -t ~/nuclei-templates/ -s low,medium,high,critical | notify –id “tel”


echo ""
echo "${GREEN} [+] Nuclei Scanning has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

read -p "${YELLOW} [?] Enter your target domain: " Domain
echo ""

output=~/Recon/Full/Results/${Domain}

if [ ! -d $output ];
then
	mkdir -p $output
	subdomain

	gfpattern
	nucleiscan

else
	echo "${RED} [-] Directory already exists ${RESET}"

fi


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->                 HUNTING COMPLETED                 <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"

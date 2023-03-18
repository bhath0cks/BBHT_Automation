#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} ========================================================================================${RESET}"
echo "${BLUE} -->                 BBH AUTOMATION SCRIPT (EXCLUDING SUBDOMAIN ENUMERATION)         <-- ${RESET}"
echo "${BLUE} -->                          Author : Ahmad Raihan Prawira                         <-- ${RESET}"
echo "${BLUE} ========================================================================================${RESET}"
echo ""

echo "${GREEN}             -->  TAKE A CUP OF COFFEE WHILE THIS TOOL IS DOING HUNTING FOR YOU     <-- ${RESET}"
echo ""


# Check whether subdomain is alive or not and Finding Hosts through Shodan Enumeration via uncover

HostEnumeration(){
echo ""
echo "${YELLOW} [!] Shodan Enumeration is Starting ${RESET}"
echo ""

httpx -l $output/${Domain}.txt -mc 200,301,302,401,403 -sc -td -location -probe -silent -nc -o $output/${Domain}_httpx.txt
uncover -q $output/${Domain}.txt -shodan 'ssl.cert.subject.CN:"${Domain}" 200' -shodan-idb 'ssl.cert.subject.CN:"${Domain}" 200' -silent -nc | httpx -mc 200 -silent -nc -td -probe | tee -a $output/${Domain}_Host_Enumeration.txt

echo ""
echo "${GREEN} [+] Shodan Enumereation has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Finding Origin IP of the Subdomains via DNS Resolver

OriginIP(){
echo ""
echo "${YELLOW} [!] DNS Resolution is Starting ${RESET}"
echo ""

cat $output/${Domain}.txt | dnsx -a -resp-only -t 1000 -silent -o $output/${Domain}_ip.txt

# Remove CDN IP Address
cat $output/${Domain}_ip.txt | cdnstrip -c 50 -cdn $output/${Domain}_ip_cdn.txt -n $output/${Domain}_ip_non_cdn.txt

echo ""
for ip in $(cat $output/${Domain}_ip_non_cdn.txt);do echo $ip && ffuf -w $output/${Domain}.txt -u http://$ip -H "Host: FUZZ" -s -mc 200; done | tee -a $output/${Domain}_OriginIP_Final.txt
echo ""

echo ""
echo "${GREEN} [+] DNS Resolution has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Fetching Past / Known URL for finding URL Endpoints / Parameters

Past_URL(){
echo ""
echo "${YELLOW} [!] Finding Past / Known URL Enumeration is Starting ${RESET}"
echo ""

cat $output/${Domain}.txt | gau | tee -a $output/${Domain}_gau.txt

echo ""
echo "${GREEN} [+] Finding Past / Known URL Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Filtering the JavaScript File

JavaScript(){
# Gather JavaScript Files URL
echo ""
echo "${YELLOW} [!] Filtering the JavaScript File is Starting ${RESET}"
echo ""

cat $output/${Domain}_gau.txt | grep ".js$" | uniq | sort >> $output/${Domain}_jsfile_links.txt
cat $output/${Domain}.txt | subjs >> $output/${Domain}_jsfile_links.txt
cat $output/${Domain}_jsfile_links.txt | hakcheckurl | grep "200" | cut -d" " -f2 | sort -u > $output/${Domain}_live_jsfile_links.txt

echo ""
echo "${GREEN} [+] Filtering the JavaScript File has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"	
}


# Using gf pattern to find Specific Vulnerabilities

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx idor | tee -a $output/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Open Redirect ${RESET}"
	cat $output/${Domain}_gau.txt | gfx redirect | tee -a $output/${Domain}_redirect.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Open Redirect has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability (LFI) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx lfi | tee -a $output/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability (LFI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability (RCE) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx rce | tee -a $output/${Domain}_rce.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability (RCE) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat $output/${Domain}_gau.txt | gfx sqli | tee -a $output/${Domain}_sqli.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx ssrf | tee -a $output/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx ssti | tee -a $output/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) ${RESET}"
	cat $output/${Domain}_gau.txt | gfx xss | tee -a $output/${Domain}_xss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) has been Completed ${RESET}"
}

read -p "${YELLOW} [?] Enter your directory name to hunt: " Directory
read -p "${YELLOW} [?] Enter your target domain: " Domain
echo ""

output=~/Documents/Notes/Subdomain/$Directory

if [ ! -d $output ];
then
	echo "${RED} [-] List of target to hunt has not been found yet, Please find the target from https://chaos.projectdiscovery.io/ ${RESET}"
else
	HostEnumeration
	OriginIP
	Past_URL
	
	JavaScript
	gfpattern

fi

echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->                 HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"
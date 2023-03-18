#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} ================================================================${RESET}"
echo "${BLUE} -->                 BBH AUTOMATION SCRIPT                   <-- ${RESET}"
echo "${BLUE} -->              Author : Ahmad Raihan Prawira              <-- ${RESET}"
echo "${BLUE} ================================================================${RESET}"
echo ""

echo "${GREEN} -->  TAKE A CUP OF COFFEE WHILE THIS TOOL IS DOING HUNTING FOR YOU   <-- ${RESET}"
echo ""


# Subdomain Enumeration and Probing

subdomain(){
echo ""
echo "${YELLOW} [!] Subdomain Enumeration is Starting ${RESET}"
echo ""
 
subfinder -d ${Domain} -r 8.8.8.8,8.8.4.4,1.1.1.1,9.9.9.9 -silent -nc -nW -o $output/${Domain}_Subdomain.txt

echo ""
echo "${GREEN} [+] Subdomain Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Subdomain Permutation

SubdomainPermutation(){
echo ""
echo "${YELLOW} [!] Subdomain Permutation is Starting ${RESET}"
echo ""

wc -l $output/${Domain}_Subdomain.txt
cat $output/${Domain}_Subdomain.txt | ripgen > $output/${Domain}_ripgen.txt
cat $output/${Domain}_ripgen.txt | dnsx -t 1000 -silent -o $output/${Domain}_ripgen_results.txt
cat $output/${Domain}_Subdomain.txt $output/${Domain}_ripgen_results.txt | sort -u | wc -l > $output/${Domain}_final.txt
wc -l $output/${Domain}_final.txt

echo ""
echo "${GREEN} [+] Checking Subdomain is Alive / Not has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Finding Hosts through Shodan / Censys Enumreation via uncover

AliveEnumeration(){
echo ""
echo "${YELLOW} [!] Checking Subdomain is Alive / Not !!! ${RESET}"
echo ""

httpx -l $output/${Domain}_final.txt -mc 200 -silent -nc -o $output/${Domain}_alive.txt

echo ""
echo "${GREEN} [+] Checking Subdomain is Alive / Not has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Finding Origin IP of the Subdomains via DNS Resolver

OriginIP(){
echo ""
echo "${YELLOW} [!] DNS Resolution is Starting ${RESET}"
echo ""

cat $output/${Domain}_alive.txt | dnsx -a -resp-only -t 1000 -silent -o $output/${Domain}_ip.txt

# Remove CDN IP Address
cat $output/${Domain}_ip.txt | cdnstrip -c 50 -cdn $output/${Domain}_ip_cdn.txt -n $output/${Domain}_ip_non_cdn.txt

echo ""
for ip in $(cat $output/${Domain}_ip_non_cdn.txt);do echo $ip && ffuf -w $output/${Domain}_alive.txt -u http://$ip -H "Host: FUZZ" -s -mc 200; done | tee -a $output/${Domain}_OriginIP_Final.txt
echo ""

echo ""
echo "${GREEN} [+] DNS Resolution has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Crawling Subdomains

Crawling_URL(){
echo ""
echo "${YELLOW} [!] Crawling the Subdomains is Starting ${RESET}"
echo ""

cat $output/${Domain}_alive.txt | gau | tee -a $output/${Domain}_gau.txt
katana -list $output/${Domain}_alive.txt -d 2 -jc -nc -silent -o $output/${Domain}_katana.txt
gospider -q -S $output/${Domain}_alive.txt -o $output/${Domain}_gospider.txt -c 10 -d 1 --other-source --include-subs
cat $output/${Domain}_alive.txt | hakrawler -plain -d 2 | tee $output/${Domain}_hakrawler.txt

cat $output/${Domain}_gau.txt > $output/${Domain}_crawled_final.txt
cat $output/${Domain}_katana.txt | anew $output/${Domain}_crawled_final.txt
cat $output/${Domain}_gospider.txt | anew $output/${Domain}_crawled_final.txt
cat $output/${Domain}_hakrawler.txt | anew $output/${Domain}_crawled_final.txt

echo ""
echo "${GREEN} [+] Crawling the Subdomains  has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Filtering the JavaScript File

JavaScript(){
# Gather JavaScript Files URL
echo ""
echo "${YELLOW} [!] Filtering the JavaScript File is Starting ${RESET}"
echo ""

cat $output/${Domain}_crawled_final.txt | grep ".js$" | uniq | sort >> $output/${Domain}_jsfile_links.txt
cat $output/${Domain}_jsfile_links.txt | hakcheckurl | grep "200" | cut -d" " -f2 | sort -u > $output/${Domain}_live_jsfile_links.txt
python3 ~/Documents/Notes/BBH/secretfinder/SecretFinder.py -i $output/${Domain}_live_jsfile_links.txt -o $output/${Domain}_js_credentials.txt | anew $output/${Domain}_js_secretfinder.txt

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

read -p "${YELLOW} [?] Enter your company name: " Name
read -p "${YELLOW} [?] Enter your target domain to hunt: " Domain
echo ""

directory=~/Documents/Notes/Subdomain/$Name
output=~/Documents/Notes/Subdomain/$Name/$Domain

if [ ! -d $directory ];
then
	mkdir -p $directory

else
	echo "${RED} [-] Directory already exists ${RESET}"

fi


if [ ! -d $output ];
then
	mkdir -p $output
	subdomain
	SubdomainPermutation
	
	AliveEnumeration
	OriginIP
	Crawling_URL
	
	JavaScript
	gfpattern

else
	echo "${RED} [-] Targets already exists ${RESET}"

fi


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->                 HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"

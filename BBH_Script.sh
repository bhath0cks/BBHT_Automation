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
echo "${YELLOW} [!] Subdomain Enumeration and Probe is Starting ${RESET}"
echo ""
 
subfinder -d ${Domain} -nW -silent | httpx -silent | tee $output/${Domain}_Subdomain.txt

echo ""
echo "${GREEN} [+] Subdomain Enumeration and Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Finding Hosts through Shodan / Censys Enumreation via uncover

HostEnumeration(){
echo ""
echo "${YELLOW} [!] Shodan Enumeration is Starting ${RESET}"
echo ""

uncover -shodan 'ssl.cert.subject.CN:"${Domain}" 200' -shodan-idb 'ssl.cert.subject.CN:"${Domain}" 200' -silent | httpx -mc 200 -silent | tee -a $output/${Domain}_Host_Enumeration.txt

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

cat $output/${Domain}_Subdomain.txt | dnsx -a -resp-only -t 1000 -silent -o $output/${Domain}_dnsx.txt

echo ""
for ip in $(cat $output/${Domain}_dnsx.txt);do echo $ip && ffuf -w $output/${Domain}_Subdomain.txt -u http://$ip -H "Host: FUZZ" -s -mc 200; done | tee -a $output/${Domain}_OriginIP_Final.txt
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

cat $output/${Domain}_Subdomain.txt | gau | tee -a $output/${Domain}_gau.txt

echo ""
cat $output/${Domain}_gau.txt | uro > $output/${Domain}_final.txt
echo ""

echo ""
echo "${GREEN} [+] Finding Past / Known URL Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Recon the JavaScript File

JavaScript(){
# Gather JavaScript Files URL
echo ""
echo "${YELLOW} [!] Recon the JavaScript File is Starting ${RESET}"
echo ""

cat $output/${Domain}_final.txt | grep ".js$" | uniq | sort >> $output/${Domain}_jsfile_links.txt
cat $output/${Domain}_Subdomain.txt | subjs >> $output/${Domain}_jsfile_links.txt
cat $output/${Domain}_jsfile_links.txt | hakcheckurl | grep "200" | cut -d" " -f2 | sort -u > $output/${Domain}_live_jsfile_links.txt

# Gather Endpoints From JavaScript Files

cat $output/${Domain}_live_jsfile_links.txt | while read url; do python3 /home/kali/Tools/LinkFinder/linkfinder.py -d -i $url -o output_endpoints; done > $output/${Domain}_endpoints_jsfile_links.txt

# Gather Secrets From JavaScript Files

cat $output/${Domain}_live_jsfile_links.txt | while read url; do python3 //home/kali/Tools/SecretFinder/SecretFinder.py -i $url -o output_secret_js; done > $output/${Domain}_secrets_jsfile_links.txt

# Collect Js Files For Manually Search
mkdir $output/${Domain}/jsfiles 
cp $output/${Domain}_live_jsfile_links.txt $output/${Domain}/jsfiles/hosts
cd $output/${Domain}/jsfiles
meg -d 1000 -v / 

echo ""
echo "${GREEN} [+] Recon the JavaScript File has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"	
}


# Using gf pattern to find Specific Vulnerabilities

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) ${RESET}"
	cat $output/${Domain}_final.txt | gf idor | tee -a $output/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability (LFI) ${RESET}"
	cat $output/${Domain}_final.txt | gf lfi | tee -a $output/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability (LFI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability (RCE) ${RESET}"
	cat $output/${Domain}_final.txt | gf rce | tee -a $output/${Domain}_rce.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability (RCE) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf sqli | tee -a $output/${Domain}_sqli.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) ${RESET}"
	cat $output/${Domain}_final.txt | gf ssrf | tee -a $output/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) ${RESET}"
	cat $output/${Domain}_final.txt | gf ssti | tee -a $output/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) ${RESET}"
	cat $output/${Domain}_final.txt | gf xss | tee -a $output/${Domain}_xss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) has been Completed ${RESET}"
}

read -p "${YELLOW} [?] Enter your target domain: " Domain
echo ""

output=/home/kali/Documents/BBH_Notes/$Domain

if [ ! -d $output ];
then
	mkdir -p $output
	subdomain
	
	HostEnumeration
	OriginIP
	Past_URL
	
	JavaScript
	gfpattern

else
	echo "${RED} [-] Directory already exists ${RESET}"

fi

echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->                 HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"

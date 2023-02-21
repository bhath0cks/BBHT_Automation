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
 
subfinder -d ${Domain} | httpx | tee $output/${Domain}_Subdomain.txt

echo ""
echo "${GREEN} [+] Subdomain Enumeration and Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"

HostEnumeration
OriginIP
URLEndpoints
}

# Finding Hosts through Shodan / Censys Enumreation via uncover

HostEnumeration(){
echo ""
echo "${YELLOW} [!] Host Enumeration is Starting ${RESET}"
echo ""

uncover -shodan 'ssl.cert.subject.CN:"${Domain}" 200' -shodan-idb 'ssl.cert.subject.CN:"${Domain}" 200' -censys '${Domain}' | httpx | tee -a $output/${Domain}_Host_Enumeration.txt

echo ""
echo "${GREEN} [+] Host Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}
# Finding Origin IP of the Subdomains via DNS Enumeration

OriginIP(){
echo ""
echo "${YELLOW} [!] DNS Enumeration is Starting ${RESET}"
echo ""

cat $output/${Domain}_Subdomain.txt | dnsx -l $output/${Domain}_Subdomain.txt -a -resp-only | sort -u | tee -a $output/${Domain}_IP.txt

echo ""
for ip in $(cat $output/${Domain}_IP.txt);do echo $ip && ffuf -w $output/${Domain}_Subdomain.txt -u http://$ip -H "Host: FUZZ" -s -mc 200; done | tee -a $output/${Domain}_OriginIP_Final.txt
echo ""

echo ""
echo "${GREEN} [+] DNS Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Fetching Past / Known URL for finding URL Endpoints / Parameters

URLEndpoints(){
echo ""
echo "${YELLOW} [!] URL Endpoint Enumeration is Starting ${RESET}"
echo ""

cat $output/${Domain}_Subdomain.txt | waybackurls | tee -a $output/${Domain}_wayback.txt

echo ""
cat $output/${Domain}_wayback.txt | uro > $output/${Domain}_final.txt
echo ""

echo ""
echo "${GREEN} [+] URL Endpoint Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}


# Searching Gf Pattern for Specific Vulnerabilities

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

read -p "${YELLOW} [?] Enter your target domain: " Domain
echo ""

output=/home/kali/Documents/BBH_Notes/$Domain

if [ ! -d $output ];
then
	mkdir -p $output
	subdomain
	
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

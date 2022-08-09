#!/bin/bash

output= ~/Recon/Simple/Results/${Domain}

RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} ================================================================${RESET}"
echo "${BLUE} -->          SIMPLE RECONNAISANCE AUTOMATION FOR BBH        <-- ${RESET}"
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
 
subfinder -d ${Domain} | httpx | tee ${output}/${Domain}_probed.txt

echo ""
echo "${GREEN} [+] Subdomain Enumeration and Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"

 
URLEndpoints
}


# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [!] Web Spidering is Starting ${RESET}"
echo ""

cat ${output}/${Domain}_probed.txt | waybackurls | tee ${output}/${Domain}_wayback.txt

echo ""
echo "${GREEN} [+] Web Spidering has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"
}


# Searching Gf Pattern

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for debug_logic Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf debug_logic | tee ${output}/${Domain}_debuglogic.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for debug_logic Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf idor | tee ${output}/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for img_traversal Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf img-traversal | tee ${output}/${Domain}_imgtraversal.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for img_traversal Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for jsvar Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf jsvar | tee ${output}/${Domain}_jsvar.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for jsvar Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf lfi | tee ${output}/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf rce | tee ${output}/${Domain}_rce.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Redirection Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf redirect | tee ${output}/${Domain}_redirect.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Redirection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf sqli | tee ${output}/${Domain}_sqli.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf ssrf | tee ${output}/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf ssti | tee ${output}/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability ${RESET}"
	cat ${output}/${Domain}_wayback.txt | gf xss | tee ${output}/${Domain}_xss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability has been Completed ${RESET}"
}

read Domain echo "${YELLOW} [?] Enter your target domain: "
echo ""

if [ ! -d $output ];
then
	mkdir $output
	subdomain

	echo ""
    cat ${output}/${Domain}_spidering.txt | uro > ${output}/${Domain}_final.txt
    echo ""

	gfpattern
	
else
	echo "${RED} [-] Directory already exists ${RESET}"


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->              RECONNAISANCE COMPLETED                 <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"


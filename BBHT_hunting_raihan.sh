#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} =============================================================${RESET}"
echo "${BLUE} -->          FULL RECONNAISANCE AUTOMATION FOR BBH       <-- ${RESET}"
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
cat ${output}/${Domain}_subfinder.txt > ${output}/${Domain}_enumeration.txt
echo ""
cat ${output}/${Domain}_amass.txt | anew ${output}/${Domain}_enumeration.txt
echo ""
cat ${output}/${Domain}_assetfinder.txt | anew ${output}/${Domain}_enumeration.txt
echo ""
cat ${output}/${Domain}_subscraper.txt | anew ${output}/${Domain}_enumeration.txt
echo ""
cat ${output}/${Domain}_github.txt | anew ${output}/${Domain}_enumeration.txt
echo ""


echo ""
echo "${GREEN} [+] Subdomain Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"


probing 
URLEndpoints
DirBruteForce
}


# Subdomain Probing

probing(){
echo ""
echo "${YELLOW} [!] Subdomain Probe is Starting ${RESET}"
echo ""

cat ${output}/${Domain}_enumeration.txt | httpx | tee ${output}/${Domain}_httpx.txt
cat ${output}/${Domain}_enumeration.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${output}/${Domain}_httprobe.txt

echo ""
cat ${output}/${Domain}_httpx.txt > ${output}/${Domain}_probed.txt
echo ""
cat ${output}/${Domain}_httprobe.txt | anew ${output}/${Domain}_probed.txt

echo ""
echo "${GREEN} [+] Subdomain Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"
}

# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [!] Web Spidering is Starting ${RESET}"
echo ""

cat ${output}/${Domain}_probed.txt | gau --fc 400,402,404,405,406,408,422,429,500,501,502,503,504 --verbose --o ${output}/${Domain}_gau.txt
cat ${output}/${Domain}_probed.txt | waybackurls | tee ${output}/${Domain}_wayback.txt
arjun -i ${output}/${Domain}_probed.txt -t 100 --passive -oT ${output}/${Domain}_arjun.txt

echo ""
cat ${output}/${Domain}_gau.txt > ${output}/${Domain}_spidering.txt
echo ""
cat ${output}/${Domain}_wayback.txt | anew ${output}/${Domain}_spidering.txt
echo ""
cat ${output}/${Domain}_arjun.txt | anew ${output}/${Domain}_spidering.txt
echo ""

echo ""
echo "${GREEN} [+] Web Spidering has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"

}

# Directory Bruteforcing

DirBruteForce(){
dirsearch -l ${output}/${Domain}_probed.txt -e php,asp,aspx,jsp,py,txt,conf,config,bak,backup,swp,old,db,sqlasp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip -i 200 --full-url -t 25 -o ${output}/${Domain}_dirsearch.txt

echo ""
echo "${GREEN} [+] Directory Bruteforcing has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in ${output} directory ${RESET}"
}


# Searching Gf Pattern

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for debug_logic Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf debug_logic | tee ${output}/${Domain}_debuglogic.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for debug_logic Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf idor | tee ${output}/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for img_traversal Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf img-traversal | tee ${output}/${Domain}_imgtraversal.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for img_traversal Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for jsvar Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf jsvar | tee ${output}/${Domain}_jsvar.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for jsvar Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf lfi | tee ${output}/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf rce | tee ${output}/${Domain}_rce.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Redirection Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf redirect | tee ${output}/${Domain}_redirect.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Redirection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf sqli | tee ${output}/${Domain}_sqli.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf ssrf | tee ${output}/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf ssti | tee ${output}/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability ${RESET}"
	cat ${output}/${Domain}_final.txt | gf xss | tee ${output}/${Domain}_xss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability has been Completed ${RESET}"
}

echo "${YELLOW} [?] Enter your target domain: "
read Domain
echo ""

output=~/Recon/Full/Results/${Domain}

if [ ! -d ${output} ];
then
	mkdir -p ${output}
	subdomain

	echo ""
    cat ${output}/${Domain}_spidering.txt | uro > ${output}/${Domain}_final.txt
    echo ""

	gfpattern

else
	echo "${RED} [-] Directory already exists ${RESET}"

fi


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->              RECONNAISANCE COMPLETED                 <-- ${RESET}"
echo ""
echo "${GREEN} -->                 ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"

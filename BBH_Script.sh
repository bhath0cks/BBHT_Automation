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
 
subfinder -d ${Domain} | httpx -mc 200 | tee $output/${Domain}_Subdomain_200.txt
subfinder -d ${Domain} | httpx -mc 403 | tee $output/${Domain}_Subdomain_403.txt

echo ""
echo "${GREEN} [+] Subdomain Enumeration and Probe has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"

HostEnumeration
SubdomainPermutation
OriginIP
Past_URL
}

# Finding Hosts through Shodan / Censys Enumreation via uncover

HostEnumeration(){
echo ""
echo "${YELLOW} [!] Shodan or Censys Enumeration is Starting ${RESET}"
echo ""

uncover -shodan 'ssl.cert.subject.CN:"${Domain}" 200' -shodan-idb 'ssl.cert.subject.CN:"${Domain}" 200' | httpx -mc 200 | tee -a $output/${Domain}_Host_Enumeration.txt

echo ""
echo "${GREEN} [+] Shodan or Censys Enumereation has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Perform Subdomain Permutations

SubdomainPermutation(){
echo ""
echo "${YELLOW} [!] Subdomain Permutations is Starting ${RESET}"
echo ""

dnsgen -w /usr/share/wordlists/best-dns-wordlist.txt $output/${Domain}_Subdomain_200.txt | tee -a $output/${Domain}_Subdomain_Permutations.txt

echo ""
echo "${GREEN} [+] Subdomain Permutations has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}

# Finding Origin IP of the Subdomains via DNS Resolver

OriginIP(){
echo ""
echo "${YELLOW} [!] DNS Resolution is Starting ${RESET}"
echo ""

cat $output/${Domain}_Subdomain_200.txt | dnsx -l $output/${Domain}_Subdomain_200.txt -a -resp-only | sort -u | tee -a $output/${Domain}_OriginIP_200.txt

echo ""
for ip in $(cat $output/${Domain}_OriginIP_200.txt);do echo $ip && ffuf -w $output/${Domain}_Subdomain_200.txt -u http://$ip -H "Host: FUZZ" -s -mc 200; done | tee -a $output/${Domain}_OriginIP_200_Final.txt
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

cat $output/${Domain}_Subdomain_200.txt | gau | tee -a $output/${Domain}_gau.txt

echo ""
cat $output/${Domain}_gau.txt | uro > $output/${Domain}_final.txt
echo ""

echo ""
echo "${GREEN} [+] Finding Past / Known URL Enumeration has been Completed ${RESET}"
echo ""
echo "${GREEN} [+] Results are saved in $output directory ${RESET}"
}


# Searching Gf Pattern for Specific Vulnerabilities

gfpattern(){
	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Interesting JavaScript File ${RESET}"
	cat $output/${Domain}_final.txt | gf js-interesting | tee $output/${Domain}_javascript.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Interesting JavaScript File has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Interesting Endpoints ${RESET}"
	cat $output/${Domain}_final.txt | gf endpoints| tee $output/${Domain}_endpoints.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Interesting Endpoints has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [!] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) ${RESET}"
	cat $output/${Domain}_final.txt | gf idor | tee $output/${Domain}_idor.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Insecure Direct Object Reference Vulnerability (IDOR) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Local File Inclusion Vulnerability (LFI) ${RESET}"
	cat $output/${Domain}_final.txt | gf lfi | tee $output/${Domain}_lfi.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Local File Inclusion Vulnerability (LFI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Remote Code Execution Vulnerability (RCE) ${RESET}"
	cat $output/${Domain}_final.txt | gf rce | tee $output/${Domain}_rce.txt
	cat $output/${Domain}_final.txt | gf rce-2 | tee $output/${Domain}_rce_2.txt
	cat $output/${Domain}_rce_2.txt | anew $output/${Domain}_rce.txt
	rm -rf $output/${Domain}_rce_2.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Remote Code Execution Vulnerability (RCE) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for SQL Injection Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf sqli | tee $output/${Domain}_sqli.txt
	cat $output/${Domain}_final.txt | gf sqli-error | tee $output/${Domain}_sqli-error.txt
	cat $output/${Domain}_sqli-error.txt | anew $output/${Domain}_sqli.txt
	rm -rf $output/${Domain}_sqli-error.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for SQL Injection Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) ${RESET}"
	cat $output/${Domain}_final.txt | gf ssrf | tee $output/${Domain}_ssrf.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Request Forgery Vulnerability (SSRF) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) ${RESET}"
	cat $output/${Domain}_final.txt | gf ssti | tee $output/${Domain}_ssti.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Server-Side Template Injection Vulnerability (SSTI) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) ${RESET}"
	cat $output/${Domain}_final.txt | gf xss | tee $output/${Domain}_xss.txt
	cat $output/${Domain}_final.txt | gf domxss | tee $output/${Domain}_domxss.txt
	cat $output/${Domain}_domxss.txt | anew $output/${Domain}_xss.txt
	rm -rf $output/${Domain}_domxss.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Cross-site Scripting Vulnerability (XSS) has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for Upload Fields Vulnerability ${RESET}"
	cat $output/${Domain}_final.txt | gf upload-fields | tee $output/${Domain}_upload_fields.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for Upload Fields Vulnerability has been Completed ${RESET}"

	echo ""
	echo "${YELLOW} [?] Searching gf pattern for XML External Entity Injection Vulnerability (XXE) ${RESET}"
	cat $output/${Domain}_final.txt | gf xxe | tee $output/${Domain}_xxe.txt
	echo ""
	echo "${GREEN} [+] Searching gf pattern for XML External Entity Injection Vulnerability (XXE) has been Completed ${RESET}"
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

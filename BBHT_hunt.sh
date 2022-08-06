#!/bin/bash

GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} ========================================================= ${RESET}"
echo "${BLUE} -->          BUG BOUNTY AUTOMATION FOR HUNTING        <-- ${RESET}"
echo "${BLUE} -->            Author : Ahmad Raihan Prawira          <-- ${RESET}"
echo "${BLUE} ========================================================= ${RESET}"
echo ""

echo "${GREEN} -->  TAKE A CUP OF COFFEE WHILE THIS TOOL IS DOING HUNTING FOR YOU   <-- ${RESET}"
echo ""

echo "${YELLOW} [?] Enter your target domain: "
read Domain
subdomain


# Subdomain Enumeration (Reconnaisance)

echo "${YELLOW} [+] Perforing Subdomain Enumeration ${RESET}"
echo ""

subdomain(){ 
subscraper ${Domain} --censys-id 6d25cce7-cdd5-4efb-906d-de9f07fe7590 --censys-secret Jxy6jDCvnTxETzJcR6chbcrn6L5sndOR -r ${Domain}.txt
github-subdomains -d $Domain -t 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 -o ${Domain}_github.txt

cat ${Domain}_github.txt | anew ${Domain}.txt

probing 

URLEndpoints

rm ${Domain}*.txt

mv final.txt ${Domain}_final.txt
}

# Subdomain Probing

echo "${YELLOW} [+] Performing Subdomain Probe ${RESET}"
echo ""

probing(){
cat ${Domain}.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${Domain}_probed.txt
}

# URL Endpoint / Web Spidering

echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

URLEndpoints(){
cat ${Domain}_probed.txt | gau --fc 400-600 --verbose --o ${Domain}_gau.txt
cat ${Domain}_probed.txt | waybackurls | tee ${Domain}_wayback.txt
cat ${Domain}_wayback.txt | anew ${Domain}_gau.txt
cat ${Domain}_gau.txt | uro > final.txt
}


echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->              HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->              ENJOY AND CHEERS!!!                  <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"


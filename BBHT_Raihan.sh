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


# Subdomain Enumeration and Probing

subdomain(){
echo ""
echo "${YELLOW} [+] Performing Subdomain Enumeration and Probe ${RESET}"
echo ""
 
subfinder -d ${Domain} | httpx | tee ${Domain}.txt
 
URLEndpoints
}


# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

cat ${Domain}.txt | waybackurls | tee ${Domain}_wayback.txt
}

echo "${YELLOW} [?] Enter your target domain: "
echo ""
read Domain
subdomain


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->              HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->              ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"

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
echo "${YELLOW} [+] Perforing Subdomain Enumeration and Probe ${RESET}"
echo ""
 
subfinder -d ${Domain} | httpx | tee ${Domain}.txt
 
URLEndpoints

mv final.txt ${Domain}_final.txt
}


# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

cat ${Domain}.txt | gau --fc 400,402,404,405,406,408,422,429,500,501,502,503,504 --verbose --o ${Domain}_gau.txt

cat ${Domain}_gau.txt | uro > final.txt
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

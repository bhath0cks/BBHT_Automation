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


# Subdomain Enumeration

subdomain(){
echo ""
echo "${YELLOW} [+] Perforing Subdomain Enumeration ${RESET}"
echo ""
 
subfinder -d ${Domain} -o ${Domain}.txt

probing 
URLEndpoints

mv final.txt ${Domain}_final.txt
DirBruteForce
}


# Subdomain Probing

probing(){
echo ""
echo "${YELLOW} [+] Performing Subdomain Probe ${RESET}"
echo ""

cat ${Domain}.txt | httpx | tee ${Domain}_probed.txt
}


# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

cat ${Domain}_probed.txt | gau --fc 400,402,404,405,406,408,422,429,500,501,502,503,504 --verbose --o ${Domain}_gau.txt

cat ${Domain}_gau.txt | uro > final.txt
}

# Directory Bruteforcing

DirBruteForce(){
dirsearch -l ${Domain}_probed.txt -e php,asp,aspx,jsp,py,txt,conf,config,bak,backup,swp,old,db,sqlasp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip -i 200 --full-url -t 25 -o ${Domain}_dirsearch.txt
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

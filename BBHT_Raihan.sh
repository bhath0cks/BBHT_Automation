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
echo "${YELLOW} [+] Perforing Subdomain Enumeration and Probing ${RESET}"
echo ""
 
subfinder -d ${Domain} | httpx | tee ${Domain}.txt
subfinder -d ${Domain} | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${Domain}_uncommon_probe.txt

cat ${Domain}.txt | anew ${Domain}_uncommon_probe.txt

URLEndpoints
mv final.txt ${Domain}_final.txt

DirBruteForce
}

# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

cat ${Domain}_uncommon_probe.txt | gau --fc 400,402,404,405,406,408,422,429,500,501,502,503,504 --verbose --o ${Domain}_gau.txt

cat ${Domain}_gau.txt | uro > final.txt
}

# Directory Bruteforcing

DirBruteForce(){
dirsearch -e php,asp,aspx,jsp,py,txt,conf,config,bak,backup,swp,old,db,sqlasp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip -l ${Domain}_uncommon_probe.txt -i 200 --full-url -t 25 -o ${Domain}_dirsearch.txt
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

#!/bin/bash

read -p "Your username? This if for ownership and permissions of containers: " uname
read -p "Enter email address for SSL cerificates and Press [Enter]: " emails

uid=$(id -u $uname)
gid=$(id -g $uname)
tz="$(cat /etc/timezone)"

echo "We need your domain root for the SSL certs" 
echo "i.e example.com or mysite.com, avoid www.example.com or https:// etc.."
read -p "Enter the domain youd like to secure and press [Enter]: " domain

# Make the edits
echo "----------------"
# UID
sudo find . -type f -name "*.env" -exec sed -i "s/-uid-/"$uid"/g" '{}' \;
# GID
sudo find . -type f -name "*.env" -exec sed -i "s/-gid-/"$gid"/g" '{}' \;
# TZ
sudo find . -type f -name "*.env" -exec sed -i "s%-tz-%"$tz"%g" '{}' \;
# Email
sudo find . -type f -exec sed -i "s/-email-/"$emails"/g" '{}' \;
# domain
sudo find . -type f -exec sed -i "s/-domain-/"$domain"/g" '{}' \;

# Setup the Docker Network
docker network create media

# Setup the docker-compose file
cp docker-compose.yml.TEMPLATE docker-compose.yml

# setup the directories
mkdir -p common/downloads
mkdir -p common/media/movies
mkdir -p common/media/tvshows
mkdir -p couchpotato
mkdir -p nzbget
mkdir -p ombi
mkdir -p plex
mkdir -p plexpy
mkdir -p radarr
mkdir -p sonarr
chown $uid:$gid ./*

# completed
echo "Initial setup is completed. You can now run 'docker-compose up -d' to startup the mediaserver stack. The default login/password for NZBGET is nzbget/tegbzn6789"

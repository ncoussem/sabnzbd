# sabnzbd
Sabnzbd docker file

docker create --name=sabnzbd \
-v <config path>:/config \
-v <download paths>:/downloads \
-p 8080:8080 -p 9090:9090 ncoussem/sabnzbd


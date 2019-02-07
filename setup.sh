#!/bin/bash


read -p "Clone openstreetmap-carto? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  git clone git@github.com:gravitystorm/openstreetmap-carto.git
fi

read -p "Download coastline shapefiles? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
# this is truly garbage, but it's probably easier than installing mapnik
  docker run -it -v $(pwd)/openstreetmap-carto:/carto wolf/tileoven /bin/bash -c "PATH=\$PATH:/tileoven/node_modules/mapnik/lib/binding/bin && cd /carto && scripts/get-shapefiles.py"
fi

read -p "Install required font (noto) with apt-get? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo apt-get install fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-hanazono ttf-unifont
fi

read -p "Create docker volume for postgis (postgis-db-data)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  docker volume create postgis-db-data
fi

echo "Done!"

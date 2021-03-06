#!/bin/bash

# Variables
local_path="http://localhost:2368/"
github_path="https://brunodelgado.github.io"
output_folder="./Developer/brunodelgado.github.io" # Use . instead of ~ in order to properly work with wget
clear_output_folder_before_generating_files=true

# Colors
NOCOLOR='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

echo "----------------------------------------"
echo "---- ๐ Starting static blog deploy ----"
echo "----------------------------------------"

if ${clear_output_folder_before_generating_files}; then
	rm -rf $output_folder/*
fi;

echo "\n๐ ${YELLOW}Generating static pages from \"$local_path\"${NOCOLOR}"
wget -r -nH -P $output_folder -E -T 2 -np -k $local_path
echo "โ ${GREEN}Done generating static pages.${NOCOLOR}\n"

cd $output_folder

echo "๐ ${YELLOW}Searching and replacing localhost with remote host${NOCOLOR}"
find * -name *.html -type f -exec sed -i '' "s#$local_path#$github_path#g" {} \;

echo "โ ${GREEN}Done replacing localhost with remote host${NOCOLOR}\n"

echo "๐ ${YELLOW}Searching and fixing image's paths${NOCOLOR}"
find * -name *.html -type f -exec sed -i '' 's#.jpgg#.jpg#g' {} \;
find * -name *.html -type f -exec sed -i '' 's#.jpgpg#.jpg#g' {} \;
find * -name *.html -type f -exec sed -i '' 's#.jpgjpg#.jpg#g' {} \;

find * -name *.html -type f -exec sed -i '' 's#.pngg#.png#g' {} \;
find * -name *.html -type f -exec sed -i '' 's#.pngng#.png#g' {} \;
find * -name *.html -type f -exec sed -i '' 's#.pngpng#.png#g' {} \;
echo "โ ${GREEN}Done fixing image's paths${NOCOLOR}\n"

echo "๐ฆ ${YELLOW}Creating commit with changes${NOCOLOR}"
git add .
git commit -a -m "Updating static site files"

echo "\nโคด๏ธ  ${YELLOW}Pushing changes to GitHub${NOCOLOR}"
git push origin master

echo "\n${GREEN}----------------------------------------${NOCOLOR}"
echo "${GREEN}------ ๐ Static blog deployed! ๐ -----${NOCOLOR}"
echo "${GREEN}----------------------------------------${NOCOLOR}\n"

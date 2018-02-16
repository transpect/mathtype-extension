#!/usr/bin/env/ sh
wget -O saxon.zip https://sourceforge.net/projects/saxon/files/latest/download
unzip -d saxon saxon.zip
rm saxon.zip
git clone https://github.com/xspec/xspec/ xspec-master


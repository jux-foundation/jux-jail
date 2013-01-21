#	Makefile

#	Copyright (C) 2011-`date +%Y`  Hamed Saleh and Mahrud Sayrafi

#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.

#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.

#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.

root=

method=
src=

.PHONY:
	@echo We recommend that you run this script in /mnt/jail.
	@echo Your jail will be at /mnt/jail/root and some monitoring
	@echo   scripts will be stored in /mnt/jail/utils.
	
	@echo Options:
	@echo 	make all
	@echo 	make install
	@echo 	make test
	@echo
	@echo 	make clean
	@echo 	make cleanall
	@echo
	@echo 	make cpp
	@echo
	@echo 	make pascal
	@echo 	make basic
	@echo
	@echo 	make python

all: jail cpp test

install:
	#TODO

clean:
	@echo "Cleaning ..."
	rm -f lists deps

cleanall: clean
	@echo "Cleaning EVERYTHING ..."
	@echo "Warning: Please make sure to move or make backups of the"
	@echo "    following files and folders if they exist: root repo"
	rm -rf root repo

test:
	#TODO

jail: clean
	if [ ! -d root ] && mkdir root

cpp: jail
	sh makelist cpp gcc gcc-c++
	sh makejail ${root} ${method} ${src}

pascal: jail
	bash makelist fpc
	sh makejail ${root} ${method} ${src}
#	git checkout --merge https://github.com/jux-foundation/hellijudge-jail.git pascal

basic: jail
	cd hellijudge-jail
	git checkout --merge https://github.com/jux-foundation/hellijudge-jail.git basic
	cd ..

python:
	@echo "Not yet buddy, I'm working on it though ...;)"
	#TODO

java:
	@echo "Not yet buddy, I'm NOT working on it though ... ;)"
	#TODO

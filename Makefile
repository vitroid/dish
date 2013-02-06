BINTARGET	=dish on
VERSION		=1.22
DESTDIR		=
LOCALBIN        =$(HOME)/bin.$(HOSTTYPE)-$(OSTYPE)
BIN		=$(DESTDIR)/usr/bin

WWWSRC	=dish on Makefile README.html READMEJ.html Makefile.sample wheel.pov wheel.ini dish.spec

all:	dish on
on: dish
	ln dish on
%: %.in
	sed -e 's/@VERSION@/$(VERSION)/g' $< > $@
wheel.gif:
	make -f Makefile.sample wheel.gif

install:
	install ./dish $(BIN)
	-rm $(BIN)/on
	ln $(BIN)/dish $(BIN)/on

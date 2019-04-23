BINTARGET	=dish on
VERSION		=1.23
MAIL	        =vitroid@gmail.com
DESTDIR		=
LOCALBIN        =$(HOME)/bin.$(HOSTTYPE)-$(OSTYPE)
BIN		=$(DESTDIR)/usr/local/bin

all:	dish on README.md
on: dish
	ln dish on
%: temp_%
	sed -e 's/%%VERSION%%/$(VERSION)/g' -e 's/%%MAIL%%/$(MAIL)/g' $< > $@
wheel.gif:
	make -f Makefile.sample wheel.gif
install:
	install ./dish $(BIN)
	-rm $(BIN)/on
	ln $(BIN)/dish $(BIN)/on

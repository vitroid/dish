BINTARGET	=dish on
VERSION		=1.22
DESTDIR		=
LOCALBIN        =$(HOME)/bin.$(HOSTTYPE)-$(OSTYPE)
BIN		=$(DESTDIR)/usr/bin

all:	dish on README.html READMEJ.html README.md
on: dish
	ln dish on
%: %.in
	sed -e 's/@VERSION@/$(VERSION)/g' $< > $@
wheel.gif:
	make -f Makefile.sample wheel.gif
%.md: %.html
	cp $< $@
install:
	install ./dish $(BIN)
	-rm $(BIN)/on
	ln $(BIN)/dish $(BIN)/on

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
	#make -f Makefile.sample wheel.gif
	make -f Makefile.sample wheel.gif -j 4 SHELL="./dish -v bluebird1.local 8 bluebird2.local 8"
test:
	i=0;while [ $$i -lt 336 ]; do echo test.$$i; i=`expr $$i + 1`; done | xargs make -j SHELL="./dish -v -g test"
test.%:
	uname -a > $@; uname -a; sleep 100
%.md: %.html
	cp $< $@
install:
	install ./dish $(BIN)
	-rm $(BIN)/on
	ln $(BIN)/dish $(BIN)/on

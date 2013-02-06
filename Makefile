BINTARGET	=dish on
VERSION		=1.21
DESTDIR		=
LOCALBIN        =$(HOME)/bin.$(HOSTTYPE)-$(OSTYPE)
BIN		=$(DESTDIR)/usr/bin

WWWSRC	=dish on Makefile README.html READMEJ.html Makefile.sample wheel.pov wheel.ini dish.spec

all:	dish
tarball: $(WWWSRC)
	-rm -rf dish-$(VERSION)
	-mkdir dish-$(VERSION)
	cp $^ dish-$(VERSION)
	tar zcvf dish-$(VERSION).tar.gz dish-$(VERSION)
web: tarball wheel.gif
	scp dish-$(VERSION).tar.gz README.html READMEJ.html wheel.gif matto@mbox:www/90/70Proj/dish
%: %.in
	sed -e 's/@VERSION@/$(VERSION)/g' $< > $@
install:
	install ./dish $(BIN)
	-rm $(BIN)/on
	ln $(BIN)/dish $(BIN)/on
install.local:
	install ./dish $(LOCALBIN)
	-rm $(LOCALBIN)/on
	ln $(LOCALBIN)/dish $(LOCALBIN)/on

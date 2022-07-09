PREFIX = /usr/local/

all:
	@nimble build -d:release

install:
	@cp themer $(DESTDIR)$(PREFIX)/bin/themer

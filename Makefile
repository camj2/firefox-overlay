PREFIX = /usr/local

all:
	@printf "run 'make install' to install firefox-overlay\n"

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin

	@install -m 755 firefox-overlay $(DESTDIR)$(PREFIX)/bin
	@install -m 755 firefox-overlay-helper $(DESTDIR)$(PREFIX)/bin

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/firefox-overlay
	@rm -f $(DESTDIR)$(PREFIX)/bin/firefox-overlay-helper

clean:
	@rm -f firefox-overlay
	@rm -f firefox-overlay-helper

sh:
	@shfmt -w -d -p -i 2 -ci -sr firefox-overlay
	@shfmt -w -d -p -i 2 -ci -sr firefox-overlay-helper

	@shellcheck firefox-overlay
	@shellcheck firefox-overlay-helper

.PHONY: all install uninstall clean sh

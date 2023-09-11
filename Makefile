PREFIX = /usr/local

all:
	@install -m 755 firefox-overlay.in firefox-overlay
	@install -m 755 firefox-overlay-helper.in firefox-overlay-helper

install: firefox-overlay firefox-overlay-helper
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
	@shfmt -w -d -p -i 2 -ci -sr firefox-overlay.in
	@shfmt -w -d -p -i 2 -ci -sr firefox-overlay-helper.in

	@shellcheck firefox-overlay.in
	@shellcheck firefox-overlay-helper.in

.PHONY: all install uninstall clean sh

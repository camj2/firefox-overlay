PREFIX = /usr/local

all:
	@sed 's|@HELPER@|$(PREFIX)/bin/firefox-overlay-helper|g' src/firefox-overlay > firefox-overlay

	@cp -f src/firefox-overlay-helper firefox-overlay-helper

	@chmod +x firefox-overlay
	@chmod +x firefox-overlay-helper

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

check:
	-shfmt -w -d -p -i 2 -ci -sr src/firefox-overlay
	-shfmt -w -d -p -i 2 -ci -sr src/firefox-overlay-helper

	-shellcheck src/firefox-overlay
	-shellcheck src/firefox-overlay-helper

.PHONY: all install uninstall clean check

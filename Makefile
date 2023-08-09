PREFIX = /usr

install:
	install -m 755 firefox-overlay $(DESTDIR)$(PREFIX)/bin/
	install -m 755 firefox-overlay-helper $(DESTDIR)$(PREFIX)/bin/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/firefox-overlay
	rm -f $(DESTDIR)$(PREFIX)/bin/firefox-overlay-helper

.PHONY: install uninstall

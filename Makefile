PREFIX = /usr/local

BINDIR = $(PREFIX)/bin

all:
	-@shfmt -w -d -p -i 2 -ci -sr src/firefox-overlay.in
	-@shfmt -w -d -p -i 2 -ci -sr src/firefox-overlay-helper.in

	-@shellcheck src/firefox-overlay.in
	-@shellcheck src/firefox-overlay-helper.in

	@sed 's|@HELPER@|$(BINDIR)/firefox-overlay-helper|g' src/firefox-overlay.in > firefox-overlay

	@cp -f src/firefox-overlay-helper.in firefox-overlay-helper

	@chmod +x firefox-overlay
	@chmod +x firefox-overlay-helper

install: firefox-overlay firefox-overlay-helper
	@mkdir -p $(DESTDIR)$(BINDIR)

	@install -m 755 firefox-overlay $(DESTDIR)$(BINDIR)
	@install -m 755 firefox-overlay-helper $(DESTDIR)$(BINDIR)

uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/firefox-overlay
	@rm -f $(DESTDIR)$(BINDIR)/firefox-overlay-helper

clean:
	@rm -f firefox-overlay
	@rm -f firefox-overlay-helper

.PHONY: all install uninstall clean

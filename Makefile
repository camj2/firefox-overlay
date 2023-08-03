DESTDIR = /usr/bin

install:
	install -p -m 755 firefox-overlay "${DESTDIR}"
	install -p -m 755 firefox-overlay-helper "${DESTDIR}"

uninstall:
	rm -f "${DESTDIR}"/firefox-overlay
	rm -f "${DESTDIR}"/firefox-overlay-helper

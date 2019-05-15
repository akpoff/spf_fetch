PREFIX ?= /usr/local

install:
	cp spf_fetch	 "$(PREFIX)/bin/"
	cp spf_update_pf "$(PREFIX)/sbin/"
	cp experimental/spf_mta_capture "$(PREFIX)/bin/"
	cp spf_fetch.1	   "$(PREFIX)/man/man1/"
	cp spf_update_pf.1 "$(PREFIX)/man/man1/"
	cp experimental/spf_mta_capture.1 "$(PREFIX)/man/man1/"

remove:
	rm -f "$(PREFIX)/bin/spf_fetch"
	rm -f "$(PREFIX)/sbin/spf_update_pf"
	rm -f "$(PREFIX)/bin/spf_mta_capture"
	rm -f "$(PREFIX)/man/man1/spf_fetch.1"
	rm -f "$(PREFIX)/man/man1/spf_update_pf.1"
	rm -f "$(PREFIX)/man/man1/spf_mta_capture.1"

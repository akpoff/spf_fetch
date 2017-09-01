About spf_fetch
===================

The `spf_fetch` project is a collection of utilities to make managing
greylisting easier.

Greylisting is a technique for defeating spam by temporarily rejecting
email unknown senders. Well-behaved mail servers will try again after
a short interval, per the *RFC*. Spammers will usually move on and not
try again. Once the rejected server tries again, it's ip address is
added to a list of known-good mail servers for a period time, often a
month or longer.

One of the problem with greylisting, however, is that large senders
like Google, Microsoft, Yahoo and others have multiple outbound mail
servers and do not often retry from the same host, ip address or block
of ip addresses. This results in the greylisting software rejecting
the mailer numerous times until the email is redelivered by one of the
already greylisted ip addresses.

One naive technique for pre-greylisting large mailers like Google is
to add their *MX* records to the approved senders list. Unfortunately,
large companies rarely use the send servers and ip addresses for both
sending and receiving.

The `spf_fetch` project uses a simple technique for pre-determining
which ip addresses and blocks of addresses to add to the approved
list:
[SPF records](https://en.wikipedia.org/wiki/Sender_Policy_Framework).
Sender Policy Framework record are DNS entries that list ip addresses
and blocks of ip addresses that the company will send email from. Not
all companies have *SPF* records, but many do. Nearly all the large
companies like Google and Yahoo do, in part because they helped define
the SPF standard.

Looking up *SPF* records is not a simple matter of typing `dig
gmail.com SPF`. *SPF* records are not a record type. They're stored as
*TXT* fields and have to be parsed. They can *include* the records
from another domain or *redirect* to another domain. To get the full
list of ip addresses authorized to send on behalf of a domain requires
multiple recursive lookups.

This is where `spf_fetch` comes in.

spf_fetch
---------

`spf_fetch` is a script to recursively look-up *SPF* records from a
list of domains. The output is a list of IPv4 and IPv6 addresses and
blocks. This list can be used to create a whitelist of outbound *MTA*
addresses for email greylisting utilities like OpenBSD `spamd(8)`.

### Features
+ Fully-recursive look ups
+ Specify just IPv4 or IPv6 records (defaults to both)
+ Specify DNS server (defaults to system defined)
+ Lookup from file, command-line or `stdin`
+ Filters to process, transform or filter addresses after recursive
  lookup

See the man page for further details.

### Filters

`spf_fetch` can now run user-supplied filters to process, transform or
remove addresses after lookup but before returning them to `stdout`

Ships with `filters/filter_sipcalc` to validate IPv4 and IPv6
addresses.

__Note__: The filter
requires [sipcalc](https://github.com/sii/sipcalc) so is not run
without explicitly adding with command-line parameter `-t
filters/filter_sipcalc`.

Example
--------------------------------------

Given a list of domains like in the examples/example_domains:

    gmail.com
    gmx.com
    googlemail.com
    google.com

`spf_fetch` will return:

    #IPs for gmail.com...
    #IPs for gmx.com...
    213.165.64.0/23
    74.208.5.64/26
    74.208.122.0/26
    212.227.126.128/25
    212.227.15.0/24
    212.227.17.0/27
    74.208.4.192/26
    82.165.159.0/24
    217.72.207.0/27
    #IPs for googlemail.com...
    #IPs for google.com...
    #IPs for _spf.google.com...
    #IPs for _netblocks.google.com...
    64.18.0.0/20
    64.233.160.0/19
    66.102.0.0/20
    66.249.80.0/20
    72.14.192.0/18
    74.125.0.0/16
    108.177.8.0/21
    173.194.0.0/16
    207.126.144.0/20
    209.85.128.0/17
    216.58.192.0/19
    216.239.32.0/19
    #IPs for _netblocks2.google.com...
    #IPs for _netblocks3.google.com...
    172.217.0.0/19

Each domain from the list and all domains discovered as `include` or
`redirect` domains in the SPF records will be recursively looked up to
get their relevant IPs addresses.

Where To Get A Good List of Domains
-----------------------------------

To get a good list of domains, see the github mailcheck
(https://github.com/mailcheck/mailcheck/wiki/List-of-Popular-Domains)

See file `common_domains` for a properly formatted version of the
file.

spf_update_pf
-------------

`spf_update_pf` is a script that will call `spf_fetch` with a file of
domains that should be whitelisted and add them to a table in OpenBSD
`pf(4)`.

`spf_update_pf` defaults to look for a file called `common_domains` in
`/etc/mail`. The script will call `spf_fetch` with the file as the
input and redirect the output to a file called `common_domains_ips` in
`/etc/mail`.

`spf_update_pf` defaults to add the ip addresses to a table called
`common_white` defined in `pf.conf(5)`.

### Features
+ Specify file and `pf(5)` table
+ Pass additional arguments to `spf_fetch`

See the man page for further details.

spf_mta_capture
---------------

`spf_mta_capture` is an experimental script that will watch a log file
to capture the domains of all outbound mail. It will then retrieve the
SPF records for the domain by calling `spf_fetch` and then add them to
a table in `pf(5)`.

At the moment, `spf_mta_capture` only parses log files created by
OpenSMTPD.

`spf_mta_capture` is meant to run as a *pipe* program by `syslogd(8)`.

### Features
+ Writes send-to domains to file with timestamp in comment on same
  line
+ Specify output file and `pf(5)` table
+ Pass additional arguments to `spf_fetch`
+ Truncate entries older than `now() - n seconds`
+ Specify truncation seconds

See the man page for further details.

Copyright and License
---------------------

Copyright (c) 2016-2017 Aaron Poffenberger <akp@hypernote.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Updates and Suggestions
-----------------------

Let me know by fork/pull or email if you find bugs or other issues.

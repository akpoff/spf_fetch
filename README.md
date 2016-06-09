About spf_fetch
===================

spf_fetch is a script to recursively look-up SPF records from a list
of domains. The output is a list of ipv4 addresses or ipv4 blocks.
This list can be used to create a whitelist of outbound *MTA* addresses
for email greylisting utilities like OpenBSD `spamd(8)`.

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

Each domain from the list and all domains discovered as `include`
domains in the SPF records will be listed with their relevant IPs and
IP-blocks.

Where To Get A Good List of Domains
-----------------------------------
To get a good list of domains, see the github mailcheck (https://github.com/mailcheck/mailcheck/wiki/List-of-Popular-Domains)

See file `common_domains` for a properly formatted version of the file.

Use with PF
-----------

`spf_fetch` includes an additional script (`spf_update_pf`) to update
a table in OpenBSD `pf(4)`.

`spf_update_pf` defaults to look for a file called `common_domains` in
`/etc/mail`. The script will call `spf_fetch` with the file as the
input and redirects the output to a file called `common_domains_white`
in `/etc/mail`.

The script expects a table called `common_white` in `pf.conf(5)`. The
table name can be overridden by passing the name in as parameter 2.
This implies, then, that to pass in a different table name you must
pass in the file name as parameter 1.

See file `pf.conf` for an example of the rules to add to `pf.conf`.

*N.B.* `spf_update_pf` must be able to find `spf_fetch` on the path.

Copyright and License
---------------------

Copyright (c) 2016 Aaron Poffenberger <akp@hypernote.com>

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

Let me know by fork/pull or send me an email if you find mistakes.

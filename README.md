## FreeBSD Updater v0.75

```
options:
-h, --help                Its what youre looking at!
-b, --base                Update FreeBSD base
-u, --upgrade             Perform full upgrade of ports
-c, --check-update        Check ports for updates
-i, --install-required    Install all required packages for FreeBSD Updater to work	
-v, --version             Show version
```

### Project Description

This project aims to make updating from the FreeBSD ports collection as seamless as possible, including dealing with common portsdb/pkg issues, and interfaces with Braincomb's UPDATING.json (http://updating.braincomb.com/UPDATING.json) to warn you if a package scheduled to be updated has special instructions for installing with an option to exclude any UPDATING flagged packages.  This allows you to manually interact with the effected ports and reduce the risk of breaking the port or the database.  This tool is a wrapper script which utilizes multiple tools available in the pkg database, to satisfy these requirements run this command:

### TLDR

```
bsdup.sh --install-required
```

It's *important* that you install the required packages, this script uses a lot of common and not so common tools to accomplish it's tasks.
If you'd prefer to install thes packages manually, here's the packages it installs:

** RESERVED for PKG list **

### Options Description

| Option | Description |
|--------|--------|
|-h, --help|Displays all options and a short description of their functions |
|-b, --base|Upgrades your FreeBSD base by automating use of the ["freebsd-update"](https://www.freebsd.org/cgi/man.cgi?freebsd-update) tool|
|-u, --upgrade|Upgrades your FreeBSD ports database by automating the use of portsnap and portmaster|
|-c, --check-update|Updates your ports database by automating the use of portsnap, then displays list of upgradable ports|
|-i, --install-required|Installs all requires ports for all functions of FreeBSD Updater (bsdup) to work properly|

### License

MIT License

Copyright (c)2018 gergme

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

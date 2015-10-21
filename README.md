# Raspple II

Raspberry Pi + Apple II = Raspple II

Did you ever wish you had a tiny, cheap, silent peripheral attached to your
Apple // that gave it mass storage, access to the Internet, support for
network boot, quick access to the wealth of Apple // software and resources
available on the Internet, and more?  Did you ever imagine you could have
these things for less than the cost of most Apple peripherals on eBay?  Well,
you can!

This repository is currently a hard hat zone; it's not yet been populated with
Ivan Drucker's scripts and toolks.  When it is done, you should be able to
find all of the "glue" of RasppleII here, along with the tools necessary to
build a RasppleII distribution around your own Raspbian release.

For now, the focus will be on trying to recreate Ivan's setup and release
process, something hopefully he can step in and help with here and there.
Once we've got that working, the current plan is to make it work for other
people.  Finally we'll try to bring it up to date with the latest
architectural changes in Raspbian and its parent OS, Debian.

To answer a possible question early on: It's expected that A2SERVER and
A2CLOUD ought to be suitable for any Linux-based system with minimal
integration effort.  Certainly any Debian-based system should be pretty easy.
Image tools and the like should be usable on any generally modern UNIX-based
system.  Joseph Carter intends to use and test them on Mac OS X as well as
Linux, so they should be usable on the various BSD systems.

If you want any part of it to work somewhere it doesn't, dig in!  That's what
distributed development and open source are all about, right?

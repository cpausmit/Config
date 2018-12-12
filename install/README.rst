====================================
 Installing a new Version of Fedora
====================================

:Author: Christoph Paus
:Contact: paus@mit.edu
:URL: http://web.mit.edu/physics/people/faculty/paus_christoph.html

Initial Preparation
===================

Get a USB memory stick bigger than 3 GB to make sure to not run out of space and use the _mediawriter_ program to produce a life image from which to boot the computer and then install. This process is rather straight forward if your memory stick is not weird in some way.

Checking that the stick is actually properly working is not a bad idea because it does not take long and gives you a piece of mind when running into trouble, which you eventually will.
      
Laptop
======

Adjust bios to make sure it can properly read the USB stick. The legacy boot and efi sections might have to be swapped and sometimes there is trouble with the graphics card. Eventually going to the most basic laptop setup usually is the way to go if you run into issues.

For high resolution displays the nouveau drivers can be tricky. I add "nouveau.modeset=0" as a boot option.

You want to make sure you have nothing on the laptop that has no copy somewhere else. The user account is the only one that is relevant. There are no special crontabs or root edits that are not repeated in the new installation.

Desktop
=======

The main files are all on the server on a separate disk so there should not be too much of an issue. But there are a few things to check.

 1. crontabs?
    crontab -l
    sudo crontab -l



Main Server
===========



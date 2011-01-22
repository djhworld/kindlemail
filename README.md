kindlemail is a simple way of sending personal documents to your kindle, I made this 
simple application because I'm too lazy to faff about attaching items to emails and
I prefer to use the CLI.

## Information
This has been tested on ruby 1.9.2 and has had cursory testing on 1.8.7

## Notice
**DISCLAIMER** Users of the 3G Kindle will get charged fees for using the personal-document service so please
be aware of this, otherwise just use the Kindle in a Wifi area for free transfers. 

## Pre-requisites

For kindlemail to work you will need three things

* A gmail account
* Anonymous OAUTH access to your gmail account 
* Your gmail address will need to be added to the "Your Kindle Approved E-mail List" on Amazon's "Manage Your Kindle" page

## How do I get OAUTH credentials for my gmail account?

* You will need python installed on your system
* Follow the instructions from google [located here](http://code.google.com/p/google-mail-xoauth-tools/wiki/XoauthDotPyRunThrough)

## Why OAUTH, why can't I just put my password in?

* I don't like the idea of storing passwords, sorry!

## How to run
If you want to run kindlemail, do the following 

If you want the bleeding edge, clone this repository and...
    rake install 
or if you want a released gem...
    gem install kindlemail 

Run `setup` to setup kindlemail with your gmail credentials
    kindlemail --setup

Send a file to your Kindle!
    kindlemail ~/books/my_book.mobi

## Your code is rubbish
I'm new to this ruby game so I'm a bit rusty on how applications are packaged up, how things are done.
I wrote this application purely for my own benefit, so if it doesn't work or you don't agree with my 
code style or the way the application works, fork it and change it 
(but tell me so I can be envious of people who are inevitably better than me) 

## Notice 2 
This is rough code and probably won't work.

## Options

    kindlemail 0.2.8. Written by djhworld. https://github.com/djhworld/kindlemail

    kindlemail will send items to your kindle in the simplest possible manner

    Valid filetypes: -
      .doc - Microsoft Word
      .rtf - Rich Text Format
      .jpeg - JPEG image file
      .jpg - JPEG image file
      .gif - GIF image file
      .png - PNG image file
      .bmp - BMP image file
      .html - Hypertext Markup Language
      .htm - HyperText Markup Language
      .txt - Text files
      .mobi - Mobile ebooks
      .prc - Mobile ebooks
      .pdf - Portable Document Format (experimental)

    Usage: -
      kindlemail [options] <filename>

    Example usage: -
     kindlemail my_book.mobi

    Where [options] are: -
      --kindle-address, -k <s>:   Overrides the default kindle address to send items to
                   --force, -f:   Send the file regardless of whether you have sent it before
            --show-history, -s:   Show the history of files that have been sent using kindlemail
           --clear-history, -d:   Clear the history of files that have been sent using kindlemail
                   --setup, -e:   Setup kindlemail
               --show-info, -i:   Show information about the way kindlemail is setup
                 --version, -v:   Print version and exit
                    --help, -h:   Show this message

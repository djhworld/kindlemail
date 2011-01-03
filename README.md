## Introduction
whisper is a simple way of sending personal documents to your kindle, I made this 
simple application because I'm too lazy to faff about attaching items to emails and
I prefer to use the CLI.

## Notice
Users of the 3G Kindle will get charged fees for using the personal-document service so please
be aware of this, otherwise just use the Kindle in a Wifi area for free transfers. 

## Your code is rubbish
I'm new to this ruby game so I'm a bit rusty on how applications are packaged up, how things are done.
I wrote this application purely for my own benefit, so if it doesn't work or you don't agree with my 
code style or the way the application works, fork it and change it 
(but tell me so I can be envious of people who are inevitably better than me) 

## Notice 2 
This is rough code and probably won't work.

## But I think it works! 
To get it to work do the following

**Create a user whisper file**
    echo kindle_addr: your_kindle_address@kindle.com > ~/.whisper

**Go to the folder where your document lives (optional)**
    cd my_lovely_documents_folder

**Send document to your kindle**
    whisper memoirs.pdf

## Options
    whisper will send items to your kindle in the simplest possible manner

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
        whisper [options] <filename>

    Example usage: -
        whisper my_book.mobi

    Where [options] are: -
        --kindle-address, -k <s>:   Overrides the default kindle address to send items to
               --force, -f:   Send the file regardless of whether you have sent it before
             --version, -v:   Print version and exit
                --help, -h:   Show this message

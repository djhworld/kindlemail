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

`echo kindle_addr: your_kindle_address@kindle.com > ~/.whisper`
`cd my_lovely_documents_folder`
`ls`
`memoirs.pdf` 
`secret_sauce.txt`
`whisper memoirs.pdf`

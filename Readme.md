This docker project is work in progress and IS ONLY MEANT TO DEMONSTRATE the linux setup for emsigner and related components for GST filing.

==== DISCLAIMER ====

- PLEASE ENSURE THAT YOU UNDERSTAND THE `Dockerfile`
- DOING SOMETHING AS SERIOUS AS FILING A RETURN ON A CONTAINERIZED FIREFOX INSTANCE IS RISKY UNLESS YOU KNOW EXACTLY WHAT WENT INTO THE CONTAINER IMAGE! PLEASE DO NOT USE THE CONTAINER AS-IS.  YOU WILL BE EXPOSING YOUR GST CREDENTIALS AND USB TOKEN WITH DSC TO THE CONTAINER.
- INSTEAD OF BUILDING AND RUNNING THIS CONTAINER AS-IS, USE THE COMMANDS in the `Dockerfile` TO PERFORM A ONE TIME INSTALLATION AND CONFIGURATION ON YOUR LINUX MACHINE TO BE ABLE TO EASILY PERFORM GST FILING

This container is being specifically built to make it easier to file GST in India with the following fully configured...
 - Digital Signature Certificate signinng with emSigner Java Applet.
 - to access DSC from a ePass2003 Auto USB Key
 - on Firefox ESR

This is troublesome integration that has a number of issues and i have personally struggled to get this working on first attempt many a times.  this image will demonstrate how to bring multiple components together on a unix machine to help with GST.   

To build an image. (you can use any tag of your choice after -t, denouncein/* is merely an example) 

`docker build -t denouncein/gst-in-dsc-firefox .`

to run the image, create a temp directory called /tmp/gst and invoke the below command.  the emsigner stderr and stdout logs will be written to /tmp/gst so that they can be accessed from the host machine

`docker run --net=host -v /tmp/gst:/tmp/gst --privileged denouncein/gst-in-dsc-firefox`

This should pop up a firefox browser with emsigner running in the container and exposed to host image on the same port so that the applet is visible on the host machine's system tray

Current Status:
2019/12/26 - emsigner up and running. ePass2003Auto recognized and listing DSC
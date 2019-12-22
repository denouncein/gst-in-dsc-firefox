This docker project is work in progress and IS ONLY MEANT TO DEMONSTRATE the linux setup for emsigner and related components for GST filing.

PLEASE ENSURE THAT YOU UNDERSTAND THE `Dockerfile`, AS DOING SOMETHING AS SERIOUS AS FILING A RETURN ON A CONTAINERIZED FIREFOX INSTANCE IS RISKY UNLESS YOU KNOW EXACTLY WHAT WENT INTO THE CONTAINER IMAGE!
USE THE `Dockerfile` to perform a one time installation and configuration on your Linux machine to be able to easily perform GST filing
PLEASE DO NOT USE THE CONTAINER AS-IS.

This container is being specifically built to make it easier to file GST in India with the following fully configured...
 Digital Signature Certificate signinng with emSigner Java Applet.
 to access DSC from a ePass2003 Auto USB Key
 on Firefox ESR

This is troublesome integration that has a number of issues.  this image will demonstrate how to bring multiple components together on a unix machine to help with GST.   

To build an image. (you can use any tag of your choice after -t, denouncein/* is merely an example) 

`docker build -t denouncein/gst-in-dsc-firefox .`

to run the image

`docker run --net=host denouncein/gst-in-dsc-firefox firefox`

This should pop up a firefox browser with emsigner running in the container and exposed to host image on the same port so that the applet is visible on the host machine's system tray

I still have some way to go. please note that i still am not wiring up the usb key and port to the run command.  this is no where close to working
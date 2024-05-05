#!/bin/sh
cd client
./ifisocketdemoclient &
cd ../server
./ifisocketdemoserver
cd .. 

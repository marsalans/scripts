#!/bin/bash

HOST='ftp.server.com'
USER='anonymous'
PASS='anonymous'
SOURCEFOLDER='/remote/dir'
TARGETFOLDER='/local/dir'

lftp -f "
open $HOST 
user $USER $PASS 
lcd $SOURCEFOLDER 
mirror --delete --verbose $SOURCEFOLDER $TARGETFOLDER 
bye
"


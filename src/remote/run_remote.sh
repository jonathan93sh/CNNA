#!/bin/bash -e
REMOTE_IP=$1
PROJECT_NAME=$2
ZIPFILE=$3
SCRIPT=$4
scp $ZIPFILE cvlab@$REMOTE_IP:work.zip
scp $SCRIPT cvlab@$REMOTE_IP:work.tcl

ssh cvlab@$REMOTE_IP -t "bash -c 'unzip -o work.zip'"
ssh cvlab@$REMOTE_IP -t "bash -c 'vivado -mode batch -nojournal -nolog -notrace -source work.tcl'"
mkdir -p $PROJECT_NAME/$PROJECT_NAME.runs/impl_1
scp -r cvlab@$REMOTE_IP:$PROJECT_NAME/$PROJECT_NAME.runs/impl_1 $PROJECT_NAME/$PROJECT_NAME.runs/impl_1


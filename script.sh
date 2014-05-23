#!/bin/bash

for file in `ls`
do
  if [ -d $file ]
  then
    cp index.html $file
  fi
done

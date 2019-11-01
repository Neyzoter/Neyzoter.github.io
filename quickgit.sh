#!/bin/bash

git pull

echo "Please input commit message:"
read cmt

git add .

git commit -m "$cmt"

git push

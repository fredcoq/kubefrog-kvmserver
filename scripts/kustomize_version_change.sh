#! /bin/bash

for file in ./argocd-applications/*
do
  sed -i "s@v4.0.5@v4.3.0@g" "$file"
done


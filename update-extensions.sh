#!/bin/bash
# Update the extensions.txt file with currently installed extensions

code --list-extensions > extensions.txt
echo "Extensions list updated!"
echo "Total extensions: $(wc -l < extensions.txt)"

#!/bin/bash

# Search the german wikipedia easily for the highlighted word or the word in the clipboard. Script is executed by <ALT + F>

sh -c 'firefox "https://de.wikipedia.org/wiki/$(xclip -o)"'

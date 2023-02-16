#!/bin/bash

# Search the english wikipedia easily for the highlighted word or the word in the clipboard. Script is executed by <ALT + E>

sh -c 'firefox "https://en.wikipedia.org/wiki/$(xclip -o)"'

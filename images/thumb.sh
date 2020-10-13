#!/bin/bash
convert -resize 2048 -strip -interlace Plane -gaussian-blur 0.05 -quality 90% "$1" "$1"

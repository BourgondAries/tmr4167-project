#! /usr/bin/awk -E
BEGIN { i = 0; }
/Beam:([0-9]+)/ { print $1; }

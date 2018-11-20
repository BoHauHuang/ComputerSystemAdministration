#!/bin/sh

ls -lAS | 
	awk 'BEGIN{file=0 
	           dir=0 
		   size=0}
	     NR==2, NR==6 {print ++num":", $5, $9}
	     match($1,/^-/){file++}
	     match($1,/^d/){dir++}
	     {size+=$5}
	     END{print "Dir num: ", dir, "\nFile num: ", file, "\nTotal: ", size}'

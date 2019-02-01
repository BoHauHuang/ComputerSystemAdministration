#!/bin/sh

ls -lASR | 
	sort -nrk 5 |
	awk 'BEGIN{file=0 
	           dir=0 
		   size=0}
	     NR==1, NR==5 {print ++num":", $5, $9}
	     match($1,/^-/){file++;size+=$5}
	     match($1,/^d/){dir++}
	     END{print "Dir num: ", dir, "\nFile num: ", file, "\nTotal: ", size}'

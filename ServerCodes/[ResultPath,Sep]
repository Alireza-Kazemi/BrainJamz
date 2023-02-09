#! /bin/bash
# remove Dicom Files
# Alireza Kazemi kazemi@ucdavis.edu

MyDIR=$PWD
printf %s\\n "$MyDIR" >&2
for dir in ./*/
do cd -P "$dir" ||continue
	printf %s\\n "$PWD" >&2

	find . -print | grep 'Res_.*' | while read Files; do 
		rm -r ${Files}
		done;
	cd $MyDIR  

done;

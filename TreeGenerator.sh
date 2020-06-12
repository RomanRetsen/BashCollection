#!/bin/bash
base=16
drawingIter=1
row=1
declare -A levelsMatrix
declare -A finalMatrix

#base of the tree
levelsMatrix[1,1]=50

#filling up background
for ((i=1;i<=63;i++));
do
	for ((j=1;j<=100;j++)) do
		finalMatrix[$i,$j]="_"	
	done	
done

printf "Enter number of branches to draw (5 or less):"
read N

[ ${N} -gt 5 ] || [ ${N} -le 0 ] && exit 1

#iter throu levels
for i in $(seq 1 $N);
do
	#iter throu trunks
	for z in $(seq 1 $drawingIter);
	do
		trunkRow=$row
		for x in $(seq 1 $base); 
		do
			finalMatrix[$trunkRow,${levelsMatrix[$i,$z]}]="1"
			trunkRow=$(($trunkRow + 1))		

		done
		#iter throu branches
		branchRow=$trunkRow
		for y in $(seq 1 $base);
		do
			branchLeft=$((${levelsMatrix[$i,$z]}-$y))
			branchRight=$((${levelsMatrix[$i,$z]}+$y))
			finalMatrix[$branchRow,$branchLeft]="1"
			finalMatrix[$branchRow,$branchRight]="1"
			branchRow=$(($branchRow + 1))
		done
		element=$(($z*2-1))
		levelsMatrix[$(($i+1)),$(($element))]=$branchLeft
		levelsMatrix[$(($i+1)),$(($element+1))]=$branchRight
	done

	row=$(($row + $base * 2))
	base=$(($base / 2))
	
	#determine trunks count for next level
	if [ $drawingIter -eq 1 ];
	then
		drawingIter=$(($drawingIter + 1))
	else
		drawingIter=$(($drawingIter * 2))
	fi
done

#printing the tree
for ((i=63;i>=1;i--));
do
	for ((j=1;j<=100;j++)) do
		printf "%s"${finalMatrix[$i,$j]}		        
	done	
	printf "\n"
done

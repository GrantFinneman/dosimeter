#!/bin/bash

tumor_directory=$local_GPU_tumor_dir
output_path=$local_GPU_output
starting_angle=1
end_angle=360
change_in_angle=6

tumor_files=($tumor_directory/*.mha)

index=0
for tumor in ${!tumor_files[@]}; do

	tumor_path=${tumor_files[$((tumor + index))]}
	tumor_name=$(basename $tumor_path); tumor_name=${tumor_name%.*}
	output_dir="$output_path/$tumor_name"

	echo $tumor_path
	echo $output_dir
	sed -i "1 s!open.*mha!open=${tumor_files[$((tumor + index))]}!g" hu_regularizer.ijm
	imagej hu_regularizer.ijm

	min_hu=$(awk -F, 'NR==2 {print $6}' Results.csv)
	max_hu=$(awk -F, 'NR==2 {print $7}' Results.csv)
	echo "Min HU: $min_hu"
	echo "Max Hu: $max_hu"

	material_table_name=${tumor_name}_material.txt

	echo $tumor_name
	for material in {1..23}; do
		step=$(( (max_hu - min_hu + 22)/23 ))
		new_hu=$((material*step + min_hu))
		register_number=$((material + 8))
		#echo $new_hu
		#echo $register_number
		#awk -v register=$register_number -v value=$new_hu 'FNR==register {$1=value} {print}' $(pwd)/data/Schneider2000MaterialsTable.txt  $material_table_name
		sed -i "${register_number} s/[[:digit:]]*/$new_hu/" $(pwd)/data/Schneider2000MaterialsTable.txt
	done
	cp $(pwd)/data/Schneider2000MaterialsTable.txt $tumor_directory/$material_table_name

	density_table_name=${tumor_name}_density.txt

	for material in {1..5}; do
		step=$(( (max_hu - min_hu + 4)/5 ))
		new_hu=$((material*step + min_hu))
		register_number=$((material + 3))
		#echo $new_hu
		#echo $register_number
		sed -i "${register_number} s/[[:digit:]]*/$new_hu/" $(pwd)/data/Schneider2000DensitiesTable.txt
	done
	cp $(pwd)/data/Schneider2000DensitiesTable.txt $tumor_directory/$density_table_name

	cat $tumor_directory/$density_table_name
	cat $tumor_directory/$material_table_name
	cat Results.csv
done



















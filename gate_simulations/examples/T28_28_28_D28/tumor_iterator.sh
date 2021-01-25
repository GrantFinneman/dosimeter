#!/bin/bash
# this will iterate over the tumors in cropped and call the simulation_run.sh
# to actually do the simulations.

tumor_directory=$local_GPU_tumor_dir
output_path=$local_GPU_output
starting_angle=1
end_angle=360
change_in_angle=6

tumor_files=($tumor_directory/*mha)
montage_files=($tumor_directory/*montage*)
material_files=($tumor_directory/*material*)
density_files=($tumor_directory/*density*)

# this indes tells the loop which tumor to use
index=0

if [[ $HOSTNAME == Hal ]]; then
	min=0
	max=$(( ${#tumor_files[@]} -1 ))

	while [[ min -lt max ]]; do
	# Swap current first and last elements
	x="${tumor_files[$min]}"
	tumor_files[$min]="${tumor_files[$max]}"
	tumor_files[$max]="$x"

	y="${material_files[$min]}"
	material_files[$min]="${material_files[$max]}"
	material_files[$max]="$y"

	z="${density_files[$min]}"
	density_files[$min]="${density_files[$max]}"
	density_files[$max]="$z"

	q="${montage_files[$min]}"
	montage_files[$min]="${montage_files[$max]}"
	montage_files[$max]="$q"

	# Move closer
	(( --max ))
	(( ++min ))
	done
fi

echo ${tumor_files[@]}
for tumor in ${!tumor_files[@]}; do

	# $tumor is the index of the current value in the array tumor_files not the value


	tumor_path=${tumor_files[$((tumor + index))]}
	tumor_name=$(basename $tumor_path); tumor_name=${tumor_name%.*}
	output_dir="$output_path/$tumor_name"

	material_table_name=${material_files[$((tumor + index))]}
	density_table_name=${density_files[$((tumor + index))]}

	echo ""
	echo "Tumor Path: $tumor_path"
	echo "Output Dir: $output_dir"
	echo "Material Table: $material_table_name"
	echo "Density Table: $density_table_name"

	./simulation_run.sh -o "$output_dir" -s $starting_angle -e $end_angle -c $change_in_angle -t $tumor_path -m "$material_table_name" -d "$density_table_name"

	cp ${montage_files[$((tumor + index))]} $output_dir

done





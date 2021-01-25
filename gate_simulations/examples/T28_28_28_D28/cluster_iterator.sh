#!/bin/bash
# this will iterate over the tumors in cropped and call the simulation_run.sh
# to actually do the simulations.

tumor_directory=$local_cluster_tumor_dir
output_path=$local_cluster_output
starting_angle=1
end_angle=360
change_in_angle=6
$GC_DOT_GATE_DIR

if [[ ! -d $local_cluster_output ]]; then
	mkdir $local_cluster_output
fi

tumor_files=($tumor_directory/*)

# this tells the loop which tumor to start with
index=0
for tumor in ${!tumor_files[@]}; do

	tumor_path=${tumor_files[$index]}
	tumor_name=$(basename $tumor_path); tumor_name=${tumor_name%.*}
	output_dir="$output_path/tumor_$tumor_name"

	echo $tumor_path
	echo $output_dir
	echo $index

	./cluster_job_submitter.sh -o "$output_dir" -s $starting_angle -e $end_angle -c $change_in_angle -t $tumor_path

	((index=index+1))
done





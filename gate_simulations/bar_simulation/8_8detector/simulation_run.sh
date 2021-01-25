#!/bin/bash
# the order of arguments is starting_angle end_angle change_in_angle tumor_path output_path


while getopts ":o:s:e:c:t:h:m:d:" opt; do
	case $opt in
		o) output_path=${OPTARG};;
		s) starting_angle=${OPTARG};;
		e) end_angle=${OPTARG};;
		c) change_in_angle=${OPTARG};;
		t) tumor_path=${OPTARG};;
		m) material_Table=${OPTARG};;
		d) density_Table=${OPTARG};;
		h)	echo "Usage:"
			echo "		-o output_path"
			echo "		-s starting_angle"
			echo "		-e end_angle"
			echo "		-c change_in_angle"
			echo "		-t tumor_path"
	esac
done

if [[ -z $output_path ]] || [[ -z $starting_angle ]] || [[ -z $end_angle ]] || [[ -z $change_in_angle ]] || [[ -z $tumor_path ]]; then
	echo "Not all arguments were specified"
	exit 1
fi

# this makes the temp and output directory if they does not exist
temp_dir=$local_temp_dir

if [[ ! -d $temp_dir ]]; then
	mkdir -p $temp_dir
fi

if [[ ! -d $output_path ]]; then
	mkdir -p $output_path
fi

current_angle=$starting_angle
tumor_name=$( basename $tumor_path )
header_info="angle unknown unknown unknown unknown unknown unknown pixelID timeStamp edep stepLength xpos ypos zpos unimportant unimportant unimportant unimportant unimportant unimportant unimportant unimportant unimportant\n"

simulation_file="mac/synergy.mac"
echo "this is the temp dir: $temp_dir"
#cp $simulation_file "$temp_dir/synergy.mac"
#simulation_file="$temp_dir/synergy.mac"


sed -i "s:/gate/HounsfieldMaterialGenerator/SetMaterialTable[[:space:]]*.*:/gate/HounsfieldMaterialGenerator/SetMaterialTable $material_Table:" $simulation_file
sed -i "s:/gate/HounsfieldMaterialGenerator/SetDensityTable[[:space:]]*.*:/gate/HounsfieldMaterialGenerator/SetDensityTable $density_Table:" $simulation_file

# the angles start at 1 1-360 since arrays start at 1 in the data processing languages
while [ $current_angle -le $end_angle ]
do

	initial_phantom_edep_path="$temp_dir/phantom_deposition_angle_$( printf "%03d" ${current_angle})"
	initial_ascii_output_path="$temp_dir/simulation_angle_$( printf "%03d" ${current_angle})_output"

	sed -i "s:/gate/patient/placement/setRotationAngle[[:space:]]*.*:/gate/patient/placement/setRotationAngle $current_angle deg:" $simulation_file

	# path to correct tumor
	sed -i "s:/gate/patient/geometry/setImage[[:space:]]*.*:/gate/patient/geometry/setImage $tumor_path:" $simulation_file

	# ascii output path
	sed -i "s:/gate/output/ascii/setFileName[[:space:]]*.*:/gate/output/ascii/setFileName $initial_ascii_output_path:" $simulation_file

	# dose3d output path
	sed -i "s:/gate/actor/dose3d/save[[:space:]]*.*:/gate/actor/dose3d/save $initial_phantom_edep_path.mhd:" $simulation_file

	echo "I am in tumor $tumor_name on angle: $current_angle at $(date)" >> ./time_file.txt
	echo $simulation_file
	echo "I am in tumor $tumor_name on angle: $current_angle at $(date)"

	# set the variables designated by -v to the string with the number specified by %d padded with 3 digits of zeros
	printf -v angle_filename "simulation_angle_%03d_data.txt" $current_angle
	printf -v old_degree "%d deg" $current_angle
	printf -v new_degree "%d deg" $(($current_angle + $change_in_angle))
	printf -v gate_edep_name "phantom_deposition_%03d-Edep.txt" $starting_angle
	printf -v phantom_edep_name "phantom_deposition_%03d-Edep.txt" $current_angle

	Gate $simulation_file --qt 1>/dev/null 2>$output_path/error.log

	# the command is passed in as a string because i am reusing this script for the condor batching

	echo "Copying files over now!"

	#mv ${initial_phantom_edep_path}* $output_path/

	# moves the hits file to a temp file for manipulation
	#mv ${initial_ascii_output_path}Hits.dat "$temp_dir/temp_file"

	# deletes the leading blank space
	sed 's/[[:blank:]]\+//1' ${initial_ascii_output_path}Hits.dat |	sed 's/[[:blank:]]\+/,/g' |	awk -F, -v angle=$current_angle '{$1=angle}{print}' | sed "1 i/$header_info" > $output_path/$angle_filename

	# replaces all of the rest of the blank spaces with commas
	#sed -i 's/[[:blank:]]\+/,/g' $temp_dir/temp_file

	# replaces the first column with the angle of the run since the simulation can't do that
	#gawk -i inplace -F, -v angle=$current_angle '{$1=angle}{print}' $temp_dir/temp_file

	#sed -i "1 i/$header_info" $temp_dir/temp_file
	#cp "$temp_dir/temp_file" $output_path/$angle_filename

	#sed -i "s/${old_degree}/${new_degree}/" $simulation_file

	current_angle=$(($current_angle + $change_in_angle))
	echo "Done copying files now!"

done

cp $tumor_path $simulation_file $output_path

sed -i "s/${current_angle} deg/$starting_angle deg/" $simulation_file

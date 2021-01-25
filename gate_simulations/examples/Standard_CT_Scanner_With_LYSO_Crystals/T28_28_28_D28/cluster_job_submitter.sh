#!/bin/bash
# the order of arguments is starting_angle end_angle change_in_angle tumor_path output_path


while getopts ":o:s:e:c:t:h:" opt; do
	case $opt in
		o) output_path=${OPTARG};;
		s) starting_angle=${OPTARG};;
		e) end_angle=${OPTARG};;
		c) change_in_angle=${OPTARG};;
		t) tumor_path=${OPTARG};;
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

#output_path="/home/gmf/testScan"
#starting_angle=1
#end_angle=2
#change_in_angle=1
#tumor_path="./junk.mha"


temp_dir=$local_temp_dir/condor_output

if [[ ! -d $temp_dir ]];
then
	mkdir -p $temp_dir
fi

if [[ ! -d $output_path ]];
then
	mkdir -p $output_path
fi

current_angle=$starting_angle
tumor_name=$( basename $tumor_path ); tumor_name=${tumor_name%.*}
header_info="angle unknown unknown unknown unknown unknown unknown pixelID timeStamp edep stepLength xpos ypos zpos unimportant unimportant unimportant unimportant unimportant unimportant unimportant unimportant unimportant\n"

simulation_file=$(pwd)/mac/synergy.mac

if [[ ! -d $(pwd)/cluster_mac_storage ]];
then
	mkdir -p $(pwd)/cluster_mac_storage
fi

# this makes the temp and output directory if they does not exist
while [ $current_angle -le $end_angle ]
do

	new_name="synergy_t_${tumor_name}_a_$(printf "%03d" ${current_angle})_.mac"
	cp $simulation_file cluster_mac_storage/$new_name
	simulation_file=$(pwd)/cluster_mac_storage/$new_name

	initial_phantom_edep_path="$output_path/phantom_deposition_tumor_${tumor_name}_angle_$(printf "%03d" ${current_angle})"
	initial_ascii_output_path="$output_path/simulation_tumor_${tumor_name}_angle_$(printf "%03d" ${current_angle})_output"

	# this ensures the script starts at the correct angle without human intervention
	sed -i "s:/gate/FOV/placement/setRotationAngle[[:space:]]*.*:/gate/FOV/placement/setRotationAngle $starting_angle deg:" $simulation_file

	# path to correct tumor
	sed -i "s:/gate/patient/geometry/setImage[[:space:]]*.*:/gate/patient/geometry/setImage $tumor_path:" $simulation_file

	# ascii output path
	sed -i "s:/gate/output/ascii/setFileName[[:space:]]*.*:/gate/output/ascii/setFileName $initial_ascii_output_path:" $simulation_file

	# dose3d output path
	sed -i "s:/gate/actor/dose3d/save[[:space:]]*.*:/gate/actor/dose3d/save $initial_phantom_edep_path.txt:" $simulation_file

	echo "I am in tumor $tumor_name on angle: $current_angle at $(date)" >> ./time_file.txt
	echo "I am in tumor $tumor_name on angle: $current_angle at $(date)"

	# set the variables designated by -v to the string with the number specified by %d padded with 3 digits of zeros
	printf -v angle_filename "simulation_angle_%03d_data.txt" $current_angle
	printf -v old_degree "%d deg" $current_angle
	printf -v new_degree "%d deg" $(($current_angle + $change_in_angle))
	printf -v gate_edep_name "phantom_deposition_%03d-Edep.txt" $starting_angle
	printf -v phantom_edep_name "phantom_deposition_%03d-Edep.txt" $current_angle

	# the command is passed in as a string because i am reusing this script for the condor batching
	gjs -n 10 -condorscript $condorScriptPath $simulation_file

	sed -i "s/${old_degree}/${new_degree}/" $simulation_file

	current_angle=$(($current_angle + $change_in_angle))

done

#cp $tumor_path $simulation_file $output_path

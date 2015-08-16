#/bin/bash                                         
#####################################################################################
#####################################################################################
#
# title         : ffmpeg-image-sequencer.sh
# authors		: Bertrand Martel
# copyrights    : Copyright (c) 2015 Bertrand Martel
# license       : The MIT License (MIT)
# date          : 16/08/2015
# description   : create a MPEG4 video if not exist and append one or a list of JPG images to this video
# usage         : ./ffmpeg-image-sequencer.sh -i file1:file2:file3 -f <path_to_video_output>
#
#####################################################################################
#####################################################################################

#default path is in current directory

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
input_file=""

verbose=0

while getopts "h?i:f:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage : ffmpeg-image-sequencer.sh <file1>:<file2>:.....:<fileN>"
        exit 0
        ;;
    i)  input_file=$OPTARG
        ;;
    f)  output_file=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo "Processing list of files  : $input_file"
echo "Processing to output file : $output_file"

if [ -z $input_file ]; then
	echo "Usage : ffmpeg-image-sequencer.sh <file1>:<file2>:.....:<fileN>"
	exit 0
fi

FILE_LIST="$input_file"
VIDEO_INIT=""

#set workign directory
WORKING_DIR=./

OUTPUT_FILE_NAME="video_output"
OUTPUT_FILE_PATH="$WORKING_DIR/$OUTPUT_FILE_NAME.avi"
TEMPORARY_FILE_NAME="temp"
TEMPORARY_FILE_NAME_VIDEO="temp_video"

#change directory for ffmpeg processing
cd $WORKING_DIR

if [ "$output_file" != "$OUTPUT_FILE_NAME.avi" ]; then
	rm -rf $OUTPUT_FILE_NAME.avi
fi

if [ -f $output_file ]; then
	cp $output_file $WORKING_DIR/$OUTPUT_FILE_NAME.avi
fi

IFS=':' read -ra ADDR <<< "$FILE_LIST"

for i in "${ADDR[@]}"; do

	#create a video from the image
	ffmpeg -nostdin -v verbose -f image2 -pattern_type sequence -start_number 0 -r 1 -i $i -s 1920x1080 $TEMPORARY_FILE_NAME.avi

	if [ -f $OUTPUT_FILE_PATH ];
	then
		# concat this video and former video into a new one
		ffmpeg -nostdin -v verbose -i "concat:$OUTPUT_FILE_NAME.avi|$TEMPORARY_FILE_NAME.avi" -c copy $TEMPORARY_FILE_NAME_VIDEO.avi

		#remove the former output and the video previously created 
		rm $TEMPORARY_FILE_NAME.avi
		rm $OUTPUT_FILE_NAME.avi

		#rename to the output
		mv $TEMPORARY_FILE_NAME_VIDEO.avi $OUTPUT_FILE_NAME.avi
	else
		mv $TEMPORARY_FILE_NAME.avi $OUTPUT_FILE_NAME.avi
	fi

done
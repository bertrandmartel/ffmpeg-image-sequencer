#/bin/bash                                         
#####################################################################################
#####################################################################################
#
# title         : ffmpeg-appender-test.sh
# authors		: Bertrand Martel
# copyrights    : Copyright (c) 2015 Bertrand Martel
# license       : The MIT License (MIT)
# date          : 16/08/2015
# description   : create a MPEG4 video from a sequence of images taken from the web
# usage         : ./ffmpeg-appender-test.sh
#
#####################################################################################
#####################################################################################

#set workign directory
WORKING_DIR=./

OUTPUT_FILE_NAME="video_space"
OUTPUT_FILE_PATH="$WORKING_DIR/$OUTPUT_FILE_NAME.avi"
TEMPORARY_FILE_NAME="temp_space"
TEMPORARY_FILE_NAME_VIDEO="temp_video"

#set a list of picture to download
declare -a PICTURE_ARRAY=("https://upload.wikimedia.org/wikipedia/commons/4/4e/Anttlers101.jpg" \
	"https://upload.wikimedia.org/wikipedia/commons/3/3b/NASA-SpiralGalaxyM101-20140505.jpg" \
	"https://upload.wikimedia.org/wikipedia/commons/b/b0/Supernova_in_M101_2011-08-25.jpg" \
	"https://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg")

#change directory for ffmpeg processing
cd $WORKING_DIR

#remove temporary and output files if existing
rm -rf $OUTPUT_FILE_PATH
rm -rf $TEMPORARY_FILE_NAME.avi
rm -rf $TEMPORARY_FILE_NAME.jpg
rm -rf $TEMPORARY_FILE_NAME_VIDEO.avi

for i in {0..3}
{
	#get image from WEB path
	wget ${PICTURE_ARRAY[i]} -O $TEMPORARY_FILE_NAME.jpg

	#create a video from the image
	ffmpeg -nostdin -v verbose -f image2 -pattern_type sequence -start_number 0 -r 1 -i $TEMPORARY_FILE_NAME.jpg -s 1920x1080 $TEMPORARY_FILE_NAME.avi

	#remove jpg file we have just downloaded
	rm $TEMPORARY_FILE_NAME.jpg

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
}

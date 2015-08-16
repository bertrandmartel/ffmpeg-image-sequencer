#!/usr/bin/python
#####################################################################################
#####################################################################################
#
# title         : ffmpeg-appender-test.py
# authors		: Bertrand Martel
# copyrights    : Copyright (c) 2015 Bertrand Martel
# license       : The MIT License (MIT)
# date          : 16/08/2015
# description   : create video if not exist and append a series of image to this video taken from WEB
# usage         : python ffmpeg-appender-test.py
#
#####################################################################################
#####################################################################################

import sys, getopt, os, subprocess

def main(argv):
	
	output_file_name = "video_space"
	temporary_file_name = "temp_space"
	temporary_file_name_video = "temp_video"

	picture_array = [ "https://upload.wikimedia.org/wikipedia/commons/4/4e/Anttlers101.jpg", \
		"https://upload.wikimedia.org/wikipedia/commons/3/3b/NASA-SpiralGalaxyM101-20140505.jpg", \
		"https://upload.wikimedia.org/wikipedia/commons/b/b0/Supernova_in_M101_2011-08-25.jpg", \
		"http://1.1.1.5/bmi/images.nationalgeographic.com/wpf/media-live/photos/000/061/cache/earth-full-view_6125_990x742.jpg" ]

	this_dir = os.path.dirname(os.path.abspath(__file__))
	os.chdir(this_dir)

	output_file_path = ''.join([this_dir , "/",output_file_name,".avi"])
	temporary_file_path_avi = ''.join([this_dir,"/",temporary_file_name,".avi"])
	temporary_file_name_jpg = ''.join([this_dir,"/",temporary_file_name,".jpg"])
	temporary_file_name_video = ''.join([this_dir,"/",temporary_file_name_video,".avi"])

	#remove files

	try:
		os.remove(output_file_path)
	except OSError:
		pass

	try:
		os.remove(temporary_file_path_avi)
	except OSError:
		pass

	try:
		os.remove(temporary_file_name_jpg)
	except OSError:
		pass

	try:
		os.remove(temporary_file_name_video)
	except OSError:
		pass

	for picture in picture_array:

		subprocess.call(["wget", picture, "-O", temporary_file_name_jpg])

		subprocess.call(["ffmpeg -nostdin -v verbose -f image2 -pattern_type sequence -start_number 0 -r 1 -i " + temporary_file_name_jpg + " -s 1920x1080 " + temporary_file_path_avi],shell=True)

		try:
			os.remove(temporary_file_name_jpg)
		except OSError:
			pass
		
		if os.path.exists(output_file_path):

			# concat this video and former video
			subprocess.call(['cd ' + this_dir + ' | ffmpeg -nostdin -v verbose -i "concat:' + output_file_name + '.avi|' + temporary_file_name + '.avi" -c copy ' + temporary_file_name_video],shell=True)

			try:
				os.remove(temporary_file_path_avi)
			except OSError:
				pass

			try:
				os.remove(output_file_path)
			except OSError:
				pass

			os.rename(temporary_file_name_video, output_file_path)

		else:
			os.rename(temporary_file_path_avi, output_file_path)
	
if __name__ == "__main__":
	main(sys.argv[1:])

__author__ = "Bertrand Martel"
__copyright__ = "Copyright 2015, Bertrand Martel"
__credits__ = ["Bertrand Martel"]
__license__ = "MIT"
__version__ = "1.0.0"
__maintainer__ = "Bertrand Martel"
__email__ = "bmartel.fr@gmail.com"
__status__ = "POC"
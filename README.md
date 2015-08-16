# FFmpeg image video sequencer

<b>Create videos from image and append images to existing videos using ffmpeg</b>

Project is available in Linux Bash script and in Python script

ffmpeg 2.1+ is required

<h3>Bash</h3>

create video from image or append image to video : 

`./ffmpeg-image-sequencer.sh -i file1:file2:file3 -f <path_to_video_output>`

<i>Video must be encoded in mjpeg or mpeg4</i>
<i>path_to_video_output may already exists if that is the case the image are appended to it (if the video format is correct)</i>

<h4>Exemple</h4>  

``./ffmpeg-image-sequencer.sh -i ./image/picture1.jpg``

This will create a MPEG4 video showing picutre1.jpg during 1 second


``./ffmpeg-image-sequencer.sh -i ./image/picture2.jpg -f video2.mpeg``

This will append picture2.jpg to video2.mpeg

<h4>Testing script</h4>  

`./ffmpeg-appender_test.sh`

<h3>Python</h3>

Testing script : `python ffmpeg-encoder_test.py`

<h3>Testing script : what does it do ?</h3>

* download images from WEB
* create a video from image if no video existing
* create a video from image and append to existing video

The output is a video created in output directory which contains all 4 images getting from websites and with 1 second of frame rate.

<h3>How does it work ?</h3>

You can use ffmpeg create your video and append JPG image to it. 

To create the video from an existing image :

```
ffmpeg -f image2 -pattern_type sequence -start_number 0 -r 1 -i $TEMPORARY_FILE_NAME.jpg -s 1920x1080 $TEMPORARY_FILE_NAME.avi
```

* `-f image2` is Image file demuxer format
* `pattern_type sequence` is for sequential pattern
* `start_number` is the index of the sequence
* `-r 1` is the frame rate, I put it to 1 frame/s to have time to see each picture
* `-s 1920x1080` set the frame size

To append an image to an existing a video, you will have to convert this image to a temporary video first, and then concat your former video to this newly created video. To concat videos :

```
ffmpeg -i "concat:$OUTPUT_FILE_NAME.avi|$TEMPORARY_FILE_NAME.avi" -c copy $TEMPORARY_FILE_NAME_VIDEO.avi
```

* `-i "concat:$OUTPUT_FILE_NAME.avi|$TEMPORARY_FILE_NAME.avi"` take videos to concat, you can add more if you like between |
* `-c copy` will copy all video streams without reencoding 

You can find more information on ffmpg here https://ffmpeg.org/ffmpeg.html

<hr/>
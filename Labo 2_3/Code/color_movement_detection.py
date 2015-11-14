# Now we have a more complex scenario. 
# We have several objects of the same colour, i.e. 5 yellow balls.
# They are diposed around the scene having diferent sizes.
# What we want now is to track the only one that is moving around, no matter its size.
# Goals:
#
#    Step 1: 	Basic motion detection
#
#    Step 2: 	Detect the presence of colored objects using computer vision techniques.
#
#    Step 3: 	Track the object as it moves around in the video frames, 
#				drawing its previous positions as it moves, creating a tail behind it

from collections import deque
import numpy as np
import cv2
import math

#Convenience resize function
def resize(image, width=None, height=None, inter=cv2.INTER_AREA):
    # initialize the dimensions of the image to be resized and
    # grab the image size
    dim = None
    (h, w) = image.shape[:2]

    # if both the width and height are None, then return the
    # original image
    if width is None and height is None:
        return image

    # check to see if the width is None
    if width is None:
        # calculate the ratio of the height and construct the
        # dimensions
        r = height / float(h)
        dim = (int(w * r), height)

    # otherwise, the height is None
    else:
        # calculate the ratio of the width and construct the
        # dimensions
        r = width / float(w)
        dim = (width, int(h * r))

    # resize the image
    resized = cv2.resize(image, dim, interpolation=inter)

    # return the resized image
    return resized


def distance(list_x,list_y):
	return_value = 0
	for i in range(0,len(list_x)):
		return_value = return_value + (list_x[i]-list_y[i])**2
	return math.sqrt(return_value)


# Set the camera
VIDEODEV = 0
camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()


############################
# Set the background image #
############################
(grabbed, frame) = camera.read()

# resize the frame, convert it to grayscale, and blur it
frame = resize(frame, width=600)
gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
gray = cv2.GaussianBlur(gray, (21, 21), 0)



########################
# Set global variables #
########################
#colorLower = (0,0,0)
#colorUpper = (178,255,61)
colorLower = (72,148,0)
colorUpper = (136,255,175)
#colorLower = (31,98,10)
#colorUpper = (122,255,121)
objects_data = []		# Coordinates of every object to track
num_elements = 2		# Number of objects to track
mask_list = deque()		# Queue of masks to be able to track moving objects
first_frame = gray		# Background image
diffDelta = 20			# Threshold to determine when an object is moving
min_distance = 100		# Minimum distance between objects to classify them as the same
length_mask_queue = 5	# Length of mask queue


################
# Keep looping #
################
while True:
	# grab the current frame
	(grabbed, frame) = camera.read()
    
	# resize the frame, blur it, and convert it to the HSV
	# color space
	frame = resize(frame, width=600)
	blurred = cv2.GaussianBlur(frame, (11, 11), 0)
	hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)


    # compute the absolute difference between the current frame and
    # first frame
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	gray = cv2.GaussianBlur(gray, (21, 21), 0)
 	

    # construct a mask for the color selected, then perform
    # a series of dilations and erosions to remove any small
    # blobs left in the mask
	mask = cv2.inRange(hsv, colorLower, colorUpper)
	mask = cv2.erode(mask, None, iterations=2)
	mask = cv2.dilate(mask, None, iterations=2)
    

	if len(mask_list) < length_mask_queue:
		mask_list.append(mask)
	else:
		# We check the difference with the previous frame and update the mask queue
		previous_frame = mask_list.popleft()
		mask_list.append(mask)
		frameDelta = cv2.absdiff(previous_frame, mask)
		mask_1 = cv2.threshold(frameDelta, diffDelta, 255, cv2.THRESH_BINARY)[1]

		# We discard the background
		frameDelta = cv2.absdiff(first_frame, mask)
		mask_2 = cv2.threshold(frameDelta, diffDelta, 255, cv2.THRESH_BINARY)[1]
 		
 		mask = mask_1
 		mask[mask_2 < 200] = 0
		cv2.imshow("Mask", mask)


	    # find contours in the mask and initialize the current
	    # (x, y) center of the ball
		cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)[-2]
		center = None

	    # only proceed if at least one contour was found
		if len(cnts) > 0:
			# find the largest contour in the mask, then use
			# it to compute the minimum enclosing circle and
			# centroid
			c_maxes_aux = sorted(cnts, key=cv2.contourArea, reverse=True)

			c_maxes = []
			for i in range(0,min(num_elements,len(c_maxes_aux))):
				c_maxes.append(c_maxes_aux[i])

			indexes_to_keep = []
			count = 0
			for cmax in c_maxes:
				if cv2.contourArea(cmax) > 100:
					count = count + 1
					((x, y), radius) = cv2.minEnclosingCircle(cmax)
					found = False
					# only proceed if the radius meets a minimum size
					print cv2.contourArea(cmax)
					for i in range(0,len(objects_data)):
						element = objects_data[i]
						if distance(element[0],[x, y]) < min_distance:
							indexes_to_keep.append(i)
							found = True
							objects_data[i] = ([x, y], radius)
							M = cv2.moments(cmax)
							center = (int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"]))
							# draw the minimum enclosing circle, yellow colour in BGR format(), thickness = 2
							cv2.circle(frame, (int(x), int(y)), int(radius),(0, 255, 255), 2)
				            # draw the centroid,radius 5, red colour in BGR format(), thikness < 0 meaning that the circle is filled.
							cv2.circle(frame, center, 5, (0, 0, 255), -1)
							cv2.putText(frame, "Centroid  x: {}, y: {}".format(center[0], center[1]),(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX,
										0.35, (0, 0, 255), 1)
							cv2.putText(frame, "minEnclosing: x: {}, y: {}".format(int(x), int(y)),(10, frame.shape[0] - 30), cv2.FONT_HERSHEY_SIMPLEX,
										0.35, (0, 0, 255), 1)
					if not(found) and len(objects_data) < num_elements:
						print "AFEGIT!!!!!!!!!!!!!!!!!!!!!!!!!!!"
						objects_data.append(([x, y], radius))
			#indexes_to_keep.sort()
			#for i in range(len(objects_data)-1,-1,-1):
			#	if not(i in indexes_to_keep):
			#		print "REMOVED"
			#		del objects_data[i]

	    # Show the frame to our screen
		cv2.imshow("Frame", frame)
	key = cv2.waitKey(1) & 0xFF
    
    # If the 'q' key is pressed, stop the loop
	if key == ord("q"):
		break


# Cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()

# import the necessary packages

from collections import deque
import numpy as np
import cv2

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

VIDEODEV = 0

#Start Camera and check if it is open and releasse it 
camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
camera.release()

# keep looping
import time
camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
time.sleep(0.25)
while True:
    # grab the current frame
    (grabbed, frame) = camera.read()
     # show the frame to our screen
    cv2.imshow("Frame", frame)   
    # if the 'q' key is pressed, stop the loop
    
    if cv2.waitKey(1) & 0xFF is ord('q'):
        break
        
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()





def setup_trackbars(range_filter):
    cv2.namedWindow("Trackbars", 0)
    for i in ["MIN", "MAX"]:
        for j in range_filter:
            v = 0 if i == "MIN" else 255
            cv2.createTrackbar("%s_%s" % (j, i), "Trackbars", v, 255, lambda x : None)
            
            

def get_trackbar_values(range_filter):
    values = {}

    for i in ["MIN", "MAX"]:
        for j in range_filter:
            v = cv2.getTrackbarPos("%s_%s" % (j, i), "Trackbars")
            values["%s_%s" % (j, i)] = v
    return values

camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
setup_trackbars('HSV')
while True:
        (grabbed, frame) = camera.read()
        frame_to_thresh = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        v = get_trackbar_values('HSV')
        thresh = cv2.inRange(frame_to_thresh, (v['H_MIN'], v['S_MIN'], v['V_MIN']), (v['H_MAX'], v['S_MAX'], v['V_MAX']))
        cv2.imshow("Original", frame)
        cv2.imshow("Thresh", thresh)
        if cv2.waitKey(1) & 0xFF is ord('q'):
            break
            
print "Lower = (%d,%d,%d)" % (v['H_MIN'], v['S_MIN'], v['V_MIN'])
print "Upper = (%d,%d,%d)" % (v['H_MAX'], v['S_MAX'], v['V_MAX'])
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()

# define the lower and upper boundaries of the "yellow"
# ball in the HSV color space, then initialize the
# list of tracked points
colorLower = (v['H_MIN'], v['S_MIN'], v['V_MIN'])
colorUpper = (v['H_MAX'], v['S_MAX'], v['V_MAX'])
tailsize = 64
pts = deque(maxlen=tailsize)

camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
# keep looping
while True:
    # grab the current frame
    (grabbed, frame) = camera.read()
    
    # resize the frame, blur it, and convert it to the HSV
    # color space
    frame = resize(frame, width=600)
    blurred = cv2.GaussianBlur(frame, (11, 11), 0)
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
     # show the frame to our screen
    cv2.imshow("HSV", hsv)
    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1) & 0xFF
    
    # if the 'q' key is pressed, stop the loop
    if key == ord("q"):
        break
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()

camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
# keep looping
while True:
    # grab the current frame
    (grabbed, frame) = camera.read()
    
    # resize the frame, blur it, and convert it to the HSV
    # color space
    frame = resize(frame, width=600)
    blurred = cv2.GaussianBlur(frame, (11, 11), 0)
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
    
    # construct a mask for the color "green", then perform
    # a series of dilations and erosions to remove any small
    # blobs left in the mask
    mask = cv2.inRange(hsv, colorLower, colorUpper)
    mask = cv2.erode(mask, None, iterations=2)
    mask = cv2.dilate(mask, None, iterations=2)

    # show the frame to our screen
    cv2.imshow("Frame", frame)
    cv2.imshow("Mask", mask)
    key = cv2.waitKey(1) & 0xFF
    
    # if the 'q' key is pressed, stop the loop
    if key == ord("q"):
        break
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()

camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
# keep looping
while True:
    # grab the current frame
    (grabbed, frame) = camera.read()
    
    # resize the frame, blur it, and convert it to the HSV
    # color space
    frame = resize(frame, width=600)
    blurred = cv2.GaussianBlur(frame, (11, 11), 0)
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
    
    # construct a mask for the color selected, then perform
    # a series of dilations and erosions to remove any small
    # blobs left in the mask
    mask = cv2.inRange(hsv, colorLower, colorUpper)
    mask = cv2.erode(mask, None, iterations=2)
    mask = cv2.dilate(mask, None, iterations=2)
    
    # find contours in the mask and initialize the current
    # (x, y) center of the ball
    cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)[-2]
    center = None

    # only proceed if at least one contour was found
    if len(cnts) > 0:
        # find the largest contour in the mask, then use
        # it to compute the minimum enclosing circle and
        # centroid
        cmax = max(cnts, key=cv2.contourArea)
        ((x, y), radius) = cv2.minEnclosingCircle(cmax)
        M = cv2.moments(cmax)
        center = (int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"]))
        # only proceed if the radius meets a minimum size
        if radius > 10:
            # draw the minimum enclosing circle, yellow colour in BGR format(), thickness = 2
            cv2.circle(frame, (int(x), int(y)), int(radius),(0, 255, 255), 2)
            # draw the centroid,radius 5, red colour in BGR format(), thikness < 0 meaning that the circle is filled.
            cv2.circle(frame, center, 5, (0, 0, 255), -1)
            cv2.putText(frame, "Centroid  x: {}, y: {}".format(center[0], center[1]),(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX,
                        0.35, (0, 0, 255), 1)
            cv2.putText(frame, "minEnclosing: x: {}, y: {}".format(int(x), int(y)),(10, frame.shape[0] - 30), cv2.FONT_HERSHEY_SIMPLEX,
                        0.35, (0, 0, 255), 1)

    # show the frame to our screen
    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1) & 0xFF
    
    # if the 'q' key is pressed, stop the loop
    if key == ord("q"):
        break
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()

camera = cv2.VideoCapture(VIDEODEV); assert camera.isOpened()
# keep looping
while True:
    # grab the current frame
    (grabbed, frame) = camera.read()
    
    # resize the frame, blur it, and convert it to the HSV
    # color space
    frame = resize(frame, width=600)
    blurred = cv2.GaussianBlur(frame, (11, 11), 0)
    hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
    
    # construct a mask for the color selected, then perform
    # a series of dilations and erosions to remove any small
    # blobs left in the mask
    mask = cv2.inRange(hsv, colorLower, colorUpper)
    mask = cv2.erode(mask, None, iterations=2)
    mask = cv2.dilate(mask, None, iterations=2)
    
    # find contours in the mask and initialize the current
    # (x, y) center of the ball
    cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)[-2]
    center = None

    # only proceed if at least one contour was found
    if len(cnts) > 0:
        # find the largest contour in the mask, then use
        # it to compute the minimum enclosing circle and
        # centroid
        c = max(cnts, key=cv2.contourArea)
        ((x, y), radius) = cv2.minEnclosingCircle(c)
        M = cv2.moments(c)
        center = (int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"]))
        
        # only proceed if the radius meets a minimum size
        if radius > 10:
            # draw the circle and centroid on the frame,
            # then update the list of tracked points
            cv2.circle(frame, (int(x), int(y)), int(radius),(0, 255, 255), 2)
            cv2.circle(frame, center, 5, (0, 0, 255), -1)
            cv2.putText(frame, "x: {}, y: {}".format(center[0], center[1]),(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX,
                        0.35, (0, 0, 255), 1)
    # update the points queue
    pts.appendleft(center)

    # loop over the set of tracked points
    for i in xrange(1, len(pts)):
        # if either of the tracked points are None, ignore
        # them
        if pts[i - 1] is None or pts[i] is None:
            continue

        # otherwise, compute the thickness of the line and
        # draw the connecting lines
        thickness = int(np.sqrt(tailsize / float(i + 1)) * 2.5)
        cv2.line(frame, pts[i - 1], pts[i], (0, 0, 255), thickness)

    # show the frame to our screen
    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1) & 0xFF
    
    # if the 'q' key is pressed, stop the loop
    if key == ord("q"):
        break
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()
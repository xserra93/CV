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
CAMDEVICE = 0

# define the lower and upper boundaries of the "yellow"
# ball in the HSV color space, then initialize the
# list of tracked points
colorLower=(84,182,126)
colorUpper=(255,255,255)
tailsize = 64
pts = deque(maxlen=tailsize)
counter = 0
(dX, dY) = (0, 0)
direction = ""

camera = cv2.VideoCapture(CAMDEVICE); assert camera.isOpened()
threshold = 30
previous_point = 10

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
    # update the points queue
    pts.appendleft(center)
    counter=counter+1
    # loop over the set of tracked points
    for current_point in xrange(1, len(pts)):
        # if either of the tracked points are None, ignore
        # them
        if pts[current_point - 1] is None or pts[current_point] is None:
            continue
        # check to see if enough points have been accumulated in
        # the buffer
        if counter >= previous_point and current_point == 1 and pts[-previous_point] is not None:
            # compute the difference between the x and y
            # coordinates and re-initialize the direction
            # text variables
            dX = pts[-previous_point][0] - pts[current_point][0]
            dY = pts[-previous_point][1] - pts[current_point][1]
            (dirX, dirY) = ("", "")
 
            # ensure there is significant movement in the
            # x-direction
            if np.abs(dX) > threshold:
                dirX = "Right" if np.sign(dX) == 1 else "Left"
 
            # ensure there is significant movement in the
            # y-direction
            if np.abs(dY) > threshold:
                dirY = "Up" if np.sign(dY) == 1 else "Down"

            # handle when both directions are non-empty
            if dirX != "" and dirY != "":
                direction = "{}-{}".format(dirY, dirX)
            # otherwise, only one direction is non-empty
            else:
                direction = dirX if dirX != "" else dirY
        thickness = int(np.sqrt(tailsize / float(current_point + 1)) * 2.5)
        cv2.line(frame, pts[current_point - 1], pts[current_point], (0, 0, 255), thickness)

    cv2.putText(frame, direction, (10, 30), cv2.FONT_HERSHEY_SIMPLEX,0.65, (0, 0, 255), 3)
    cv2.putText(frame, "dx: {}, dy: {}".format(dX, dY),
        (10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX,0.35, (0, 0, 255), 1)
    # show the frame to our screen
    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1) & 0xFF
    
    # if the 'q' key is pressed, stop the loop
    if key == ord("q"):
        break
# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()
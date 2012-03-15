//
//  blobs.m
//  Enduro
//
//  Created by Phillip Tang on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "blobs.h"
#import "cvblob.h"
#import "CVImageConversion.h"

@implementation blobs

+(UIImage*) blobsOfImage: (UIImage*) image
{
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage: image];
    IplImage *RGBIplImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, RGBIplImage, CV_BGRA2BGR);
    
    IplImage *grayIplImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    cvCvtColor(iplImage, grayIplImage, CV_BGRA2GRAY);
    cvThreshold(grayIplImage, grayIplImage, 150, 255, CV_THRESH_BINARY);
    
    IplImage *labelImg=cvCreateImage(cvGetSize(grayIplImage), IPL_DEPTH_LABEL, 1);
    cvb::CvBlobs blobs;
    cvLabel(grayIplImage, labelImg, blobs);
    
    cvRenderBlobs(labelImg, blobs, RGBIplImage, RGBIplImage);
    
    IplImage *finalImage = cvCreateImage(cvGetSize(RGBIplImage), IPL_DEPTH_8U, 4);
    cvCvtColor(RGBIplImage, finalImage, CV_BGR2BGRA);
    return [CVImageConversion UIImageFromIplImage: finalImage];
}

@end

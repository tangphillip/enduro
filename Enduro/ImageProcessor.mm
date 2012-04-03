//
//  ImageProcessor.m
//  Enduro
//
//  Created by Phillip Tang on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageProcessor.h"
#import "cvblob.h"
#import "CVImageConversion.h"

@implementation ImageProcessor

+(NSArray*) blobsOfImage: (UIImage*) image
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
    
    NSMutableArray *blobPaths = [NSMutableArray array];
    
    for (cvb::CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
    {
//        NSLog(@"Blob #%u: Area=%u, Centroid=(%f,%f)", it->second->label, it->second->area, it->second->centroid.x, it->second->centroid.y);
        cvb::CvContourPolygon *contour = cvb::cvConvertChainCodesToPolygon(&(it->second->contour));
        UIBezierPath *path = [self pathOfContour:contour];
                
        [blobPaths addObject:path];
    }
    
//    NSLog(@"%@", blobPaths);

    return blobPaths;
    
//    IplImage *finalImage = cvCreateImage(cvGetSize(RGBIplImage), IPL_DEPTH_8U, 4);
//    cvCvtColor(RGBIplImage, finalImage, CV_BGR2BGRA);
//    return [CVImageConversion UIImageFromIplImage: finalImage];
}

+ (UIBezierPath*) pathOfContour: (cvb::CvContourPolygon*) contour {
    UIBezierPath *path = [[UIBezierPath alloc] init];

    cv::vector<CvPoint>::iterator it=contour->begin();
    CGPoint start = CGPointMake(it->x, it->y);
    [path moveToPoint: start];
    it++;
    
    for (; it!=contour->end(); ++it) {
        [path addLineToPoint: CGPointMake(it->x, it->y)];
    }
    
    [path addLineToPoint:start];
    [path closePath];
    return path;
}

@end

/*

CvContourChainCode it -> second -> contour;

typedef std::vector<CvPoint> CvContourPolygon;
CvContourPolygon *cvConvertChainCodesToPolygon(CvContourChainCode const *cc);

typedef struct CvPoint
{
    int x;
    int y;
}
CvPoint;

function :: [CvPoint] -> UIBezierPath
 
CGPathContainsPoint(UIBezierPath.CGPath, ...)

*/
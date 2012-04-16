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

typedef enum {
    ImageProcessorHue = 1,
    ImageProcessorSaturation = 2,
    ImageProcessorValue = 3
} ImageProcessorChannel;

@implementation ImageProcessor

+(void) writeImage: (IplImage*) image toFile: (NSString*) filename {
    NSArray *directories = [[NSFileManager alloc] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [directories lastObject];

    NSURL *imagePath = [documentsURL URLByAppendingPathComponent: [filename stringByAppendingString: @".png"]];
    UIImage *uiImg = [CVImageConversion UIImageFromIplImage:image];
    
    NSData *data = UIImagePNGRepresentation(uiImg);
    [data writeToURL:imagePath atomically:YES];
}


+ (void) thresholdImage: (IplImage*) image Name: (NSString*) filename WithLower:(int)lower AndUpper: (int)upper{
    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-full"]];
    NSLog(@"Should be 1: %d", image->nChannels);
    cvInRangeS(image, cvScalar(lower), cvScalar(upper), image);
    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-bit"]];
}


+(IplImage*)extractChannel: (ImageProcessorChannel) channel FromImage: (IplImage*) image IsRGB: (BOOL) isRGB {
    cvSetImageCOI(image, channel);

    IplImage* channelImage = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    cvCopy(image, channelImage);
    
    switch (channel) {
        case ImageProcessorHue:
            
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Red" WithLower:200 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Hue" WithLower:0 AndUpper: 100];
            }
            break;
            
        case ImageProcessorSaturation:
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Green" WithLower:190 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Saturation" WithLower:180 AndUpper: 255];
            }
            break;
            
        case ImageProcessorValue:
            
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Blue" WithLower:190 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Value" WithLower:205 AndUpper: 255];
            }
            break;
            
        default:
            break;
    }
    
    cvSetImageCOI(image, 0);
    return channelImage;
}



+(NSArray*) blobsOfImage: (UIImage*) image
{
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage: image];

    IplImage *RGBIplImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, RGBIplImage, CV_BGRA2BGR);
    
    IplImage *hsvImage = [CVImageConversion HSVImageFromRGBImage: RGBIplImage];
    
    IplImage *hueImage = [ImageProcessor extractChannel:ImageProcessorHue FromImage:hsvImage IsRGB:NO];
    IplImage *satImage = [ImageProcessor extractChannel:ImageProcessorSaturation FromImage:hsvImage IsRGB:NO];
    IplImage *valImage = [ImageProcessor extractChannel:ImageProcessorValue FromImage:hsvImage IsRGB:NO];
    
    IplImage *redImage = [ImageProcessor extractChannel:ImageProcessorHue FromImage:RGBIplImage IsRGB:YES];
    IplImage *greenImage = [ImageProcessor extractChannel:ImageProcessorSaturation FromImage:RGBIplImage IsRGB:YES];
    IplImage *blueImage = [ImageProcessor extractChannel:ImageProcessorValue FromImage:RGBIplImage IsRGB:YES];
    
    IplImage *cImage1 = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    IplImage *cImage2 = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    IplImage *cImage3 = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    
    cvOr(hueImage, satImage, cImage1);
    cvOr(redImage, valImage, cImage2);
    cvOr(blueImage, greenImage, cImage3);
    
    cvOr(cImage1, cImage2, cImage1);
    cvOr(cImage1, cImage3, cImage3);
    
    [ImageProcessor writeImage: cImage3 toFile: @"Combined-bitwise"];
    NSLog(@"Should be 1: %d", cImage3->nChannels);
    
    IplImage *labelImg = cvCreateImage(cvGetSize(cImage3), IPL_DEPTH_LABEL, 1);
    
    cvb::CvBlobs blobs;
    cvLabel(cImage3, labelImg, blobs);
    
    cvRenderBlobs(labelImg, blobs, RGBIplImage, RGBIplImage);
    
    NSMutableArray *blobPaths = [NSMutableArray array];
    
    for (cvb::CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
    {
        if(it->second->area > 300) {
            cvb::CvContourPolygon *contour = cvb::cvConvertChainCodesToPolygon(&(it->second->contour));
            UIBezierPath *path = [self pathOfContour:contour];
            
            [blobPaths addObject:path];            
        }
    }
    
    return blobPaths;
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
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

@interface ImageProcessor()

+(NSArray*) extractContours: (CvSeq*) contour withScaleFactor: (CGFloat) scale_factor;

@end

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
//    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-full"]];
//    NSLog(@"Should be 1: %d", image->nChannels);
    cvInRangeS(image, cvScalar(lower), cvScalar(upper), image);
//    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-bit"]];
}


+(IplImage*)extractChannel: (ImageProcessorChannel) channel FromImage: (IplImage*) image IsRGB: (BOOL) isRGB {
    cvSetImageCOI(image, channel);

    IplImage* channelImage = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    cvCopy(image, channelImage);
    
    switch (channel) {
        case ImageProcessorHue:
            
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Red" WithLower:255 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Hue" WithLower:255 AndUpper: 255];
            }
            break;
            
        case ImageProcessorSaturation:
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Green" WithLower:255 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Saturation" WithLower:128 AndUpper: 255];
            }
            break;
            
        case ImageProcessorValue:
            
            if (isRGB) {
                [ImageProcessor thresholdImage: channelImage Name: @"Blue" WithLower:255 AndUpper: 255];
            } else {
                [ImageProcessor thresholdImage: channelImage Name: @"Value" WithLower:170 AndUpper: 255];
            }
            break;
            
        default:
            break;
    }
    
    cvSetImageCOI(image, 0);
    return channelImage;
}


+(NSArray*) blobsOfImage: (UIImage*) image scaleFactor: (CGFloat) factor {
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage: image];

    IplImage *RGBIplImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, RGBIplImage, CV_BGRA2BGR);
    cvReleaseImage(&iplImage);
    
    IplImage *hsvImage = [CVImageConversion HSVImageFromRGBImage: RGBIplImage];
    
//    IplImage *hueImage = [ImageProcessor extractChannel:ImageProcessorHue FromImage:hsvImage IsRGB:NO];
    IplImage *satImage = [ImageProcessor extractChannel:ImageProcessorSaturation FromImage:hsvImage IsRGB:NO];
    IplImage *valImage = [ImageProcessor extractChannel:ImageProcessorValue FromImage:hsvImage IsRGB:NO];
    
//    IplImage *redImage = [ImageProcessor extractChannel:ImageProcessorHue FromImage:RGBIplImage IsRGB:YES];
//    IplImage *greenImage = [ImageProcessor extractChannel:ImageProcessorSaturation FromImage:RGBIplImage IsRGB:YES];
//    IplImage *blueImage = [ImageProcessor extractChannel:ImageProcessorValue FromImage:RGBIplImage IsRGB:YES];
    
    IplImage *combinedImage = cvCreateImage(cvGetSize(hsvImage), IPL_DEPTH_8U, 1);
    
    // combine the images
    cvOr(valImage,      satImage,   combinedImage);
    cvOr(combinedImage, valImage,   combinedImage);
//    cvOr(combinedImage, greenImage, combinedImage);
//    cvOr(combinedImage, redImage,   combinedImage);
//    cvOr(combinedImage, blueImage,  combinedImage);
    
//    cvReleaseImage(&hueImage);
    cvReleaseImage(&satImage);
    cvReleaseImage(&valImage);
//    cvReleaseImage(&redImage);
//    cvReleaseImage(&greenImage);
//    cvReleaseImage(&blueImage);
    cvReleaseImage(&hsvImage);
    cvReleaseImage(&RGBIplImage);
    
//    [ImageProcessor writeImage: combinedImage toFile: @"Combined-bitwise"];
//    NSLog(@"Should be 1: %d", combinedImage->nChannels);

    // discover blobs on each image??
    IplImage *labelImage = cvCreateImage(cvGetSize(combinedImage), IPL_DEPTH_LABEL, 1);
    cvb::CvBlobs blobs;
    cvLabel(combinedImage, labelImage, blobs);
    cvReleaseImage(&combinedImage);
    cvReleaseImage(&labelImage);
    
    NSMutableArray *blobPaths = [NSMutableArray array];
    for (cvb::CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
    {
        if(it->second->area > 300) {
            cvb::CvContourPolygon *contour = cvb::cvConvertChainCodesToPolygon(&(it->second->contour));
            UIBezierPath *path = [self pathOfContour:contour scaleFactor: factor];
            
            [blobPaths addObject:path];
        }
    }
    
    return blobPaths;
}

+ (UIBezierPath*) pathOfContour: (cvb::CvContourPolygon*) contour scaleFactor: (CGFloat) scale_factor {
    UIBezierPath *path = [[UIBezierPath alloc] init];

    cv::vector<CvPoint>::iterator it=contour->begin();
    CGPoint start = CGPointMake(it->x / scale_factor, it->y / scale_factor);
    [path moveToPoint: start];
    it++;
    
    for (; it!=contour->end(); ++it) {
        [path addLineToPoint: CGPointMake(it->x / scale_factor, it->y / scale_factor)];
    }
    
    [path addLineToPoint:start];
    [path closePath];
    return path;
}

+(NSArray*) extractContours: (CvSeq*) contour withScaleFactor: (CGFloat) scale_factor
{
    if(!contour) return nil;
    
    NSMutableArray *blobs = [NSMutableArray arrayWithCapacity: contour->total];
    
    CvTreeNodeIterator iterator;
    cvInitTreeNodeIterator( &iterator, contour, 100);

    while( (contour = (CvSeq*)cvNextTreeNode( &iterator )) != 0 )
    {
        CvSeqReader reader;
        int i, count = contour->total;
        
        cvStartReadSeq( contour, &reader, 0 );
        if( CV_IS_SEQ_POLYLINE( contour ) && cvContourArea(contour) > 1000)
        {
            CV_Assert( CV_MAT_TYPE(contour->flags) == CV_32SC2 );
            cv::Point start, point;
            
//            NSLog(@"Contour Area: %f", cvContourArea(contour));
            
            count -= !CV_IS_SEQ_CLOSED(contour);
            CV_READ_SEQ_ELEM( start, reader );
            UIBezierPath *path = [[UIBezierPath alloc] init];
            CGPoint begin = CGPointMake(start.x / scale_factor, start.y / scale_factor);
            [path moveToPoint: begin];
            
            for( i = 0; i < count; i++ )
            {
                CV_READ_SEQ_ELEM(point, reader);
                [path addLineToPoint: CGPointMake(point.x / scale_factor, point.y / scale_factor)];
            }

            [path addLineToPoint:begin];
            [path closePath];
            [blobs addObject:path];
        }
    }
    
    return blobs;
}

+ (NSArray*) contoursOfImage: (UIImage *) image scaleFactor: (CGFloat) factor {
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage: image];
    
    IplImage *RGBIplImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, RGBIplImage, CV_BGRA2BGR);
    cvReleaseImage(&iplImage);
    
    IplImage *hsvImage = [CVImageConversion HSVImageFromRGBImage: RGBIplImage];
    cvReleaseImage(&RGBIplImage);
    
    IplImage *satImage = [ImageProcessor extractChannel:ImageProcessorSaturation FromImage:hsvImage IsRGB:NO];
    IplImage *valImage = [ImageProcessor extractChannel:ImageProcessorValue FromImage:hsvImage IsRGB:NO];
    cvReleaseImage(&hsvImage);

    // combine the images
    cvOr(valImage, satImage, valImage);
    cvReleaseImage(&satImage);
    
    CvSeq *contours = NULL;
    CvMemStorage *storage = cvCreateMemStorage(0);
    cvFindContours(valImage, storage, &contours, sizeof(CvContour), CV_RETR_EXTERNAL);
    cvReleaseImage(&valImage);
    
    return [ImageProcessor extractContours:contours withScaleFactor:factor];
}

@end
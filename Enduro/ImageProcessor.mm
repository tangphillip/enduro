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

@interface ImageProcessor()
UIImage* CreateUIImageFromIplImage(IplImage* ipl_image);
UIImage*  CreateGrayUIImageFromIplImage(IplImage* ipl_image);
IplImage* convertImageRGBtoHSV(const IplImage *imageRGB);

+(void) writeImage: (IplImage*) image toFile: (NSString*) filename Grayscale: (BOOL) grayscale;

@end

@implementation ImageProcessor


UIImage*  CreateUIImageFromIplImage(IplImage* ipl_image) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData* data = [NSData dataWithBytes: ipl_image->imageData length: ipl_image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(ipl_image->width, ipl_image->height,
                                        ipl_image->depth, ipl_image->depth * ipl_image->nChannels, ipl_image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage* ret = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return ret;
}

UIImage*  CreateGrayUIImageFromIplImage(IplImage* ipl_image) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    NSData* data = [NSData dataWithBytes: ipl_image->imageData length: ipl_image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(ipl_image->width, ipl_image->height,
                                        ipl_image->depth, ipl_image->depth * ipl_image->nChannels, ipl_image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage* ret = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return ret;
}

IplImage* convertImageRGBtoHSV(const IplImage *imageRGB)
{
	float fR, fG, fB;
	float fH, fS, fV;
	const float FLOAT_TO_BYTE = 255.0f;
	const float BYTE_TO_FLOAT = 1.0f / FLOAT_TO_BYTE;
    
	// Create a blank HSV image
	IplImage *imageHSV = cvCreateImage(cvGetSize(imageRGB), 8, 3);
	if (!imageHSV || imageRGB->depth != 8 || imageRGB->nChannels != 3) {
		printf("ERROR in convertImageRGBtoHSV()! Bad input image.\n");
		exit(1);
	}
    
	int h = imageRGB->height;		// Pixel height.
	int w = imageRGB->width;		// Pixel width.
	int rowSizeRGB = imageRGB->widthStep;	// Size of row in bytes, including extra padding.
	char *imRGB = imageRGB->imageData;	// Pointer to the start of the image pixels.
	int rowSizeHSV = imageHSV->widthStep;	// Size of row in bytes, including extra padding.
	char *imHSV = imageHSV->imageData;	// Pointer to the start of the image pixels.
	for (int y=0; y<h; y++) {
		for (int x=0; x<w; x++) {
			// Get the RGB pixel components. NOTE that OpenCV stores RGB pixels in B,G,R order.
			uchar *pRGB = (uchar*)(imRGB + y*rowSizeRGB + x*3);
			int bB = *(uchar*)(pRGB+0);	// Blue component
			int bG = *(uchar*)(pRGB+1);	// Green component
			int bR = *(uchar*)(pRGB+2);	// Red component
            
			// Convert from 8-bit integers to floats.
			fR = bR * BYTE_TO_FLOAT;
			fG = bG * BYTE_TO_FLOAT;
			fB = bB * BYTE_TO_FLOAT;
            
			// Convert from RGB to HSV, using float ranges 0.0 to 1.0.
			float fDelta;
			float fMin, fMax;
			int iMax;
			// Get the min and max, but use integer comparisons for slight speedup.
			if (bB < bG) {
				if (bB < bR) {
					fMin = fB;
					if (bR > bG) {
						iMax = bR;
						fMax = fR;
					}
					else {
						iMax = bG;
						fMax = fG;
					}
				}
				else {
					fMin = fR;
					fMax = fG;
					iMax = bG;
				}
			}
			else {
				if (bG < bR) {
					fMin = fG;
					if (bB > bR) {
						fMax = fB;
						iMax = bB;
					}
					else {
						fMax = fR;
						iMax = bR;
					}
				}
				else {
					fMin = fR;
					fMax = fB;
					iMax = bB;
				}
			}
			fDelta = fMax - fMin;
			fV = fMax;				// Value (Brightness).
			if (iMax != 0) {			// Make sure its not pure black.
				fS = fDelta / fMax;		// Saturation.
				float ANGLE_TO_UNIT = 1.0f / (6.0f * fDelta);	// Make the Hues between 0.0 to 1.0 instead of 6.0
				if (iMax == bR) {		// between yellow and magenta.
					fH = (fG - fB) * ANGLE_TO_UNIT;
				}
				else if (iMax == bG) {		// between cyan and yellow.
					fH = (2.0f/6.0f) + ( fB - fR ) * ANGLE_TO_UNIT;
				}
				else {				// between magenta and cyan.
					fH = (4.0f/6.0f) + ( fR - fG ) * ANGLE_TO_UNIT;
				}
				// Wrap outlier Hues around the circle.
				if (fH < 0.0f)
					fH += 1.0f;
				if (fH >= 1.0f)
					fH -= 1.0f;
			}
			else {
				// color is pure Black.
				fS = 0;
				fH = 0;	// undefined hue
			}
            
			// Convert from floats to 8-bit integers.
			int bH = (int)(0.5f + fH * 255.0f);
			int bS = (int)(0.5f + fS * 255.0f);
			int bV = (int)(0.5f + fV * 255.0f);
            
			// Clip the values to make sure it fits within the 8bits.
			if (bH > 255)
				bH = 255;
			if (bH < 0)
				bH = 0;
			if (bS > 255)
				bS = 255;
			if (bS < 0)
				bS = 0;
			if (bV > 255)
				bV = 255;
			if (bV < 0)
				bV = 0;
            
			// Set the HSV pixel components.
			uchar *pHSV = (uchar*)(imHSV + y*rowSizeHSV + x*3);
			*(pHSV+0) = bH;		// H component
			*(pHSV+1) = bS;		// S component
			*(pHSV+2) = bV;		// V component
		}
	}
	return imageHSV;
}

typedef enum {
    ImageProcessorHue = 1,
    ImageProcessorSaturation = 2,
    ImageProcessorValue = 3
} ImageProcessorChannel;


+(void) writeImage: (IplImage*) image toFile: (NSString*) filename Grayscale: (BOOL) grayscale {
    NSArray *directories = [[NSFileManager alloc] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [directories lastObject];

    NSURL *imagePath = [documentsURL URLByAppendingPathComponent: [filename stringByAppendingString: @".png"]];
    UIImage *uiImg = grayscale ? CreateGrayUIImageFromIplImage(image) : CreateUIImageFromIplImage(image);
    
    NSData *data = UIImagePNGRepresentation(uiImg);
    [data writeToURL:imagePath atomically:YES];
}


+ (void) thresholdImage: (IplImage*) image Name: (NSString*) filename WithLower:(int)lower AndUpper: (int)upper{
    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-full"] Grayscale:YES];
    cvInRangeS(image, cvScalar(lower), cvScalar(upper), image);
    [ImageProcessor writeImage:image toFile: [filename stringByAppendingString:@"-bit"] Grayscale:YES];
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
    
    IplImage *hsvImage = convertImageRGBtoHSV(RGBIplImage);
    
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
    
    [ImageProcessor writeImage: cImage3 toFile: @"Combined-bitwise" Grayscale: YES];
    
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
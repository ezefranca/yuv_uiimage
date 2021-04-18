//
//  YUVConverter.m
//  YUV
//
//  Created by Ezequiel on 18/04/21.
//

#import "YUVConverter.h"
@import UIKit;
@import AVKit;

@implementation YUVConverter

-(CVPixelBufferRef)conversionUIImageToYUV: (UIImage *)image {
    
    CGImageRef imgRef = [image CGImage];
    
    size_t frameWidth = CGImageGetWidth(imgRef);
    NSLog(@"frameWidth:%lu",frameWidth);
    size_t frameHeight = CGImageGetHeight(imgRef);
    NSLog(@"frameHeight:%lu",frameHeight);
    size_t bytesPerRow = CGImageGetBytesPerRow(imgRef);
    NSLog(@"bytesPerRow:%lu ==:%lu",bytesPerRow,bytesPerRow/4);
    
    NSDictionary *options = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef yuvPixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, (__bridge CFDictionaryRef)(options), &yuvPixelBuffer);
    NSParameterAssert(status == kCVReturnSuccess && yuvPixelBuffer != NULL);
        
    CVPixelBufferLockBaseAddress(yuvPixelBuffer, 0);
    
    CGDataProviderRef provider = CGImageGetDataProvider(imgRef);
    CFDataRef pixelData = CGDataProviderCopyData(provider);
    const unsigned char *data = CFDataGetBytePtr(pixelData);
        
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imgRef);
    NSLog(@"bitsPerPixel:%lu",bitsPerPixel);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imgRef);
    NSLog(@"bitsPerComponent:%lu",bitsPerComponent);
        
    NSLog(@"\n");
        
    CFRelease(pixelData);
    
        
    NSLog(@"\n");
        
    size_t width = CVPixelBufferGetWidth(yuvPixelBuffer);
    NSLog(@"width:%lu",width);
    size_t height = CVPixelBufferGetHeight(yuvPixelBuffer);
    NSLog(@"height:%lu",height);
    size_t bpr = CVPixelBufferGetBytesPerRow(yuvPixelBuffer);
    NSLog(@"bpr:%lu",bpr);
        
    NSLog(@"\n");
        
    size_t wh = width * height;
    NSLog(@"wh:%lu\n",wh);
    size_t size = CVPixelBufferGetDataSize(yuvPixelBuffer);
    NSLog(@"size:%lu",size);
    size_t count = CVPixelBufferGetPlaneCount(yuvPixelBuffer);
    NSLog(@"count:%lu\n",count);
        
    NSLog(@"\n");
        
    size_t width0 = CVPixelBufferGetWidthOfPlane(yuvPixelBuffer, 0);
    NSLog(@"width0:%lu",width0);
    size_t height0 = CVPixelBufferGetHeightOfPlane(yuvPixelBuffer, 0);
    NSLog(@"height0:%lu",height0);
    size_t bpr0 = CVPixelBufferGetBytesPerRowOfPlane(yuvPixelBuffer, 0);
    NSLog(@"bpr0:%lu",bpr0);
        
    NSLog(@"\n");
        
    size_t width1 = CVPixelBufferGetWidthOfPlane(yuvPixelBuffer, 1);
    NSLog(@"width1:%lu",width1);
    size_t height1 = CVPixelBufferGetHeightOfPlane(yuvPixelBuffer, 1);
    NSLog(@"height1:%lu",height1);
    size_t bpr1 = CVPixelBufferGetBytesPerRowOfPlane(yuvPixelBuffer, 1);
    NSLog(@"bpr1:%lu",bpr1);
        
    unsigned char *bufY = malloc(wh);
    unsigned char *bufUV = malloc(wh/2);
     
    size_t offset,p;
     
    int r,g,b,y,u,v;
    int a=255;
    for (int row = 0; row < height; ++row) {
      for (int col = 0; col < width; ++col) {
        //
        offset = ((width * row) + col);
        p = offset*4;
        //
        r = data[p + 0];
        g = data[p + 1];
        b = data[p + 2];
        a = data[p + 3];
        //
        y = 0.299*r + 0.587*g + 0.114*b;
        u = -0.1687*r - 0.3313*g + 0.5*b + 128;
        v = 0.5*r - 0.4187*g - 0.0813*b + 128;
        //
        bufY[offset] = y;
        bufUV[(row/2)*width + (col/2)*2] = u;
        bufUV[(row/2)*width + (col/2)*2 + 1] = v;
      }
    }
    uint8_t *yPlane = CVPixelBufferGetBaseAddressOfPlane(yuvPixelBuffer, 0);
    memset(yPlane, 0x80, height0 * bpr0);
    for (int row=0; row<height0; ++row) {
      memcpy(yPlane + row*bpr0, bufY + row*width0, width0);
    }
    uint8_t *uvPlane = CVPixelBufferGetBaseAddressOfPlane(yuvPixelBuffer, 1);
    memset(uvPlane, 0x80, height1 * bpr1);
    for (int row=0; row<height1; ++row) {
      memcpy(uvPlane + row*bpr1, bufUV + row*width, width);
    }
        
    CVPixelBufferUnlockBaseAddress(yuvPixelBuffer, 0);
    free(bufY);
    free(bufUV);
     
    return yuvPixelBuffer;
}

- (UIImage *)conversionBufferYUVtoUIImage:(CVPixelBufferRef) yuvPixelBuffer {
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:yuvPixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                       createCGImage:ciImage
                       fromRect:CGRectMake(0, 0,
                              CVPixelBufferGetWidth(yuvPixelBuffer),
                              CVPixelBufferGetHeight(yuvPixelBuffer))];

    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
}

@end




//
//  YUVConverter.h
//  YUV
//
//  Created by Ezequiel on 18/04/21.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import AVKit;

NS_ASSUME_NONNULL_BEGIN

@interface YUVConverter : NSObject
- (CVPixelBufferRef)conversionUIImageToYUV: (UIImage *)image;
- (UIImage *)conversionBufferYUVtoUIImage:(CVPixelBufferRef) yuvPixelBuffer;
@end

NS_ASSUME_NONNULL_END

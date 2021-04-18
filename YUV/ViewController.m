//
//  ViewController.m
//  YUV
//
//  Created by Ezequiel on 18/04/21.
//

#import "ViewController.h"
#import "YUVConverter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *imageOriginal = [UIImage imageNamed:@"f1.png"];
    UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake(0,100,168,133)];
    [img setImage:imageOriginal];
    [[self view]addSubview:img];
    // Do any additional setup after loading the view.
    YUVConverter *yuvconversor = [YUVConverter new];
    CVPixelBufferRef bufferYUV = [yuvconversor conversionUIImageToYUV:imageOriginal];
    UIImage *imageYUV = [yuvconversor conversionBufferYUVtoUIImage:bufferYUV];
    
    UIImageView *img2 =[[UIImageView alloc] initWithFrame:CGRectMake(0,300,168,133)];
    [img2 setImage:imageYUV];
    [[self view]addSubview:img2];
}


@end

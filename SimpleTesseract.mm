//
//  SimpleTesseract.m
//  meanings_app
//
//  Created by Jinah Adam on 6/16/13.
//  Copyright (c) 2013 Jinah Adam. All rights reserved.
//

#import "SimpleTesseract.h"

@implementation SimpleTesseract

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        ProcessQ = dispatch_queue_create("com.jinahadam.ocrq", 0);
    }
    return self;
}


-(void) process {
    dispatch_async(ProcessQ, ^(void){
        //Background Thread
        self.output = [self ocr:self.image];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //call delegate
            //set image?? use delegate
            if (_delegate != nil) {
                [_delegate getTextForOCRImage:self.output];
            }
            
            
        });
    });
}


- (void)copyDataToDocumentsDirectory {
    
    // Useful paths
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    NSString *dataPath = [documentPath stringByAppendingPathComponent:_dataPath];
    
    // Copy data in Doc Directory
    if (![fileManager fileExistsAtPath:dataPath]) {
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:_dataPath];
        if (tessdataPath) {
            [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:NULL];
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:nil];
        }
    }
    
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
}


-(NSString *)ocr:(UIImage *)uiimage {
    
    NSString *result;
    @autoreleasepool {
        
        
        
        tesseract::ImageThresholder *imageThresholder;
        
        [self copyDataToDocumentsDirectory];
        
        
        tesseract::TessBaseAPI *api = new tesseract::TessBaseAPI();
        if (api->Init([_dataPath UTF8String], [_language UTF8String])) {
            fprintf(stderr, "Could not initialize tesseract.\n");
            exit(1);
        }
        
        
        
        CGSize imageSize = [uiimage size];
        double bytes_per_line   = CGImageGetBytesPerRow([uiimage CGImage]);
        double bytes_per_pixel  = CGImageGetBitsPerPixel([uiimage CGImage]) / 8.0;
        
        CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([uiimage CGImage]));
        const UInt8 *imageData = CFDataGetBytePtr(data);
        imageThresholder = new tesseract::ImageThresholder();
        
        imageThresholder->SetImage(imageData,(int) imageSize.width,(int) imageSize.height,(int)bytes_per_pixel,(int)bytes_per_line);
        
        
        
        api->SetImage(imageThresholder->GetPixRect());
        
        //   pixDestroy(&image);
        
        NSString* text = [NSString stringWithUTF8String:api->GetUTF8Text()];
        NSCharacterSet* charsToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
      //  printf("\tResult:%s",[[output stringByTrimmingCharactersInSet:charsToTrim] UTF8String]);
        result = text;
        charsToTrim=nil;
        text=nil;
        
        imageThresholder->Clear();
        CFRelease(data);
        
        api->End();
        delete api;
        delete imageThresholder;
        imageThresholder = nil;
        api = nil;
        std::cin.ignore();
    }
    
    return result;
}

@end

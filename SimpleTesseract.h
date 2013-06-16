//
//  SimpleTesseract.h
//  meanings_app
//
//  Created by Jinah Adam on 6/16/13.
//  Copyright (c) 2013 Jinah Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "baseapi.h"

@protocol OCRDelegate
- (void)getTextForOCRImage:(NSString *)output;
@end



@interface SimpleTesseract : NSObject {
    NSString* _dataPath;
    NSString* _language;
    dispatch_queue_t ProcessQ;


}

@property (strong) id<OCRDelegate> delegate;

@property (strong, nonatomic) NSString* output;
@property (strong, nonatomic) UIImage* image;


- (id)initWithImage:(UIImage *)image;
-(void) process;

@end

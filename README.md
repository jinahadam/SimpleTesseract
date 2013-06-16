SimpleTesseract
===============

A Dead Simple Obj-C Wrapper for Tesseract OCR. 

Usage 
===============

    SimpleTesseract *tesseract = [[SimpleTesseract alloc] initWithImage:cropped];
    tesseract.delegate = self;
    [tesseract process];
 
Delegate Method
===============

    - (void)getTextForOCRImage:(NSString *)output {
      NSLog(@"OCR %@",output);
     }

Prerequisites 
================
* Tesseract Library Compiled for iOS
* 

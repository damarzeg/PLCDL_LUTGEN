//
//  DMAppDelegate.h
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 17/04/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import <Cocoa/Cocoa.h>





@interface DMAppDelegate : NSObject <NSApplicationDelegate>
{
    //NSMutableDictionary* setOfvalues;
    NSInteger lutType;
    NSString* filePath;
    float offsetRvalue;
    float offsetGvalue;
    float offsetBvalue;
    float slopeRvalue;
    float slopeGvalue;
    float slopeBvalue;
    float powRvalue;
    float powGvalue;
    float powBvalue;
    int printerPR;
    int printerPG;
    int printerPB;
    NSArray *arrayLutSize;
    int lutSize;
    NSArray *baseLut;
}

@property (weak) IBOutlet NSStepper *stepperBoutlet;
@property (weak) IBOutlet NSStepper *stepperGoutlet;
@property (weak) IBOutlet NSStepper *stepperRoutlet;
- (IBAction)RgbP3ToXYZ:(id)sender;
- (IBAction)Rec709ToXYZ:(id)sender;
- (IBAction)XYZToRec709:(id)sender;
- (IBAction)generateLutFromCube:(id)sender;
    
@property (weak) IBOutlet NSSlider *offsetBSlider;
@property (weak) IBOutlet NSSlider *offsetGSlider;
@property (weak) IBOutlet NSSlider *offsetRSlider;
@property (weak) IBOutlet NSSlider *slopeRSlider;
@property (weak) IBOutlet NSSlider *slopeGSlider;
@property (weak) IBOutlet NSSlider *slopeBSlider;
@property (weak) IBOutlet NSSlider *powRSlider;
@property (weak) IBOutlet NSSlider *powGSlider;
@property (weak) IBOutlet NSSlider *powBSlider;
@property float offsetRvalue;
@property float offsetGvalue;
@property float offsetBvalue;
@property float slopeRvalue;
@property float slopeGvalue;
@property float slopeBvalue;
@property float powRvalue;
@property float powGvalue;
@property float powBvalue;
@property int printerPR;
@property int printerPG;
@property int printerPB;
@property NSArray *arrayLutSize;
@property (weak) IBOutlet NSPopUpButton *popUpLutSize;
@property (weak) IBOutlet NSImageView *histoWindow;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *monitor;
@property (weak) IBOutlet NSTextField *R1;
@property (weak) IBOutlet NSTextField *G1;
@property (weak) IBOutlet NSTextField *B1;
@property (weak) IBOutlet NSTextField *R2;
@property (weak) IBOutlet NSTextField *B2;
@property (weak) IBOutlet NSTextField *G2;
@property (weak) IBOutlet NSTextField *R3;
@property (weak) IBOutlet NSTextField *B3;
@property (weak) IBOutlet NSTextField *G3;
@property (weak) IBOutlet NSTextField *GammaIn;
@property (weak) IBOutlet NSTextField *GammaOut;


@end

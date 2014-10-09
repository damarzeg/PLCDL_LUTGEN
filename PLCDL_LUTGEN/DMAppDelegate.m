//
//  DMAppDelegate.m
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 17/04/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import "DMAppDelegate.h"
#import "DMCalcFilter.h"
#import "DMHistogramGenerator.h"
#import "DMBaseLutGenerator.h"
#import "DMGenerateLutFromCube.h"


@implementation DMAppDelegate
@synthesize offsetRvalue, offsetGvalue, offsetBvalue, slopeRvalue, slopeGvalue, slopeBvalue, powRvalue,powGvalue,powBvalue, printerPB, printerPG,printerPR,arrayLutSize;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    arrayLutSize=@[@"17*17*17",@"33*33*33"];
    lutSize=17;
    [self.popUpLutSize addItemsWithTitles:arrayLutSize];
    [self.slopeRSlider setFloatValue:1.0f];
    [self.slopeGSlider setFloatValue:1.0f];
    [self.slopeBSlider setFloatValue:1.0f];
    [self.powRSlider setFloatValue:1.0f];
    [self.powGSlider setFloatValue:1.0f];
    [self.powBSlider setFloatValue:1.0f];
    [self setPrinterPB:25];
    [self setPrinterPG:25];
    [self setPrinterPR:25];
    filePath=@"/Users/dariomarzeglia/Dropbox/Objective-c_proj/PLCDL_LUTGEN/PLCDL_LUTGEN/marci512_Cineon.jpg";
    double delayInSeconds=1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSImage* nsImage = [[NSImage alloc ]initWithContentsOfFile:filePath];
    [self.monitor setImage:nsImage];
            DMHistogramGenerator *myHisto=[[DMHistogramGenerator alloc]init];
            [self.histoWindow setImage:[myHisto generateHistogramForImage:nsImage]];
    });
    
}
- (IBAction)sliderDidMove:(id)sender {
    NSDictionary* setOfvalues =[[NSDictionary alloc]initWithObjectsAndKeys:[self.offsetRSlider stringValue],@"offsetR",[self.offsetGSlider stringValue],@"offsetG",[self.offsetBSlider stringValue],@"offsetB",[self.slopeRSlider stringValue],@"slopeR",[self.slopeGSlider stringValue],@"slopeG",[self.slopeBSlider stringValue],@"slopeB",[self.powRSlider stringValue],@"powR",[self.powGSlider stringValue],@"powG",[self.powBSlider stringValue],@"powB", nil];
    NSDictionary* theMatrix= [[NSDictionary alloc] initWithObjectsAndKeys:self.R1.stringValue,@"R1",self.G1.stringValue,@"G1",self.B1.stringValue,@"B1",self.R2.stringValue,@"R2",self.G2.stringValue,@"G2",self.B2.stringValue,@"B2",self.R3.stringValue,@"R3",self.G3.stringValue,@"G3",self.B3.stringValue,@"B3", self.GammaIn.stringValue,@"GammaIn",self.GammaOut.stringValue,@"GammaOut", nil];
    if (!baseLut){
        DMBaseLutGenerator *myBL=[[DMBaseLutGenerator alloc]init];
        baseLut = [myBL generateLut];
    }
    
    DMCalcFilter *myFilter=[[DMCalcFilter alloc]init];
    [self.monitor setImage:[myFilter getImageFiltered:[NSURL fileURLWithPath:filePath] forValueSet:setOfvalues  ofLutSize:lutSize byMatrix:theMatrix withBaseLut:baseLut]];
    DMHistogramGenerator *myHisto=[[DMHistogramGenerator alloc]init];
    [self.histoWindow setImage:[myHisto generateHistogramForImage:[myFilter getImageFiltered:[NSURL fileURLWithPath:filePath] forValueSet:setOfvalues  ofLutSize:lutSize byMatrix:theMatrix withBaseLut:baseLut]]];

}

- (IBAction)stepperBaction:(id)sender {

    [self setOffsetBvalue:[self offsetBvalue]+(([self.stepperBoutlet floatValue]*-11)/1024)];
    [self.offsetBSlider setFloatValue:offsetBvalue];
    [self sliderDidMove:NULL];
    [self setPrinterPB:printerPB+[self.stepperBoutlet intValue]];
    [self.stepperBoutlet setIntegerValue:0];
}
- (IBAction)stepperGaction:(id)sender {

    [self setOffsetGvalue:[self offsetGvalue]+(([self.stepperGoutlet floatValue]*-11)/1024)];
    [self.offsetGSlider setFloatValue:offsetGvalue];
    [self sliderDidMove:NULL];
    [self setPrinterPG:printerPG+[self.stepperGoutlet intValue]];
    [self.stepperGoutlet setIntegerValue:0];
}
- (IBAction)stepperRoutlet:(id)sender {
    [self setOffsetRvalue:[self offsetRvalue]+(([self.stepperRoutlet floatValue]*-11)/1024)];
    [self.offsetRSlider setFloatValue:offsetRvalue];
    [self sliderDidMove:NULL];
    [self setPrinterPR:printerPR+[self.stepperRoutlet intValue]];
    [self.stepperRoutlet setIntegerValue:0];
}
- (IBAction)exportLutForClipster:(id)sender {
    DMCalcFilter *myFilter=[[DMCalcFilter alloc]init];
    DMGenerateLutFromCube *mySorter=[[DMGenerateLutFromCube alloc]init];
     NSDictionary* setOfvalues =[[NSDictionary alloc]initWithObjectsAndKeys:[self.offsetRSlider stringValue],@"offsetR",[self.offsetGSlider stringValue],@"offsetG",[self.offsetBSlider stringValue],@"offsetB",[self.slopeRSlider stringValue],@"slopeR",[self.slopeGSlider stringValue],@"slopeG",[self.slopeBSlider stringValue],@"slopeB",[self.powRSlider stringValue],@"powR",[self.powGSlider stringValue],@"powG",[self.powBSlider stringValue],@"powB", nil];
    NSDictionary* theMatrix= [[NSDictionary alloc] initWithObjectsAndKeys:self.R1.stringValue,@"R1",self.G1.stringValue,@"G1",self.B1.stringValue,@"B1",self.R2.stringValue,@"R2",self.G2.stringValue,@"G2",self.B2.stringValue,@"B2",self.R3.stringValue,@"R3",self.G3.stringValue,@"G3",self.B3.stringValue,@"B3",self.GammaIn.stringValue,@"GammaIn",self.GammaOut.stringValue,@"GammaOut", nil];
    if (!baseLut){
        DMBaseLutGenerator *myBL=[[DMBaseLutGenerator alloc]init];
        baseLut = [myBL generateLut];
    }
    NSMutableString *lutFileOut=[[NSMutableString alloc] initWithString: @"LUT_3D_SIZE 17\n"];
    NSArray *lutToExport=[mySorter sortLut:[myFilter getLutFilteredForValueSet:setOfvalues ofLutSize:17 byMatrix:theMatrix withBaseLut:baseLut] fastest:@"rIndex" faster:@"gIndex"];

    for (int i=0; i<([lutToExport count]-1); i++) {
        NSString *rValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"r"]floatValue])];
        NSString *gValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"g"]floatValue])];
        NSString *bValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"b"]floatValue])];
        [lutFileOut appendString:[NSString stringWithFormat:@"%@ %@ %@\n",rValue,gValue,bValue]];
    }
    
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setMessage:@"Please select a path where to save the LUT"]; // Message inside modal window

    [panel setDirectoryURL:[NSURL fileURLWithPath:documentFolderPath]];
    
    [panel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"xml",nil]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setTitle:@"Exporting LUT for Clipster..."]; // Window title
    
    NSInteger result = [panel runModal];
    NSError *error = nil;
    
    if (result == NSOKButton) {
        ////////////////////////////////////////////
        if (![[[panel URL]path]pathExtension]){
            NSString *path = [[[panel URL] path]stringByAppendingString:@".xml"];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        else{
            NSString *path = [[panel URL] path];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
        }
               if (error) {
            [NSApp presentError:error];
        }
    }

    
}
- (IBAction)exportLutForLustre:(id)sender {
    DMCalcFilter *myFilter=[[DMCalcFilter alloc]init];
    DMGenerateLutFromCube *mySorter=[[DMGenerateLutFromCube alloc]init];
    NSDictionary* setOfvalues =[[NSDictionary alloc]initWithObjectsAndKeys:[self.offsetRSlider stringValue],@"offsetR",[self.offsetGSlider stringValue],@"offsetG",[self.offsetBSlider stringValue],@"offsetB",[self.slopeRSlider stringValue],@"slopeR",[self.slopeGSlider stringValue],@"slopeG",[self.slopeBSlider stringValue],@"slopeB",[self.powRSlider stringValue],@"powR",[self.powGSlider stringValue],@"powG",[self.powBSlider stringValue],@"powB", nil];
    NSDictionary* theMatrix= [[NSDictionary alloc] initWithObjectsAndKeys:self.R1.stringValue,@"R1",self.G1.stringValue,@"G1",self.B1.stringValue,@"B1",self.R2.stringValue,@"R2",self.G2.stringValue,@"G2",self.B2.stringValue,@"B2",self.R3.stringValue,@"R3",self.G3.stringValue,@"G3",self.B3.stringValue,@"B3",self.GammaIn.stringValue,@"GammaIn",self.GammaOut.stringValue,@"GammaOut", nil];
    if (!baseLut){
        DMBaseLutGenerator *myBL=[[DMBaseLutGenerator alloc]init];
        baseLut = [myBL generateLut];
    }
    NSMutableString *lutFileOut=[[NSMutableString alloc] initWithString: @"0 64 128 192 256 320 384 448 512 576 640 704 768 832 896 960 1023\n"];
    NSArray *lutToExport=[mySorter sortLut:[myFilter getLutFilteredForValueSet:setOfvalues ofLutSize:17 byMatrix:theMatrix withBaseLut:baseLut] fastest:@"rIndex" faster:@"gIndex"];
        for (int i=0; i<([lutToExport count]-1); i++) {
        NSString *rValue=[NSString stringWithFormat:@"%d",(int)([[[lutToExport objectAtIndex:i]valueForKey:@"r"]floatValue]*1023)];
        NSString *gValue=[NSString stringWithFormat:@"%d",(int)([[[lutToExport objectAtIndex:i]valueForKey:@"g"]floatValue]*1023)];
        NSString *bValue=[NSString stringWithFormat:@"%d",(int)([[[lutToExport objectAtIndex:i]valueForKey:@"b"]floatValue]*1023)];
        [lutFileOut appendString:[NSString stringWithFormat:@"%@ %@ %@\n",rValue,gValue,bValue]];
    }
    
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setMessage:@"Please select a path where to save the LUT"]; // Message inside modal window
    
    [panel setDirectoryURL:[NSURL fileURLWithPath:documentFolderPath]];
    
    [panel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"3dl",nil]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setTitle:@"Exporting LUT for Lustre..."]; // Window title
    
    NSInteger result = [panel runModal];
    NSError *error = nil;
    
    if (result == NSOKButton) {
        ////////////////////////////////////////////
        if (![[[panel URL]path]pathExtension]){
            NSString *path = [[[panel URL] path]stringByAppendingString:@".3dl"];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        else{
            NSString *path = [[panel URL] path];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        }
        if (error) {
            [NSApp presentError:error];
        }
    }
    
    
}
- (IBAction)exportLutForResolve:(id)sender {
    DMCalcFilter *myFilter=[[DMCalcFilter alloc]init];
    DMGenerateLutFromCube *mySorter=[[DMGenerateLutFromCube alloc]init];
    NSDictionary* setOfvalues =[[NSDictionary alloc]initWithObjectsAndKeys:[self.offsetRSlider stringValue],@"offsetR",[self.offsetGSlider stringValue],@"offsetG",[self.offsetBSlider stringValue],@"offsetB",[self.slopeRSlider stringValue],@"slopeR",[self.slopeGSlider stringValue],@"slopeG",[self.slopeBSlider stringValue],@"slopeB",[self.powRSlider stringValue],@"powR",[self.powGSlider stringValue],@"powG",[self.powBSlider stringValue],@"powB", nil];
    NSDictionary* theMatrix= [[NSDictionary alloc] initWithObjectsAndKeys:self.R1.stringValue,@"R1",self.G1.stringValue,@"G1",self.B1.stringValue,@"B1",self.R2.stringValue,@"R2",self.G2.stringValue,@"G2",self.B2.stringValue,@"B2",self.R3.stringValue,@"R3",self.G3.stringValue,@"G3",self.B3.stringValue,@"B3",self.GammaIn.stringValue,@"GammaIn",self.GammaOut.stringValue,@"GammaOut", nil];
    if (!baseLut){
        DMBaseLutGenerator *myBL=[[DMBaseLutGenerator alloc]init];
        baseLut = [myBL generateLut];
    }
    NSMutableString *lutFileOut=[[NSMutableString alloc] initWithString: @"LUT_3D_SIZE 17\n"];
    NSArray *lutToExport=[mySorter sortLut:[myFilter getLutFilteredForValueSet:setOfvalues ofLutSize:17 byMatrix:theMatrix withBaseLut:baseLut] fastest:@"rIndex" faster:@"gIndex"];
    for (int i=0; i<([lutToExport count]-1); i++) {
        NSString *rValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"r"]floatValue])];
        NSString *gValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"g"]floatValue])];
        NSString *bValue=[NSString stringWithFormat:@"%f",([[[lutToExport objectAtIndex:i]valueForKey:@"b"]floatValue])];
        [lutFileOut appendString:[NSString stringWithFormat:@"%@ %@ %@\n",rValue,gValue,bValue]];
    }
    
    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setMessage:@"Please select a path where to save the LUT"]; // Message inside modal window
    
    [panel setDirectoryURL:[NSURL fileURLWithPath:documentFolderPath]];
    
    [panel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"cube",nil]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setTitle:@"Exporting LUT for Resolve..."]; // Window title
    
    NSInteger result = [panel runModal];
    NSError *error = nil;
    
    if (result == NSOKButton) {
        ////////////////////////////////////////////
        if (![[[panel URL]path]pathExtension]){
            NSString *path = [[[panel URL] path]stringByAppendingString:@".cube"];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        else{
            NSString *path = [[panel URL] path];
            [lutFileOut writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
        }
        if (error) {
            [NSApp presentError:error];
        }
    }
    
    
}
- (IBAction)loadImage:(id)sender {
    
	NSOpenPanel *openPanel =[NSOpenPanel openPanel];
	[openPanel setTitle:@"scegli la directory"];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	if ([openPanel runModal]==NSOKButton)
	{
		filePath = [[openPanel URL] path];
	}
    NSImage* nsImage = [[NSImage alloc ]initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    if (nsImage) {
        [self.monitor setImage:nsImage];
        DMHistogramGenerator *myHisto=[[DMHistogramGenerator alloc]init];
        [self.histoWindow setImage:[myHisto generateHistogramForImage:nsImage]];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Error loading image"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        filePath=@"/Users/dariomarzeglia/Dropbox/Objective-c_proj/PLCDL_LUTGEN/PLCDL_LUTGEN/marci512_Cineon.jpg";
    }
    
}
- (IBAction)lutSize:(id)sender {
    NSPopUpButton *btn = (NSPopUpButton*)sender;
    
    if ([btn indexOfSelectedItem]==0) lutSize=17;
    if ([btn indexOfSelectedItem]==1) lutSize=33;
    
   
    
}


- (IBAction)RgbP3ToXYZ:(id)sender {
    [self.R1 setStringValue:@"0.7161046"];
    [self.G1 setStringValue:@"0.1009296"];
    [self.B1 setStringValue:@"0.1471858"];
    [self.R2 setStringValue:@"0.2581874"];
    [self.G2 setStringValue:@"0.7249378"];
    [self.B2 setStringValue:@"0.0168748"];
    [self.R3 setStringValue:@"0.0000000"];
    [self.G3 setStringValue:@"0.0517813"];
    [self.B3 setStringValue:@"0.7734287"];
    
}

- (IBAction)Rec709ToXYZ:(id)sender {
    [self.R1 setStringValue:@"0.4163290"];
    [self.G1 setStringValue:@"0.3931464"];
    [self.B1 setStringValue:@"0.1547446"];
    [self.R2 setStringValue:@"0.2216999"];
    [self.G2 setStringValue:@"0.7032549"];
    [self.B2 setStringValue:@"0.0750452"];
    [self.R3 setStringValue:@"0.0136576"];
    [self.G3 setStringValue:@"0.0136576"];
    [self.B3 setStringValue:@"0.7201920"];
}

- (IBAction)XYZToRec709:(id)sender {
    [self.R1 setStringValue:@"3.3921940"];
    [self.G1 setStringValue:@"-1.8264027"];
    [self.B1 setStringValue:@"-0.5385522"];
    [self.R2 setStringValue:@"-1.0770996"];
    [self.G2 setStringValue:@"2.0213975"];
    [self.B2 setStringValue:@"0.0207989"];
    [self.R3 setStringValue:@"0.0723073"];
    [self.G3 setStringValue:@"-0.2217902"];
    [self.B3 setStringValue:@"1.3960932"];
}

- (IBAction)generateLutFromCube:(id)sender {
    NSURL *cubeFileURL;
    NSOpenPanel *openPanel =[NSOpenPanel openPanel];
	[openPanel setTitle:@"Load CUBE"];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	if ([openPanel runModal]==NSOKButton)
	{
		cubeFileURL = [openPanel URL];
	}
    DMGenerateLutFromCube *myLutFromCube=[[DMGenerateLutFromCube alloc]init];
    baseLut=[myLutFromCube lutFromCube:cubeFileURL];
    [self sliderDidMove:self];

   
}
@end

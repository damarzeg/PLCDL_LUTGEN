//
//  DMHistogramGenerator.m
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 19/05/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import "DMHistogramGenerator.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMHistogramGenerator


-(NSImage*) generateHistogramForImage: (NSImage*)theImage
{
    NSData  * tiffData = [theImage TIFFRepresentation];
    NSBitmapImageRep * bitmap;
    bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    CIImage * ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    CGRect myRect= [ciImage extent];
    
    CIFilter  *histoAreaFilter = [CIFilter filterWithName:@"CIAreaHistogram"];
   // NSImageRep *theImageRep=[[theImage representations]objectAtIndex:0];
    [histoAreaFilter setDefaults];
    [histoAreaFilter setValue:ciImage forKey:kCIInputImageKey];
    [histoAreaFilter setValue:@768 forKey:@"inputCount"];
    [histoAreaFilter setValue:@100 forKey:@"inputScale"];
    CIVector *extentAsVector = [CIVector vectorWithX:CGRectGetMinX(myRect)
                                                   Y:CGRectGetMinY(myRect)
                                                   Z:CGRectGetWidth(myRect)
                                                   W:CGRectGetHeight(myRect)];
    [histoAreaFilter setValue:extentAsVector forKey:@"inputExtent"];
    CIImage *result = [histoAreaFilter valueForKeyPath:kCIOutputImageKey];
    CIFilter *histoDisplay =[CIFilter filterWithName:@"CIHistogramDisplayFilter"];
    [histoDisplay setDefaults];
    //[histoDisplay setValue:@200 forKey:@"inputHeight"];
    [histoDisplay setValue:@1 forKey:@"inputHighLimit"];
    [histoDisplay setValue:result forKeyPath:kCIInputImageKey];
    CIImage *theHistoCI=[histoDisplay valueForKey:kCIOutputImageKey];
    NSCIImageRep *theHistoRep = [NSCIImageRep imageRepWithCIImage:theHistoCI];
    //theHisto = [[NSImage alloc] initWithSize:theHistoRep.size];
    theHisto = [[NSImage alloc] initWithSize:CGSizeMake(412.0, 283.0)];
    [theHisto addRepresentation:theHistoRep];
    return theHisto;
}
@end

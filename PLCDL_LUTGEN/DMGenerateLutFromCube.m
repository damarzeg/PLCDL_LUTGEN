//
//  DMGenerateLutFromCube.m
//  LutFromCubeImg
//
//  Created by Dario Marzeglia on 10/06/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import "DMGenerateLutFromCube.h"

@implementation DMGenerateLutFromCube

-(NSArray*)lutFromCube:(NSURL*)theUrl{
    NSMutableArray *theLut=[[NSMutableArray alloc]init];
      //header del file x After
    /*WithString:@"# created by alexalutconv (2.09)\n# Alexa conversion LUT, logc2video. Legal in/legal out.\n0 64 128 192 256 320 384 448 512 576 640 704 768 832 896 960 1023\n"];*/
    NSImage *nsImage=[[NSImage alloc]initByReferencingURL:theUrl];
    if (!nsImage) return nil;
    NSData * imageData = [nsImage TIFFRepresentation];
    CGImageRef imageRef;
    if(!imageData) return nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(imageData), NULL);
    imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    for (int y=108; y<978; y+=18) {
        for (int x=51; x<1877; x+=18) {
            if (y==972 && x>346) break;
            NSColor *color = [bitmap colorAtX:x y:y];
            [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
            CGFloat redFloatValue, greenFloatValue, blueFloatValue;
            [color getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
            NSNumber *red=@(redFloatValue);
            NSNumber *green =@(greenFloatValue);
            NSNumber *blue=@(blueFloatValue);
            NSDictionary *lutLine=[[NSDictionary alloc] initWithObjectsAndKeys:red,@"r",green,@"g",blue,@"b", nil];
            [theLut addObject:lutLine];
            
            
        }
    }
    /*NSSortDescriptor *fastest = [[NSSortDescriptor alloc] initWithKey:@"b" ascending:YES];
    NSSortDescriptor *seconndFastest = [[NSSortDescriptor alloc] initWithKey:@"g" ascending:YES];
    NSArray *sortDescriptors = @[fastest,seconndFastest];
    [theLut sortUsingDescriptors:sortDescriptors];*/
    
    return [self sortLut:theLut];
    
}
-(NSArray*)sortLut:(NSArray*)inLut
{
    NSMutableArray *arrayWithIndex=[[NSMutableArray alloc]init];
    int rIndex=1,gIndex=1,bIndex=1;
    for(int i=0; i<([inLut count]-1);i++){
        if (bIndex==18){
            bIndex = 1;
            gIndex++;
            if (gIndex==18) {
                gIndex=1;
                rIndex++;
            }
        }
        bIndex++;
        NSNumber *rIndx=@(rIndex);
        NSNumber *gIndx=@(gIndex);
        NSNumber *bIndx=@(bIndex);
        NSDictionary *lutWithIndex=[[NSDictionary alloc]initWithObjectsAndKeys:[[inLut objectAtIndex:i]valueForKey:@"r"],@"r",rIndx,@"rIndex",[[inLut objectAtIndex:i]valueForKey:@"g"],@"g",gIndx,@"gIndex",[[inLut objectAtIndex:i]valueForKey:@"b"],@"b",bIndx,@"bIndex", nil];
        [arrayWithIndex addObject:lutWithIndex];
        
    
    }

    NSSortDescriptor *fastest = [[NSSortDescriptor alloc] initWithKey:@"bIndex" ascending:YES];
    NSSortDescriptor *seconndFastest = [[NSSortDescriptor alloc] initWithKey:@"gIndex" ascending:YES];
    NSArray *sortDescriptors = @[fastest,seconndFastest];
    [arrayWithIndex sortUsingDescriptors:sortDescriptors];
    return arrayWithIndex;

}
-(NSArray*)sortLut:(NSArray*)inLut fastest:(NSString*)fastestIndex faster:(NSString*)fasterIndex
{
    NSMutableArray *arrayWithIndex=[[NSMutableArray alloc]init];
    int rIndex=1,gIndex=1,bIndex=1;
    for(int i=0; i<([inLut count]-1);i++){
        if (bIndex==18){
            bIndex = 1;
            gIndex++;
            if (gIndex==18) {
                gIndex=1;
                rIndex++;
            }
        }
        bIndex++;
        NSNumber *rIndx=@(rIndex);
        NSNumber *gIndx=@(gIndex);
        NSNumber *bIndx=@(bIndex);
        NSDictionary *lutLineWithIndex=[[NSDictionary alloc]initWithObjectsAndKeys:[[inLut objectAtIndex:i]valueForKey:@"r"],@"r",rIndx,@"rIndex",[[inLut objectAtIndex:i]valueForKey:@"g"],@"g",gIndx,@"gIndex",[[inLut objectAtIndex:i]valueForKey:@"b"],@"b",bIndx,@"bIndex", nil];
        [arrayWithIndex addObject:lutLineWithIndex];
      
        
        
    }
    NSSortDescriptor *fastest = [[NSSortDescriptor alloc] initWithKey:fastestIndex ascending:YES];
    NSSortDescriptor *seconndFastest = [[NSSortDescriptor alloc] initWithKey:fasterIndex ascending:YES];
    NSArray *sortDescriptors = @[fastest,seconndFastest];
    [arrayWithIndex sortUsingDescriptors:sortDescriptors];
    return arrayWithIndex;
    
}
@end

//
//  DMCalcFilter.m
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 17/04/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import "DMCalcFilter.h"
#import <QuartzCore/QuartzCore.h>


@implementation DMCalcFilter
-(id)init

{

    self=[super init];
    if (self)theLut=[[NSMutableArray alloc]init];
    return self;
}

-(NSImage*)getImageFiltered :(NSURL*)theImage forValueSet:(NSDictionary*) setOfValues ofLutSize:(int)lutSize byMatrix:(NSDictionary*) theMatrix withBaseLut:(NSArray*)myLut;
{

    CIImage * ciImage = [CIImage imageWithContentsOfURL:theImage];
    // Allocate memory
    
    const unsigned int size = lutSize;
    float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
    float *c = cubeData;
    size_t cubeDataSize = size * size * size * sizeof ( float ) * 4;
    // Create memory with the cube data
    float offsetR=[[setOfValues valueForKey:@"offsetR"]floatValue];
    float slopeR=[[setOfValues valueForKey:@"slopeR"]floatValue];
    float powR=[[setOfValues valueForKey:@"powR"]floatValue];
    float offsetG=[[setOfValues valueForKey:@"offsetG"]floatValue];
    float slopeG=[[setOfValues valueForKey:@"slopeG"]floatValue];
    float powG=[[setOfValues valueForKey:@"powG"]floatValue];
    float offsetB=[[setOfValues valueForKey:@"offsetB"]floatValue];
    float slopeB=[[setOfValues valueForKey:@"slopeB"]floatValue];
    float powB=[[setOfValues valueForKey:@"powB"]floatValue];
   
    float r1 = [[theMatrix objectForKey:@"R1"] floatValue];
    float g1 = [[theMatrix objectForKey:@"G1"] floatValue];
    float b1 = [[theMatrix objectForKey:@"B1"] floatValue];
    float r2 = [[theMatrix objectForKey:@"R2"] floatValue];
    float g2 = [[theMatrix objectForKey:@"G2"] floatValue];
    float b2 = [[theMatrix objectForKey:@"B2"] floatValue];
    float r3 = [[theMatrix objectForKey:@"R3"] floatValue];
    float g3 = [[theMatrix objectForKey:@"G3"] floatValue];
    float b3 = [[theMatrix objectForKey:@"B3"] floatValue];
    float gIn = [[theMatrix objectForKey:@"GammaIn"] floatValue];
    float gOut = [[theMatrix objectForKey:@"GammaOut"] floatValue];

    //NSArray *myLut=[self generateLutWith];
    for (int x = 0; x < ([myLut count]-1); x ++){
                float valA=pow(([[[myLut objectAtIndex:x]objectForKey:@"r"]floatValue] )*slopeR+offsetR,powR);
                if(isnan(valA)) valA=0;
                else if(valA<0) valA=0;
                else if(valA>1) valA=1;
                //c[0] = rgb[0];
                float valB=pow(([[[myLut objectAtIndex:x]objectForKey:@"g"]floatValue])*slopeG+offsetG,powG);
                if(isnan(valB)) valB=0;
                else if(valB<0) valB=0;
                else if(valB>1) valB=1;
                //c[1] = rgb[1];
                float valC=pow(([[[myLut objectAtIndex:x]objectForKey:@"b"]floatValue])*slopeB+offsetB,powB);
                if(isnan(valC)) valC=0;
                else if(valC<0) valC=0;
                else if(valC>1) valC=1;
                valA=pow((pow(valA,gIn)),(1.0f/gOut));
                valB=pow((pow(valB,gIn)),(1.0f/gOut));
                valC=pow((pow(valC,gIn)),(1.0f/gOut));
                //c[2] = rgb[2];
                c[0]=(valA*r1)+(valB*g1)+(valC*b1);
                c[1]=(valA*r2)+(valB*g2)+(valC*b2);
                c[2]=(valA*r3)+(valB*g3)+(valC*b3);
        //c[0]=pow(((pow(valA,gIn)*r1)+(pow(valB,gIn)*g1)+(pow(valC,gIn)*b1)),(1.0f/gOut));
        //c[1]=pow(((pow(valA,gIn)*r2)+(pow(valB,gIn)*g2)+(pow(valC,gIn)*b2)),(1.0f/gOut));
        //c[2]=pow(((pow(valA,gIn)*r3)+(pow(valB,gIn)*g3)+(pow(valC,gIn)*b3)),(1.0f/gOut));
                c[3] = 1.0f;
                c += 4;
                // advance our pointer into memory for the next color value
    }

    
    /*for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                float valA=pow((rgb[0])*slopeR+offsetR,powR);
                if(isnan(valA)) valA=0;
                else if(valA<0) valA=0;
                else if(valA>1) valA=1;
                //c[0] = rgb[0];
                float valB=pow((rgb[1])*slopeG+offsetG,powG);
                if(isnan(valB)) valB=0;
                else if(valB<0) valB=0;
                else if(valB>1) valB=1;
                //c[1] = rgb[1];
                float valC=pow((rgb[2])*slopeB+offsetB,powB);
                if(isnan(valC)) valC=0;
                else if(valC<0) valC=0;
                else if(valC>1) valC=1;
                //c[2] = rgb[2];
                c[0]=(valA*r1)+(valB*g1)+(valC*b1);
                c[1]=(valA*r2)+(valB*g2)+(valC*b2);
                c[2]=(valA*r3)+(valB*g3)+(valC*b3);
                c[3] = 1.0f;
                c += 4;
                // advance our pointer into memory for the next color value
            }
        }
    }*/
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    /*if(cubeData){
        for (int i=0;i<=(((size*size*size*sizeof(float)))-1);i++){
            NSDictionary *rgbaValues=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",cubeData[i]],@"R",[NSString stringWithFormat:@"%f",cubeData[i+1]],@"G",[NSString stringWithFormat:@"%f",cubeData[i+2]],@"B",[NSString stringWithFormat:@"%f",cubeData[i+3]],@"A", nil];
            [theLut addObject:rgbaValues];
            
            i+=3;
        }
    }*/

    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    // Set data for cube
    [colorCube setValue:data forKey:@"inputCubeData"];
    [colorCube setValue:ciImage forKey:kCIInputImageKey];
     CIImage *result = [colorCube valueForKey: kCIOutputImageKey];
     NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:result];
     NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
     [nsImage addRepresentation:rep];
    return nsImage;
    
}
- (NSString*)exportCurrentLutToClipster
{
    NSMutableString* clipLut=[[NSMutableString alloc]initWithString:@"\n<LUT3D name='null_dvxlut.xml' N='17' BitDepth='16'>\n    <values>\n"];

    NSSortDescriptor *fastest = [[NSSortDescriptor alloc] initWithKey:@"R" ascending:YES];
    NSSortDescriptor *seconndFastest = [[NSSortDescriptor alloc] initWithKey:@"G" ascending:YES];
    NSArray *sortDescriptors = @[fastest, seconndFastest];
    NSArray *sortedArray = [theLut sortedArrayUsingDescriptors:sortDescriptors];
    for(int i=0;i<[sortedArray count];i+=1)
    {
        NSString* rValue=[NSString stringWithFormat:@"%@",[[sortedArray objectAtIndex:i]objectForKey:@"R"]];
        [clipLut appendString:[NSString stringWithFormat:@"%.0f",[rValue floatValue]*65535]];
        [clipLut appendString:@"       "];
        NSString* gValue=[NSString stringWithFormat:@"%@",[[sortedArray objectAtIndex:i]objectForKey:@"G"]];
        [clipLut appendString:[NSString stringWithFormat:@"%.0f",[gValue floatValue]*65535]];
        [clipLut appendString:@"       "];
         NSString* bValue=[NSString stringWithFormat:@"%@",[[sortedArray objectAtIndex:i]objectForKey:@"B"]];
        [clipLut appendString:[NSString stringWithFormat:@"%.0f",[bValue floatValue]*65535]];
        [clipLut appendString:@"\n"];
    }
    [clipLut appendString:@"    </values>\n</LUT3D>"];
    NSString *stringToReturn = [NSString stringWithString:clipLut];
    return stringToReturn;
}
-(NSImage*) applyLut:(NSArray*)lutToApply toImage:(NSURL*)imageURL
{
    
    CIImage * ciImage = [CIImage imageWithContentsOfURL:imageURL];
    // Allocate memory
    
    const unsigned int size = 17;
    float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
    float  *c = cubeData;
    for (int h=0; h<[lutToApply count]; h++) {
        c[0]= [[[lutToApply objectAtIndex:h] valueForKey:@"r"]floatValue];
        c[1]= [[[lutToApply objectAtIndex:h] valueForKey:@"g"]floatValue];
        c[2]= [[[lutToApply objectAtIndex:h] valueForKey:@"b"]floatValue];
        c[3] = 1.0f;
        c += 4;
    }
    size_t cubeDataSize = size * size * size * sizeof ( float ) * 4;
    // Create memory with the cube data
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    // Set data for cube
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    [colorCube setValue:data forKey:@"inputCubeData"];
    [colorCube setValue:ciImage forKey:kCIInputImageKey];
    CIImage *result = [colorCube valueForKey: kCIOutputImageKey];
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:result];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
}
-(NSArray*) generateLutWith
{
    float rgb[3];
    const unsigned int size=17;
    NSMutableArray *linLut=[[NSMutableArray alloc]init];
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1);
                NSNumber *r=@(rgb[0]);
                NSNumber *g=@(rgb[1]);
                NSNumber *b=@(rgb[2]);
                NSDictionary *theDic=[[NSDictionary alloc]initWithObjectsAndKeys:b,@"b",g,@"g",r,@"r",nil];
                [linLut addObject:theDic];
            }
        }
    }
    return [NSArray arrayWithArray:linLut];
}
-(NSArray*)getLutFilteredForValueSet:(NSDictionary*) setOfValues ofLutSize:(int)lutSize byMatrix:(NSDictionary*) theMatrix withBaseLut:(NSArray*)myLut
{
    // Create memory with the cube data
    NSMutableArray *newLut=[[NSMutableArray alloc]initWithCapacity:0];
    float offsetR=[[setOfValues valueForKey:@"offsetR"]floatValue];
    float slopeR=[[setOfValues valueForKey:@"slopeR"]floatValue];
    float powR=[[setOfValues valueForKey:@"powR"]floatValue];
    float offsetG=[[setOfValues valueForKey:@"offsetG"]floatValue];
    float slopeG=[[setOfValues valueForKey:@"slopeG"]floatValue];
    float powG=[[setOfValues valueForKey:@"powG"]floatValue];
    float offsetB=[[setOfValues valueForKey:@"offsetB"]floatValue];
    float slopeB=[[setOfValues valueForKey:@"slopeB"]floatValue];
    float powB=[[setOfValues valueForKey:@"powB"]floatValue];
    
    float r1 = [[theMatrix objectForKey:@"R1"] floatValue];
    float g1 = [[theMatrix objectForKey:@"G1"] floatValue];
    float b1 = [[theMatrix objectForKey:@"B1"] floatValue];
    float r2 = [[theMatrix objectForKey:@"R2"] floatValue];
    float g2 = [[theMatrix objectForKey:@"G2"] floatValue];
    float b2 = [[theMatrix objectForKey:@"B2"] floatValue];
    float r3 = [[theMatrix objectForKey:@"R3"] floatValue];
    float g3 = [[theMatrix objectForKey:@"G3"] floatValue];
    float b3 = [[theMatrix objectForKey:@"B3"] floatValue];
    float gIn = [[theMatrix objectForKey:@"GammaIn"] floatValue];
    float gOut = [[theMatrix objectForKey:@"GammaOut"] floatValue];
    //NSArray *myLut=[self generateLutWith];
    for (int x = 0; x < ([myLut count]-1); x ++){
        float valA=pow(([[[myLut objectAtIndex:x]objectForKey:@"r"]floatValue] )*slopeR+offsetR,powR);
        if(isnan(valA)) valA=0;
        else if(valA<0) valA=0;
        else if(valA>1) valA=1;
        //c[0] = rgb[0];
        float valB=pow(([[[myLut objectAtIndex:x]objectForKey:@"g"]floatValue])*slopeG+offsetG,powG);
        if(isnan(valB)) valB=0;
        else if(valB<0) valB=0;
        else if(valB>1) valB=1;
        //c[1] = rgb[1];
        float valC=pow(([[[myLut objectAtIndex:x]objectForKey:@"b"]floatValue])*slopeB+offsetB,powB);
        if(isnan(valC)) valC=0;
        else if(valC<0) valC=0;
        else if(valC>1) valC=1;
        //c[2] = rgb[2];
        /*
         c[0]=(valA*r1)+(valB*g1)+(valC*b1);
         c[1]=(valA*r2)+(valB*g2)+(valC*b2);
         c[2]=(valA*r3)+(valB*g3)+(valC*b3);
         */
        valA=pow((pow(valA,gIn)),(1.0f/gOut));
        valB=pow((pow(valB,gIn)),(1.0f/gOut));
        valC=pow((pow(valC,gIn)),(1.0f/gOut));
        /*
        NSNumber *rValue=@(pow(((pow(valA,gIn)*r1)+(pow(valB,gIn)*g1)+(pow(valC,gIn)*b1)),(1.0f/gOut)));
        NSNumber *gValue=@(pow(((pow(valA,gIn)*r2)+(pow(valB,gIn)*g2)+(pow(valC,gIn)*b2)),(1.0f/gOut)));
        NSNumber *bValue=@(pow(((pow(valA,gIn)*r3)+(pow(valB,gIn)*g3)+(pow(valC,gIn)*b3)),(1.0f/gOut)));
       */
        NSNumber *rValue=@((valA*r1)+(valB*g1)+(valC*b1));
        NSNumber *gValue=@((valA*r2)+(valB*g2)+(valC*b2));
        NSNumber *bValue=@((valA*r3)+(valB*g3)+(valC*b3));
        NSNumber *rIndex=[[myLut objectAtIndex:x]valueForKey:@"rIndex"];
        NSNumber *gIndex=[[myLut objectAtIndex:x]valueForKey:@"gIndex"];
        NSNumber *bIndex=[[myLut objectAtIndex:x]valueForKey:@"bIndex"];
        NSDictionary *newLutLine= @{@"r":rValue,@"g":gValue,@"b":bValue,@"rIndex":rIndex,@"bIndex":bIndex,@"gIndex":gIndex};
        [newLut addObject:newLutLine];
    }
    return newLut;
}
@end


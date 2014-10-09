//
//  DMBaseLutGenerator.m
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 02/07/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import "DMBaseLutGenerator.h"

@implementation DMBaseLutGenerator
-(NSArray*) generateLut
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
                NSDictionary *theDic=[[NSDictionary alloc]initWithObjectsAndKeys:b,@"b",g,@"g",r,@"r",[NSNumber numberWithInt:z],@"bIndex",[NSNumber numberWithInt:y],@"gIndex",[NSNumber numberWithInt:x],@"rIndex",nil];
                [linLut addObject:theDic];
            }
        }
    }
    return [NSArray arrayWithArray:linLut];
}

@end

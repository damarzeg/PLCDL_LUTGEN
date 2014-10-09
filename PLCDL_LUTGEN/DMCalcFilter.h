//
//  DMCalcFilter.h
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 17/04/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCalcFilter : NSObject
{
    NSArray *rawData;
    NSMutableArray *theLut;
}
//-(NSImage*)getImageFiltered :(NSURL*)theImage forValueR:(double)valueR forValueG:(double)valueG forValueB:(double)valueB ofLutTye:(NSInteger)lutType;
-(NSImage*)getImageFiltered :(NSURL*)theImage forValueSet:(NSDictionary*) setOfValues ofLutSize:(int)lutSize byMatrix:(NSDictionary*) theMatrix withBaseLut:(NSArray*)myLut;
-(NSArray*)getLutFilteredForValueSet:(NSDictionary*) setOfValues ofLutSize:(int)lutSize byMatrix:(NSDictionary*) theMatrix withBaseLut:(NSArray*)myLut;
- (NSString*)exportCurrentLutToClipster;
-(NSImage*) applyLut:(NSArray*)theLut toImage:(NSURL*)imageURL;
-(NSArray*) generateLutWith;

@end

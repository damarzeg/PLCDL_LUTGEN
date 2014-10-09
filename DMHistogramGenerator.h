//
//  DMHistogramGenerator.h
//  PLCDL_LUTGEN
//
//  Created by Dario Marzeglia on 19/05/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHistogramGenerator : NSObject{
    NSImage* theHisto;
}

-(NSImage*) generateHistogramForImage: (NSImage*)theImage;

@end



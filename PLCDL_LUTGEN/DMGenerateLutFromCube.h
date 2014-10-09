//
//  DMGenerateLutFromCube.h
//  LutFromCubeImg
//
//  Created by Dario Marzeglia on 10/06/14.
//  Copyright (c) 2014 Dario Marzeglia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMGenerateLutFromCube : NSObject


-(NSArray*)lutFromCube:(NSURL*)theUrl;
-(NSArray*)sortLut:(NSArray*)inLut;
-(NSArray*)sortLut:(NSArray*)inLut fastest:(NSString*)fastestIndex faster:(NSString*)fasterIndex;
@end

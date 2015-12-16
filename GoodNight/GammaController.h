//
//  GammaController.h
//  GoodNight
//
//  Created by Anthony Agatiello on 6/22/15.
//  Copyright © 2015 ADA Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, TimeBasedAction) {
    SwitchToOrangeness,
    SwitchToStandard,
    KeepOrangenessEnabled,
    KeepStandardEnabled
};

@interface GammaController : NSObject

+ (void)autoChangeOrangenessIfNeededWithTransition:(BOOL)transition;
+ (void)enableOrangenessWithDefaults:(BOOL)defaults transition:(BOOL)transition;
+ (void)setGammaWithTransitionFrom:(float)oldPercentOrange to:(float)newPercentOrange;
+ (void)disableGammaWithTransition:(BOOL)transition;
+ (void)enableDimness;
+ (void)setGammaWithCustomValues;
+ (void)suspendApp;
+ (void)disableColorAdjustment;
+ (void)disableDimness;
+ (void)disableOrangeness;
+ (TimeBasedAction)timeBasedActionForPrefix:(NSString*)autoOrNightPrefix;
+ (TimeBasedAction)timeBasedActionForLocationWithNewOrangeLevel:(float*)newOrangeLevel;
+ (void)setDarkroomEnabled:(BOOL)enable;
+ (BOOL)adjustmentForKeysEnabled:(NSString *)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

@end
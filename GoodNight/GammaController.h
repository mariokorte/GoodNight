//
//  GammaController.h
//  GoodNight
//
//  Created by Anthony Agatiello on 6/22/15.
//  Copyright © 2015 ADA Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct __IOMobileFramebuffer *IOMobileFramebufferConnection;
typedef kern_return_t IOMobileFramebufferReturn, SpringBoardServicesReturn;

#define IOMFB_PATH "/System/Library/PrivateFrameworks/IOMobileFramebuffer.framework/IOMobileFramebuffer"
#define SBS_PATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"

typedef NS_ENUM(NSInteger, TimeBasedAction) {
    SwitchToOrangeness,
    SwitchToStandard,
    KeepOrangenessEnabled,
    KeepStandardEnabled
};

typedef NS_ENUM(NSInteger, IOMobileFramebufferColorRemapMode) {
    IOMobileFramebufferColorRemapModeNormal = 0,
    IOMobileFramebufferColorRemapModeInverted = 1,
    IOMobileFramebufferColorRemapModeGrayscale = 2,
    IOMobileFramebufferColorRemapModeGrayscaleIncreaseContrast = 3,
    IOMobileFramebufferColorRemapModeInvertedGrayscale = 4
};

static IOMobileFramebufferConnection _framebufferConnection = NULL;

@interface GammaController : NSObject <UIAlertViewDelegate>

+ (void)autoChangeOrangenessIfNeededWithTransition:(BOOL)transition;
+ (void)enableOrangenessWithDefaults:(BOOL)defaults transition:(BOOL)transition;
+ (void)setGammaWithTransitionFrom:(float)oldPercentOrange to:(float)newPercentOrange;
+ (void)disableOrangenessWithDefaults:(BOOL)defaults key:(NSString *)key transition:(BOOL)transition;
+ (void)enableDimness;
+ (void)setGammaWithCustomValues;
+ (void)suspendApp;
+ (void)disableColorAdjustment;
+ (void)disableDimness;
+ (void)disableOrangeness;
+ (TimeBasedAction)timeBasedActionForPrefix:(NSString*)autoOrNightPrefix;
+ (TimeBasedAction)timeBasedActionForLocationWithNewOrangeLevel:(float*)newOrangeLevel;
+ (void)checkCompatibility;
+ (void)setDarkroomEnabled:(BOOL)enable;

@end
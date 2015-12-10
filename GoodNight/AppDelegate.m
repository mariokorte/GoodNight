//
//  AppDelegate.m
//  GoodNight
//
//  Created by Anthony Agatiello on 6/22/15.
//  Copyright © 2015 ADA Tech, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GammaController.h"
#import "ForceTouchController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    [groupDefaults registerDefaults:appDefaults];
    
    [GammaController autoChangeOrangenessIfNeededWithTransition:NO];
    [self registerForNotifications];
    [AppDelegate updateNotifications];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0") && self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
        [ForceTouchController sharedForceTouchController];
    }
    
    if (application.applicationState == UIApplicationStateBackground) {
        [self installBackgroundTask:application];
    }
    
    [ForceTouchController sharedForceTouchController];
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    BOOL handledShortcutItem = [ForceTouchController handleShortcutItem:shortcutItem];
    [ForceTouchController exitIfKeyEnabled];
    completionHandler(handledShortcutItem);
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [groupDefaults setObject:[NSDate date] forKey:@"lastBackgroundCheck"];
    [groupDefaults synchronize];
    [GammaController autoChangeOrangenessIfNeededWithTransition:YES];
    [NSThread sleepForTimeInterval:5.0];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)registerForNotifications {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [app registerUserNotificationSettings:settings];
}

+ (void)updateNotifications {
    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    [app cancelAllLocalNotifications];
    
    if ([groupDefaults boolForKey:@"colorChangingEnabled"]){
        
        UILocalNotification *enableNotification = [[UILocalNotification alloc] init];
        
        if (enableNotification == nil) {
            return;
        }
        
        NSDateComponents *compsForEnable = [[NSDateComponents alloc] init];
        [compsForEnable setHour:[groupDefaults integerForKey:@"autoStartHour"]];
        [compsForEnable setMinute:[groupDefaults integerForKey:@"autoStartMinute"]];
        [enableNotification setSoundName:UILocalNotificationDefaultSoundName];
        [enableNotification setAlertTitle:bundleName];
        [enableNotification setAlertBody:[NSString stringWithFormat:@"Time to enable %@!", bundleName]];
        [enableNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [enableNotification setFireDate:[[NSCalendar currentCalendar] dateFromComponents:compsForEnable]];
        [enableNotification setRepeatInterval:NSCalendarUnitDay];
        
        UILocalNotification *disableNotification = [[UILocalNotification alloc] init];
        
        if (disableNotification == nil) {
            return;
        }
        
        NSDateComponents *compsForDisable = [[NSDateComponents alloc] init];
        [compsForDisable setHour:[groupDefaults integerForKey:@"autoEndHour"]];
        [compsForDisable setMinute:[groupDefaults integerForKey:@"autoEndMinute"]];
        [disableNotification setSoundName:UILocalNotificationDefaultSoundName];
        [disableNotification setAlertTitle:bundleName];
        [disableNotification setAlertBody:[NSString stringWithFormat:@"Time to disable %@!", bundleName]];
        [disableNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [disableNotification setFireDate:[[NSCalendar currentCalendar] dateFromComponents:compsForDisable]];
        [disableNotification setRepeatInterval:NSCalendarUnitDay];
        
        [app scheduleLocalNotification:enableNotification];
        [app scheduleLocalNotification:disableNotification];
    }
    
    if ([groupDefaults boolForKey:@"colorChangingEnabled"] || [groupDefaults boolForKey:@"colorChangingLocationEnabled"]){
        if ([groupDefaults boolForKey:@"colorChangingNightEnabled"]) {
            
            UILocalNotification *enableNightNotification = [[UILocalNotification alloc] init];
            
            if (enableNightNotification == nil) {
                return;
            }
            
            NSDateComponents *compsForNightEnable = [[NSDateComponents alloc] init];
            [compsForNightEnable setHour:[groupDefaults integerForKey:@"nightStartHour"]];
            [compsForNightEnable setMinute:[groupDefaults integerForKey:@"nightStartMinute"]];
            [enableNightNotification setSoundName:UILocalNotificationDefaultSoundName];
            [enableNightNotification setAlertTitle:bundleName];
            [enableNightNotification setAlertBody:[NSString stringWithFormat:@"Time to enable night mode!"]];
            [enableNightNotification setTimeZone:[NSTimeZone defaultTimeZone]];
            [enableNightNotification setFireDate:[[NSCalendar currentCalendar] dateFromComponents:compsForNightEnable]];
            [enableNightNotification setRepeatInterval:NSCalendarUnitDay];
            
            UILocalNotification *disableNightNotification = [[UILocalNotification alloc] init];
            
            if (disableNightNotification == nil) {
                return;
            }
            
            NSDateComponents *compsForNightDisable = [[NSDateComponents alloc] init];
            [compsForNightDisable setHour:[groupDefaults integerForKey:@"nightEndHour"]];
            [compsForNightDisable setMinute:[groupDefaults integerForKey:@"nightEndMinute"]];
            [disableNightNotification setSoundName:UILocalNotificationDefaultSoundName];
            [disableNightNotification setAlertTitle:bundleName];
            [disableNightNotification setAlertBody:[NSString stringWithFormat:@"Time to disable night mode!"]];
            [disableNightNotification setTimeZone:[NSTimeZone defaultTimeZone]];
            [disableNightNotification setFireDate:[[NSCalendar currentCalendar] dateFromComponents:compsForNightDisable]];
            [disableNightNotification setRepeatInterval:NSCalendarUnitDay];
            
            [app scheduleLocalNotification:enableNightNotification];
            [app scheduleLocalNotification:disableNightNotification];
        }
    }
}

- (BOOL) installBackgroundTask:(UIApplication *)application{
    if (![groupDefaults boolForKey:@"colorChangingEnabled"] && ![groupDefaults boolForKey:@"colorChangingLocationEnabled"]) {
        [application clearKeepAliveTimeout];
        [application setMinimumBackgroundFetchInterval:86400];
        return NO;
    }
    
    [application setMinimumBackgroundFetchInterval:900];
    
    BOOL result = [app setKeepAliveTimeout:600 handler:^{
        [groupDefaults setObject:[NSDate date] forKey:@"lastBackgroundCheck"];
        [groupDefaults synchronize];
        [GammaController autoChangeOrangenessIfNeededWithTransition:YES];
        [NSThread sleepForTimeInterval:5.0];
    }];
    return result;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [GammaController autoChangeOrangenessIfNeededWithTransition:YES];
    [ForceTouchController exitIfKeyEnabled];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id) annotation {
    if ([url.scheme isEqualToString: @"goodnight"]) {
        if ([url.host isEqualToString: @"enable"] && ![groupDefaults boolForKey:@"enabled"]) {
            [GammaController enableOrangenessWithDefaults:YES transition:YES];
            if ([[groupDefaults objectForKey:@"keyEnabled"] isEqualToString:@"0"]) {
                [GammaController suspendApp];
            }
        }
        else if ([url.host isEqualToString: @"disable"] && [groupDefaults boolForKey:@"enabled"]) {
            [GammaController disableOrangeness];
            if ([[groupDefaults objectForKey:@"keyEnabled"] isEqualToString:@"0"]) {
                [GammaController suspendApp];
            }
        }
    }
    return NO;
}

+ (id)initWithIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self installBackgroundTask:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application clearKeepAliveTimeout];
    [GammaController checkCompatibility];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

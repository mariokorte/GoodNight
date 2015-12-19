//
//  WhitePointViewController.m
//  GoodNight
//
//  Created by Anthony Agatiello on 12/18/15.
//  Copyright © 2015 ADA Tech, LLC. All rights reserved.
//

#import "WhitePointViewController.h"
#import "GammaController.h"
#import "AppDelegate.h"

@implementation WhitePointViewController

- (instancetype)init
{
    self = [AppDelegate initWithIdentifier:@"whitepointController"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.whitePointSlider.minimumValue = ((float)[GammaController getMinimumWhitePoint]) / 100000;
    self.whitePointSlider.maximumValue = 0.65535;
    [self updateUI];
}

- (void)updateUI {
    self.whitePointSlider.value = [groupDefaults floatForKey:@"whitePointValue"];
    self.whitePointSwitch.on = [groupDefaults boolForKey:@"whitePointEnabled"];
    
    float brightness = self.whitePointSlider.value;
    
    self.whitePointSwitch.onTintColor = [UIColor colorWithRed:(1.0f-brightness)*0.9f green:((2.0f-brightness)/2.0f)*0.9f blue:0.9f alpha:1.0];
    self.whitePointSlider.tintColor = [UIColor colorWithRed:(1.0f-brightness)*0.9f green:((2.0f-brightness)/2.0f)*0.9f blue:0.9f alpha:1.0];
}

- (IBAction)whitePointSliderChanged {
    [groupDefaults setFloat:self.whitePointSlider.value forKey:@"whitePointValue"];
    
    if (self.whitePointSwitch.on) {
        [GammaController setWhitePoint:[groupDefaults floatForKey:@"whitePointValue"] * 100000];
    }
}

- (IBAction)whitePointSwitchChanged {
    if (![GammaController adjustmentForKeysEnabled:@"enabled", @"rgbEnabled", @"dimEnabled", nil]) {
        [groupDefaults setBool:self.whitePointSwitch.on forKey:@"whitePointEnabled"];
        
        if (self.whitePointSwitch.on) {
            [GammaController setWhitePoint:[groupDefaults floatForKey:@"whitePointValue"] * 100000];
        }
        else {
            [GammaController resetWhitePoint];
        }
    }
    
    else {
        NSString *title = @"Error";
        NSString *message = @"You may only use one adjustment at a time. Please disable any other adjustments before enabling this one.";
        NSString *cancelButton = @"Cancel";
        NSString *disableButton = @"Disable";
        
        if (NSClassFromString(@"UIAlertController") != nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleCancel handler:nil]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:disableButton style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [GammaController disableColorAdjustment];
                [groupDefaults setBool:NO forKey:@"enabled"];
                [groupDefaults setBool:NO forKey:@"rgbEnabled"];
                [groupDefaults setBool:NO forKey:@"dimEnabled"];
                [groupDefaults setBool:YES forKey:@"whitePointEnabled"];
                [self.whitePointSwitch setOn:YES animated:YES];
                [self whitePointSwitchChanged];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButton otherButtonTitles:nil];
            
            [alertView show];
        }
    }
    
    [self updateUI];
}

- (IBAction)whitePointValueReset {
    self.whitePointSlider.value = self.whitePointSlider.maximumValue;
    [groupDefaults setFloat:self.whitePointSlider.value forKey:@"whitePointValue"];
    
    if (self.whitePointSwitch.on) {
        [GammaController setWhitePoint:[groupDefaults floatForKey:@"whitePointValue"] * 100000];
    }
}

@end
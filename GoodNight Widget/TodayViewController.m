//
//  TodayViewController.m
//  GoodNight Widget
//
//  Created by Anthony Agatiello on 10/29/15.
//  Copyright © 2015 ADA Tech, LLC. All rights reserved.
//

#import "TodayViewController.h"
#import "GammaController.h"

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 110);
    
    [self.toggleButton setTitle:@"Deactivate" forState:UIControlStateSelected];
    [self.toggleButton setTitle:@"Activate" forState:UIControlStateNormal];
    
    self.toggleButton.layer.cornerRadius = 7;
    self.toggleButton.layer.backgroundColor = [[UIColor grayColor] CGColor];
    self.toggleButton.layer.masksToBounds = YES;
    self.toggleButton.clipsToBounds = YES;
    
    self.disableButton.layer.cornerRadius = 7;
    self.disableButton.layer.backgroundColor = [[UIColor grayColor] CGColor];
    self.disableButton.layer.masksToBounds = YES;
    
    if (self.view.bounds.size.width > 320) {
        self.toggleButton.frame = CGRectMake(self.toggleButton.frame.origin.x + 30, self.toggleButton.frame.origin.y, self.toggleButton.frame.size.width, self.toggleButton.frame.size.height);
        self.disableButton.frame = CGRectMake(self.disableButton.frame.origin.x + 30, self.disableButton.frame.origin.y, self.disableButton.frame.size.width, self.disableButton.frame.size.height);
        self.temperatureLabel.frame = CGRectMake(self.temperatureLabel.frame.origin.x + 30, self.temperatureLabel.frame.origin.y, self.temperatureLabel.frame.size.width, self.temperatureLabel.frame.size.height);
    }
    
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    BOOL enabled = [groupDefaults boolForKey:@"enabled"];
    self.toggleButton.selected = enabled;
}

- (IBAction)toggleButtonClicked {
    BOOL enabled = [groupDefaults boolForKey:@"enabled"];
    
    if (enabled){
        [GammaController disableOrangeness];
    }
    else{
        [GammaController enableOrangenessWithDefaults:YES transition:YES];
    }
    
    [groupDefaults setBool:@NO.boolValue forKey:@"colorChangingEnabled"];
    [groupDefaults setBool:@NO.boolValue forKey:@"colorChangingLocationEnabled"];
    [groupDefaults setBool:@NO.boolValue forKey:@"colorChangingNightEnabled"];
    
    [self updateUI];
}

- (IBAction)disableButtonClicked {

}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    BOOL enabledOnLastCheck = [groupDefaults boolForKey:@"widgetLastCheckEnabled"];
    BOOL enabled = [groupDefaults boolForKey:@"enabled"];
    [groupDefaults setBool:enabled forKey:@"widgetLastCheckEnabled"];
    [groupDefaults synchronize];
    
    completionHandler(enabledOnLastCheck != enabled ? NCUpdateResultNewData : NCUpdateResultNoData);
}

@end
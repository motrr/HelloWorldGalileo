//
//  ViewController.h
//  HelloWorldGalileo
//
//  Created by Chris Harding on 2/25/13.
//  Copyright (c) 2013 Chris Harding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GalileoControl/PositionControlDelegate.h>

@interface ViewController : UIViewController <PositionControlDelegate>

@property (weak, nonatomic) IBOutlet UIButton *panClockwiseButton;
@property (weak, nonatomic) IBOutlet UIButton *panAnticlockwiseButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

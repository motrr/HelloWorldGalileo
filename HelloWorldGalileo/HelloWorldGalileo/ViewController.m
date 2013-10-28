//  Created by Chris Harding on 2/25/13.
//  Copyright (c) 2013 Chris Harding. All rights reserved.
//

#import "ViewController.h"
#import <GalileoControl/GalileoControl.h>

@interface ViewController () <GCGalileoDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Start waiting for Galileo to connect
    [self disableUI];
    [GCGalileo sharedGalileo].delegate = self;
    [[GCGalileo sharedGalileo] waitForConnection];
}

- (void)viewDidUnload {
    [self setPanClockwiseButton:nil];
    [self setStatusLabel:nil];
    [self setTiltClockwiseButton:nil];
    [self setTiltAnticlockwiseButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark GalileoDelegate methods

- (void) galileoDidConnect
{
    [self enableUI];
    self.statusLabel.text = @"Galileo is connected";
    self.statusLabel.textColor = [UIColor blackColor];
}

- (void) enableUI
{
    [self.view setUserInteractionEnabled:YES];
}

- (void) galileoDidDisconnect
{
    [self disableUI];
    self.statusLabel.text = @"Galileo is not connected";
    self.statusLabel.textColor = [UIColor redColor];
    [[GCGalileo sharedGalileo] waitForConnection];
}

- (void) disableUI
{
    [self.view setUserInteractionEnabled:NO];
}

#pragma mark -
#pragma mark Button handlers

- (IBAction)panClockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisPan] incrementTargetPosition:90.0
                                                                                    completionBlock:completionBlock waitUntilStationary:NO];
}

- (IBAction)panAnticlockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisPan] incrementTargetPosition:-90.0
                                                                                    completionBlock:completionBlock
                                                                                waitUntilStationary:NO];
}

- (IBAction)tiltClockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisTilt] incrementTargetPosition:90
                                                                                     completionBlock:completionBlock
                                                                                 waitUntilStationary:NO];
}

- (IBAction)tiltAnticlockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[GCGalileo sharedGalileo] positionControlForAxis:GCControlAxisTilt] incrementTargetPosition:-90
                                                                                     completionBlock:completionBlock
                                                                                 waitUntilStationary:NO];
}


#pragma mark -
#pragma mark PositionControl delegate

- (void) controlDidReachTargetPosition
{
    // Re-enable the UI now that the target has been reached, assuming we are still connected to Galileo
    if ([[GCGalileo sharedGalileo] isConnected]) [self enableUI];
}


@end

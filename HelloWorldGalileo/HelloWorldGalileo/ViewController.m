//
//  ViewController.m
//  HelloWorldGalileo
//
//  Created by Chris Harding on 2/25/13.
//  Copyright (c) 2013 Chris Harding. All rights reserved.
//

#import "ViewController.h"
#import <GalileoControl/GalileoControl.h>

@interface ViewController () <GalileoDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Start waiting for Galileo to connect
    [self enableUI];
    [Galileo sharedGalileo].delegate = self;
    [[Galileo sharedGalileo] waitForConnection];
}

- (void)viewDidUnload {
    [self setPanClockwiseButton:nil];
    [self setStatusLabel:nil];
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
    [[Galileo sharedGalileo] waitForConnection];
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
    
    [[[Galileo sharedGalileo] positionControlForAxis:GalileoControlAxisPan] incrementTargetPosition:90.0
                                                                                    completionBlock:completionBlock waitUntilStationary:NO];
}

- (IBAction)panAnticlockwise:(id)sender {
    [self disableUI];
    void (^completionBlock) (BOOL) = ^(BOOL wasCommandPreempted)
    {
        if (!wasCommandPreempted) [self controlDidReachTargetPosition];
    };
    [[[Galileo sharedGalileo] positionControlForAxis:GalileoControlAxisPan] incrementTargetPosition:-90.0
                                                                                    completionBlock:completionBlock
                                                                                waitUntilStationary:NO];
}

- (IBAction)tiltClockwise:(id)sender {
    [self disableUI];
    
    [[[Galileo sharedGalileo] positionControlForAxis:GalileoControlAxisTilt] incrementTargetPosition:90
                                                                                      notifyDelegate:self
                                                                                 waitUntilStationary:NO];
}

- (IBAction)tiltAnticlockwise:(id)sender {
    [self disableUI];
    
    [[[Galileo sharedGalileo] positionControlForAxis:GalileoControlAxisTilt] incrementTargetPosition:-90
                                                                                      notifyDelegate:self
                                                                                 waitUntilStationary:NO];
}

- (IBAction)tiltVelocityUp:(id)sender
{
    [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisTilt] setTargetVelocity:90.0];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisTilt] setTargetVelocity:0.0];
    });
}

- (IBAction)tiltVelocityDown:(id)sender
{
    [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisTilt] setTargetVelocity:-90.0];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisTilt] setTargetVelocity:0.0];
    });
}

- (IBAction)panVelocityDown:(id)sender
{
    [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisPan] setTargetVelocity:-90.0];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisPan] setTargetVelocity:0.0];
    });
}

- (IBAction)panVelocityUp:(id)sender
{
    [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisPan] setTargetVelocity:90.0];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[Galileo sharedGalileo] velocityControlForAxis:GalileoControlAxisPan] setTargetVelocity:0.0];
    });
}

#pragma mark -
#pragma mark PositionControl delegate

- (void) controlDidReachTargetPosition
{
    // Re-enable the UI now that the target has been reached, assuming we are still connected to Galileo
    if ([[Galileo sharedGalileo] isConnected]) [self enableUI];
}

- (void) controlDidOverrideMovement
{
    
}


@end

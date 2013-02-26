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
    
    [Galileo sharedGalileo].delegate = self;
    [[Galileo sharedGalileo] waitForConnection];
}

- (void) galileoDidConnect
{
    UIAlertView* galileoConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Galileo connected!"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
    [galileoConnectedAlert show];
}

- (void) galileoDidDisconnect
{
    [[Galileo sharedGalileo] waitForConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PinViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "PinViewController.h"

#import "ScanItemViewController.h"

@interface PinViewController ()
{
    
}

@end

@implementation PinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPinEntered:(id)sender {
    //advance to the PIN screen
    ScanItemViewController *scanView = [[ScanItemViewController alloc] init];
    [[self navigationController] pushViewController:scanView animated:YES];
}

@end

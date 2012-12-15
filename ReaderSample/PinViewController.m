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
        [[self navigationItem] setTitle:@"Enter PIN"];
        
        UIBarButtonItem *startOver = [[UIBarButtonItem alloc] initWithTitle:@"Start Over" style:UIBarButtonSystemItemRewind target:self action:@selector(startOver:)];
        [[self navigationItem] setLeftBarButtonItem:startOver];
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

- (void)startOver
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)startOver:(id)sender
{
    [self startOver];
}

- (IBAction)onPinEntered:(id)sender {
    //advance to the PIN screen
    ScanItemViewController *scanView = [[ScanItemViewController alloc] init];
    [[self navigationController] pushViewController:scanView animated:YES];
}

@end

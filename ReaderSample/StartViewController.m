//
//  StartViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "StartViewController.h"

#import "Library.h"
#import "PinViewController.h"

@interface StartViewController ()
{
    
}

@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // setup top-right save button
        
        [[self navigationItem] setTitle:@"Start"];
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

- (IBAction)onScanButtonPressed:(id)sender {
    //advance to the PIN screen
    PinViewController *pinView = [[PinViewController alloc] init];
    
    Library *library = [Library shared];
    Patron *patron = [library findPatronByIdentifier:@"a"];
    [pinView setTransaction:[library insertNewTransactionForPatron:patron]];
    [library save];
    
    [[self navigationController] pushViewController:pinView animated:YES];
}

@end

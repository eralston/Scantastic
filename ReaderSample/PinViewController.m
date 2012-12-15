//
//  PinViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "PinViewController.h"

#import "ScanItemViewController.h"
#import "Transaction.h"
#import "Patron.h"

@interface PinViewController ()
{
    __weak IBOutlet UITextField *_text;
    __weak IBOutlet UILabel *_patronTxt;
}

@end

@implementation PinViewController

@synthesize transaction;

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
    
    [_patronTxt setText:[NSString stringWithFormat:@"Welcome, %@", [[transaction patron] name]]];
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

- (void)advance
{
    //advance to the PIN screen
    ScanItemViewController *scanView = [[ScanItemViewController alloc] init];
    [scanView setTransaction:[self transaction]];
    [[self navigationController] pushViewController:scanView animated:YES];
}

- (IBAction)onPinEntered:(id)sender {
    [self advance];
}


#pragma mark - Key Events

- (void)appendCharacter:(NSString *)ch
{
    NSString *currentText = [_text text];
    NSString *newText = [NSString stringWithFormat:@"%@%@", currentText, ch ];
    Patron *patron = [[self transaction] patron];
    if([newText isEqual:[patron pin]])
        [self advance];
    else
        [_text setText:newText];
}

- (void)removeCharacter
{
    NSString *currentText = [_text text];
    if([currentText length] == 0)
        return;
    [_text setText:[currentText substringToIndex:[currentText length] - 1]];
}

- (IBAction)onNine:(id)sender {
    [self appendCharacter:@"9"];
}

- (IBAction)onEight:(id)sender {
    [self appendCharacter:@"8"];
}

- (IBAction)onSeven:(id)sender {
    [self appendCharacter:@"7"];
}

- (IBAction)onSix:(id)sender {
    [self appendCharacter:@"6"];
}

- (IBAction)onFive:(id)sender {
    [self appendCharacter:@"5"];
}

- (IBAction)onFour:(id)sender {
    [self appendCharacter:@"4"];
}

- (IBAction)onThree:(id)sender {
    [self appendCharacter:@"3"];
}

- (IBAction)onTwo:(id)sender {
    [self appendCharacter:@"2"];
}

- (IBAction)onOne:(id)sender {
    [self appendCharacter:@"1"];
}

- (IBAction)onZero:(id)sender {
    [self appendCharacter:@"0"];
}

- (IBAction)onBackspace:(id)sender {
    [self removeCharacter];
}

@end











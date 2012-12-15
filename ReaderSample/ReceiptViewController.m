//
//  ReceiptViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "ReceiptViewController.h"

@interface ReceiptViewController ()
{
    NSTimer *_timer;
    NSDate *_startDate;
    NSInteger _timeoutInSeconds;
    
    IBOutlet UITableView *_optionsTable;
    IBOutlet UILabel *_timerLbl;
}

@end

@implementation ReceiptViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Receipt"];
        
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    // automatically start a 15 second timer
    _timeoutInSeconds = 16;
    _startDate = [[NSDate alloc] init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(pollTime)
                                                  userInfo:nil
                                                   repeats:YES];
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

#pragma mark - Event-Target Handlers

- (void) pollTime
{
    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval elapsedTime = [now timeIntervalSinceDate:_startDate];
    NSInteger secondsLeft = floor(_timeoutInSeconds - elapsedTime);
    if(secondsLeft <= 0) {
        [self startOver];
        [_timer invalidate];
    } else {
        [_timerLbl setText:[NSString stringWithFormat:@"%d", secondsLeft]];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellId = @"ReceiptTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];

    NSString *rowText = @"";
    switch([indexPath row]) {
        case 0: rowText = @"Print"; break;
        case 1: rowText = @"E-Mail"; break;
        case 2: rowText = @"Text Message"; break;
        case 3: rowText = @"None"; break;
            
    }
    [[cell textLabel] setText:rowText];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self startOver];
}

@end

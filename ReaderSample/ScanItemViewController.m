//
//  ScanItemViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#include <AVFoundation/AVFoundation.h>

#import "ScanItemViewController.h"

#import "Item.h"
#import "Library.h"
#import "ReceiptViewController.h"
#import "ZBarReaderView.h"
#import "ZBarReaderViewController.h"

@interface ScanItemViewController ()
{
    ZBarReaderView *_reader;
    __weak IBOutlet ZBarReaderView *_scanner;
    __weak IBOutlet UITableView *_table;

    AVAudioPlayer *_player;
}

@end

@implementation ScanItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Scan Items"];
        
        UIBarButtonItem *startOver = [[UIBarButtonItem alloc] initWithTitle:@"Start Over" style:UIBarButtonSystemItemRewind target:self action:@selector(startOver:)];
        [[self navigationItem] setLeftBarButtonItem:startOver];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scanner setReaderDelegate:self];
    
    [_table setEditing:YES];
    
    // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource: @"tap"
                                                ofType: @"caf"];
    NSURL *soundUrl = [[NSURL alloc] initFileURLWithPath:soundPath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}

// Respond to a tap on the System Sound button.
- (void) playSystemSound {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [_player play];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_scanner start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_scanner stop];
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

- (IBAction)onStartOverTouched:(id)sender {

    [self startOver];
}

- (IBAction)onCheckoutTouched:(id)sender {
    //advance to the PIN screen
    ReceiptViewController *receiptView = [[ReceiptViewController alloc] init];
    [receiptView setTransaction:[self transaction]];
    [[self navigationController] pushViewController:receiptView animated:YES];
}

- (void)barcodeScanned:(NSString *)text {
    Library *library = [Library shared];
    Item *item = [library findItemByIdentifier:text];
    
    if(item){
        NSLog(@"Found patron %@", [item name]);
        if(![[self.transaction items] containsObject:item])
        {
            [self.transaction addItemsObject:item];
            [library save];
        }
    } else {
        NSLog(@"Could not find patron with identifier %@", text);
    }
}

#pragma mark - Reader Delegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols)
        // EXAMPLE: just grab the first barcode
        break;
    [self barcodeScanned:[symbol data]];
    
    [self playSystemSound];
    
    [_table reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

#pragma mark - Table Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self transaction] items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellId = @"ScanTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
    
    NSArray *array = [[[self transaction] items] allObjects];
    Item *item = [array objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item name]];
    
    return cell;
}

#pragma mark - Table Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [[[self transaction] items] allObjects];
    Item *item = [array objectAtIndex:[indexPath row]];
    [[self transaction] removeItemsObject:item];
    [[Library shared] save];
    
    [_table reloadData];
}

@end

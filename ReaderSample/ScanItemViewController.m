//
//  ScanItemViewController.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "ScanItemViewController.h"

#import "Library.h"
#import "ReceiptViewController.h"
#import "ZBarReaderView.h"
#import "ZBarReaderViewController.h"

@interface ScanItemViewController ()
{
    ZBarReaderView *_reader;
    __weak IBOutlet ZBarReaderView *_scanner;
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
    
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)onAllItemsScanned:(id)sender {
    //advance to the PIN screen
    ReceiptViewController *receiptView = [[ReceiptViewController alloc] init];
    [receiptView setTransaction:[self transaction]];
    [[self navigationController] pushViewController:receiptView animated:YES];
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    NSString *text = symbol.data;
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

@end

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
    __weak IBOutlet ZBarReaderView *_scanner;
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
    [_scanner setReaderDelegate:self];
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

- (void)barcodeScanned:(NSString *)text
{
    // EXAMPLE: do something useful with the barcode data
    Library *library = [Library shared];
    Patron *patron = [library findPatronByIdentifier:text];
    
    if(patron){
        NSLog(@"Found patron %@", [patron name]);
        
        PinViewController *pinView = [[PinViewController alloc] init];
        [pinView setTransaction:[library insertNewTransactionForPatron:patron]];
        [library save];
        [[self navigationController] pushViewController:pinView animated:YES];
    } else {
        NSLog(@"Could not find patron with identifier %@", text);
    }
}

#pragma  mark - Image Picking

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols)
        // EXAMPLE: just grab the first barcode
        break;
    [self barcodeScanned:[symbol data]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    

    
}

@end

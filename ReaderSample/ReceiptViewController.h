//
//  ReceiptViewController.h
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Transaction.h"

@interface ReceiptViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Transaction *transaction;

@end

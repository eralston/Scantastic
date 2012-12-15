//
//  CustomNavigationController.h
//
//  Created by Jon Hjelle on 12/14/12.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UIViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

@end


@interface UIViewController (CustomNavigationController)

- (CustomNavigationController *)customNavigationController;

@end
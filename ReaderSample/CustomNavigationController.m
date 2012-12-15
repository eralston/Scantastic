//
//  CustomNavigationController.m
//
//  Created by Jon Hjelle on 12/14/12.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()
@property (nonatomic, copy) NSMutableArray *viewControllers;
@end

@implementation CustomNavigationController

@synthesize viewControllers = _viewControllers;

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        _viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 200.0f, 400.0f, 300.0f)];
        [label setText:@"ROOT VIEW CONTROLLER"];
        [rootViewController.view addSubview:label];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    if ([rootViewController parentViewController] != self) {
        [rootViewController.view setFrame:[self childViewControllerFrame]];

        [self addChildViewController:rootViewController];
        [self.view addSubview:rootViewController.view];
        [rootViewController didMoveToParentViewController:self];
    }
}

- (CGRect)childViewControllerFrame {
    return CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 150.0f);
}

- (CGRect)childViewControllerRightOffscreenFrame {
    return CGRectMake(self.view.bounds.size.width, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 150.0f);
}

- (CGRect)childViewControllerLeftOffscreenFrame {
    return CGRectMake(-(self.view.bounds.size.width), 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 150.0f);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *oldViewController = [self.viewControllers lastObject];
    [self.viewControllers addObject:viewController];

    if ([viewController parentViewController] != self) {
        [viewController.view setFrame:[self childViewControllerRightOffscreenFrame]];

        [self addChildViewController:viewController];

        if (animated) {
            [self transitionFromViewController:oldViewController
                              toViewController:viewController
                                      duration:0.2f
                                       options:UIViewAnimationCurveEaseInOut
                                    animations:^{
                                        [oldViewController.view setFrame:[self childViewControllerLeftOffscreenFrame]];
                                        [viewController.view setFrame:[self childViewControllerFrame]];
                                    }
                                    completion:^(BOOL finished) {
                                        [viewController didMoveToParentViewController:self];
                                    }];
        } else {
            [oldViewController.view setFrame:[self childViewControllerLeftOffscreenFrame]];
            [viewController.view setFrame:[self childViewControllerFrame]];
            [self.view addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *oldViewController = [self.viewControllers lastObject];
    [self.viewControllers removeObject:oldViewController];

    UIViewController *newViewController = [self.viewControllers lastObject];
    if (!newViewController) {
        [self.viewControllers addObject:oldViewController];
        return nil;
    }

    [newViewController.view setFrame:[self childViewControllerLeftOffscreenFrame]];

    [oldViewController willMoveToParentViewController:nil];

    if (animated) {
        [self transitionFromViewController:oldViewController
                          toViewController:newViewController
                                  duration:0.2f
                                   options:UIViewAnimationCurveEaseInOut
                                animations:^{
                                    [oldViewController.view setFrame:[self childViewControllerRightOffscreenFrame]];
                                    [newViewController.view setFrame:[self childViewControllerFrame]];
                                }
                                completion:^(BOOL finished) {
                                    [oldViewController removeFromParentViewController];
                                }];
    } else {
        [oldViewController.view setFrame:[self childViewControllerRightOffscreenFrame]];
        [newViewController.view setFrame:[self childViewControllerFrame]];
        [oldViewController.view removeFromSuperview];
        [self.view addSubview:newViewController.view];
        [oldViewController removeFromParentViewController];
    }

    return oldViewController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *oldViewController = [self.viewControllers lastObject];
    [self.viewControllers removeObject:oldViewController];

    UIViewController *rootViewController = nil;
    if ([self.viewControllers count]) {
        rootViewController = [self.viewControllers objectAtIndex:0];
    } else {
        [self.viewControllers addObject:oldViewController];
        return nil;
    }

    NSMutableArray *poppedViewControllers = [NSMutableArray array];
    UIViewController *poppedViewController = [self.viewControllers lastObject];
    while (poppedViewController != rootViewController) {
        [poppedViewControllers addObject:poppedViewController];
        [poppedViewController willMoveToParentViewController:nil];
        [poppedViewController.view removeFromSuperview];
        [poppedViewController removeFromParentViewController];
        [self.viewControllers removeLastObject];
        poppedViewController = [self.viewControllers lastObject];
    }

    [rootViewController.view setFrame:[self childViewControllerLeftOffscreenFrame]];

    [oldViewController willMoveToParentViewController:nil];

    if (animated) {
        [self transitionFromViewController:oldViewController
                          toViewController:rootViewController
                                  duration:0.2f
                                   options:UIViewAnimationCurveEaseInOut
                                animations:^{
                                    [oldViewController.view setFrame:[self childViewControllerRightOffscreenFrame]];
                                    [rootViewController.view setFrame:[self childViewControllerFrame]];
                                }
                                completion:^(BOOL finished) {
                                    [oldViewController removeFromParentViewController];
                                }];
    } else {
        [oldViewController.view setFrame:[self childViewControllerRightOffscreenFrame]];
        [rootViewController.view setFrame:[self childViewControllerFrame]];
        [oldViewController.view removeFromSuperview];
        [self.view addSubview:rootViewController.view];
        [oldViewController removeFromParentViewController];
    }

    return (NSArray *)poppedViewControllers;
}

@end


@implementation UIViewController (CustomNavigationController)

- (CustomNavigationController *)customNavigationController {
    UIViewController *potentialNavController = self.parentViewController;
    while (potentialNavController) {
        if ([potentialNavController isKindOfClass:[CustomNavigationController class]]) {
            return (CustomNavigationController *)potentialNavController;
        }

        potentialNavController = potentialNavController.parentViewController;
    }
    return nil;
}

@end
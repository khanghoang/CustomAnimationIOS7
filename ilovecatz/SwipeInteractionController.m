//
//  SwipeInteractionController.m
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "SwipeInteractionController.h"

@interface SwipeInteractionController()

@property (nonatomic, assign) BOOL shouldCompeteTransition;
@property (nonatomic, strong) UINavigationController *navigationViewController;

@end

@implementation SwipeInteractionController

- (void)wireToViewController:(UIViewController *)viewController
{
    self.navigationViewController = viewController.navigationController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGesture:)];
    [view addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:panGesture.view.superview];

    CGFloat fraction = - (translation.x / 200.0);
    NSLog(@"faction = %f", fraction);
    fraction = fminf(fmaxf(fraction, 0.0), 1.0);

    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactionOnProgress = YES;
            [self.navigationViewController popViewControllerAnimated:YES];
            break;
        }

        case UIGestureRecognizerStateChanged: {
            // caculate the current position

            self.shouldCompeteTransition = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];

            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {

            self.interactionOnProgress = NO;
            if (!self.shouldCompeteTransition || panGesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
                return;
            }

            [self finishInteractiveTransition];

            break;
        }

        default:
            break;
    }
}

- (CGFloat )completionSpeed
{
    return 1 - self.percentComplete;
}

@end

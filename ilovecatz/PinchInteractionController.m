//
//  PinchInteractionController.m
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "PinchInteractionController.h"

@interface PinchInteractionController()

@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) BOOL interactionOnProgress;
@property (assign, nonatomic) BOOL shouldCompleteTransition;

@end

@implementation PinchInteractionController

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

- (void)wireToViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinchGesture:)];
    [view addGestureRecognizer:pinchGesture];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactionOnProgress = YES;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }

        case UIGestureRecognizerStateChanged: {
            CGFloat percent = MIN(1, ABS(1 - pinchGesture.scale));
            NSLog(@"Scale = %f", percent);
            self.shouldCompleteTransition = percent > 0.5;
            [self updateInteractiveTransition:percent];
            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {

            self.interactionOnProgress = NO;
            if (!self.shouldCompleteTransition || pinchGesture.state == UIGestureRecognizerStateCancelled) {
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

@end

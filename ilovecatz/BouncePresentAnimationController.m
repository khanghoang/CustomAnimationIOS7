//
//  BouncePresentAnimationController.m
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    //1. get to-VC and final state
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];

    //1. get from-VC and from state
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    //2. get the container view
    UIView *containerView = [transitionContext containerView];

    //3. set the initalView
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);

    //4. add the view
    [containerView addSubview:toViewController.view];

    //5. animation
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveLinear animations:^{
              fromViewController.view.alpha = 0.5;
              toViewController.view.frame = finalFrame;
          } completion:^(BOOL finished) {
              fromViewController.view.alpha = 1.0;
              [transitionContext completeTransition:YES];
          }];
}

@end
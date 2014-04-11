//
//  SkrinkDismissAnimationController.m
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "SkrinkDismissAnimationController.h"

@implementation SkrinkDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGRect finalFrame = [transitionContext finalFrameForViewController:toController];

    UIView *containerView = [transitionContext containerView];

    toController.view.frame = finalFrame;
    toController.view.alpha = 0.0;

    [containerView addSubview:toController.view];
    [containerView bringSubviewToFront:toController.view];

    // animation
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect shrunkenFrame = CGRectInset(fromController.view.frame,
                                       fromController.view.frame.size.width/4,
                                       fromController.view.frame.size.height/4);

    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateKeyframesWithDuration:duration delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{

                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    fromController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                                                    toController.view.alpha = 0.5f;
                                                                }];

                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    fromController.view.frame = fromFinalFrame;
                                                                    toController.view.alpha = 1.0f;
                                                                }];


                              } completion:^(BOOL finished) {

                                  toController.view.alpha = 1;
                                  [transitionContext completeTransition:YES];
    }];

}

@end

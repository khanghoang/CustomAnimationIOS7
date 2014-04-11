//
//  FlipAnimationController.m
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "FlipAnimationController.h"

@interface FlipAnimationController()

@end

@implementation FlipAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (CATransform3D)yRotation:(CGFloat)angle {
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containView = [transitionContext containerView];

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    [containView addSubview:toView];

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containView.layer setSublayerTransform:transform];

    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;

    CGFloat factor = self.reverse ? 1.0f : -1.0f;

    toView.layer.transform = [self yRotation:factor * -M_PI_2];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:0
                              animations:^{

                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    fromView.layer.transform = [self yRotation:factor * M_PI_2];
                                                                }];

                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    toView.layer.transform = [self yRotation:0.0f];
                                                                }];

                              } completion:^(BOOL finished) {

                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

                              }];

}

@end

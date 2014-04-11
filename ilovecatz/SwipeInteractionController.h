//
//  SwipeInteractionController.h
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractionController : UIPercentDrivenInteractiveTransition

- (void)wireToViewController:(UIViewController *)viewController;
@property (nonatomic, assign) BOOL interactionOnProgress;

@end

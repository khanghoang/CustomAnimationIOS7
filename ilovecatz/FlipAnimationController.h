//
//  FlipAnimationController.h
//  ilovecatz
//
//  Created by Triệu Khang on 11/4/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlipAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL reverse;

@end

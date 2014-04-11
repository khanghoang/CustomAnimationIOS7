//
//  MasterViewController.m
//  ILoveCatz
//
//  Created by Colin Eberhardt on 22/08/2013.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Cat.h"
#import "BouncePresentAnimationController.h"
#import "SkrinkDismissAnimationController.h"
#import "SwipeInteractionController.h"
#import "FlipAnimationController.h"
#import "PinchInteractionController.h"

@interface MasterViewController ()
<
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate
>

@property (strong, nonatomic) BouncePresentAnimationController *boundAnimationController;
@property (strong, nonatomic) SkrinkDismissAnimationController *shrinkAnimationController;
@property (strong, nonatomic) SwipeInteractionController *swipeInteractionAnimationController;
@property (strong, nonatomic) FlipAnimationController *flipAnimationController;
@property (strong, nonatomic) PinchInteractionController *pinchAnimationController;

@end

@implementation MasterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _boundAnimationController = [[BouncePresentAnimationController alloc] init];
        _shrinkAnimationController = [SkrinkDismissAnimationController new];
        _swipeInteractionAnimationController = [SwipeInteractionController new];
        _flipAnimationController = [FlipAnimationController new];
        _pinchAnimationController = [PinchInteractionController new];
    }

    return self;
}

- (NSArray *)cats {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).cats;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // see a cat image as a title
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat"]];
    self.navigationItem.titleView = imageView;

    self.navigationController.delegate = self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.shrinkAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.boundAnimationController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self cats].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Cat* cat = [self cats][indexPath.row];
    cell.textLabel.text = cat.title;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // find the tapped cat
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Cat *cat = [self cats][indexPath.row];
        
        // provide this to the detail view
        [[segue destinationViewController] setCat:cat];
    }

    if ([segue.identifier isEqualToString:@"ShowAbout"]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
        [self.pinchAnimationController wireToViewController:toVC];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        [self.swipeInteractionAnimationController wireToViewController:toVC];
    }

    self.flipAnimationController.reverse = operation == UINavigationControllerOperationPop;
    return self.flipAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>) navigationController:
(UINavigationController *)navigationController interactionControllerForAnimationController:
(id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.swipeInteractionAnimationController.interactionOnProgress ? self.swipeInteractionAnimationController : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.pinchAnimationController;
}

@end

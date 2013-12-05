//
//  JCNavDeckController.m
//

#import "JCNavDeckController.h"
#import "UIViewController+JCNavDeckController(Private).h"
#import "JCNavDeckMenuViewController.h"
#import "JCNavDeckContainerViewController.h"

@interface JCNavDeckController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) JCNavDeckMenuViewController *menuViewController;
@property (nonatomic, strong) JCNavDeckContainerViewController *containerViewController;
@property (nonatomic, strong) NSLayoutConstraint *containerLeftEdgeConstraint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

static const CGFloat kJCNavDeckLedgeWidth = 75.f;
static const CGFloat kJCNavDeckAnimationDuration = 0.4f;
static const UIViewAnimationOptions kJCNavDeckDefaultSwipedAnimationCurve = UIViewAnimationOptionCurveEaseOut;

@implementation JCNavDeckController
@dynamic selectedViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self configureController];
    }
    return self;
}

- (void)configureController
{
    //set a default value that we can check below
    _selectedIndex = NSNotFound;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Setup Menu View Controller
    self.menuViewController = [[JCNavDeckMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    self.menuViewController.navDeckController = self; //here's the first use of our new view controller property

    [self addChildViewController:self.menuViewController];

    UIView *menu = self.menuViewController.view;
    menu.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:menu];

    NSDictionary *views = NSDictionaryOfVariableBindings(menu);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[menu]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[menu]|" options:0 metrics:nil views:views]];

    [self.menuViewController didMoveToParentViewController:self];


    self.containerViewController = [[JCNavDeckContainerViewController alloc] initWithNibName:nil bundle:nil];
    self.containerViewController.navDeckController = self;

    [self addChildViewController:self.containerViewController];

    UIView *container = self.containerViewController.view;
    container.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:container];

    views = NSDictionaryOfVariableBindings(container);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|" options:0 metrics:nil views:views]];

    NSLayoutConstraint *containerWidth = [NSLayoutConstraint constraintWithItem:container
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0];

    self.containerLeftEdgeConstraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0];

    [self.view addConstraints:@[containerWidth, self.containerLeftEdgeConstraint]];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(containerViewDidPan:)];
    panGesture.delegate = self;
    self.panGesture = panGesture;
    [self.containerViewController.view addGestureRecognizer:panGesture];


    if (self.selectedIndex != NSNotFound)
    {
        [self displayViewControllerAtIndex:self.selectedIndex];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Getters and Setters

- (void)setViewControllers:(NSArray *)viewControllers
{
    NSParameterAssert(viewControllers); //this will crash the app in development if viewControllers is nil.

    _viewControllers = viewControllers;

    //If the view is not loaded then menuViewController will be nil and this will be a no op
    [self.menuViewController.tableView reloadData];

    if ([_viewControllers count] > 0)
    {
        [self setSelectedIndex:0];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    NSAssert(selectedIndex < [self.viewControllers count], @"selectedIndex must be within range of self.viewController"); //this will crash in development if a bad index is set
    if (selectedIndex < [self.viewControllers count]) //in production NSAssert macros get compiled out. We want to make sure we protect this iVar from invalid input, so just refuse bad input
    {
        _selectedIndex = selectedIndex;

        if ([self isViewLoaded])
        {
            [self displayViewControllerAtIndex:_selectedIndex];
            [self close];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound)
    {
        return self.viewControllers[self.selectedIndex];
    }
    return nil;
}


#pragma mark - animations

- (void)open
{
    [self openAnimated:YES duration:kJCNavDeckAnimationDuration];
}

- (void)openAnimated:(BOOL)animated duration:(CGFloat)animationDuration
{
    self.containerLeftEdgeConstraint.constant = CGRectGetWidth(self.view.bounds) - kJCNavDeckLedgeWidth;

    if (animated)
    {
        [UIView animateWithDuration:kJCNavDeckAnimationDuration delay:0 options:kJCNavDeckDefaultSwipedAnimationCurve animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.containerViewController.tapCaptureEnabled = YES;
        }];
    }
    else
    {
        [self.view layoutIfNeeded];
        self.containerViewController.tapCaptureEnabled = YES;
    }
}

- (void)close
{
    [self closeAnimated:YES duration:kJCNavDeckAnimationDuration];
}

- (void)closeAnimated:(BOOL)animated duration:(CGFloat)animationDuration
{
    self.containerLeftEdgeConstraint.constant = 0;

    if (animated)
    {
        [UIView animateWithDuration:animationDuration delay:0 options:kJCNavDeckDefaultSwipedAnimationCurve animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.containerViewController.tapCaptureEnabled = NO;
        }];
    }
    else
    {
        [self.view layoutIfNeeded];
        self.containerViewController.tapCaptureEnabled = NO;
    }
}

- (void)toggle
{
    if (self.containerLeftEdgeConstraint.constant > 0)
    {
        [self close];
    }
    else
    {
        [self open];
    }
}

#pragma mark - Internal Methods

- (void)displayViewControllerAtIndex:(NSUInteger)index
{
    UIViewController *vc = self.viewControllers[index];
    self.containerViewController.rootViewController = vc;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    UIPanGestureRecognizer *myPanGesture = self.panGesture;
    if (gestureRecognizer == self.panGesture)
    {
	BOOL isOpen = (self.containerLeftEdgeConstraint.constant < 1.f);
	return !isOpen;
    }

    return YES;
}

#pragma mark - Animation Calculations

static NSTimeInterval durationToAnimate(CGFloat pointsToAnimate, CGFloat velocity)
{
    NSTimeInterval animationDuration = pointsToAnimate / fabsf(velocity);
    // adjust duration for easing curve, if necessary
    if (kJCNavDeckDefaultSwipedAnimationCurve != UIViewAnimationOptionCurveLinear) animationDuration *= 1.25;
    return animationDuration;
}

#pragma mark - Panning

static CGFloat firstX = 0;

- (void)containerViewDidPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = self.containerViewController.view;
    CGPoint translatedPoint = [gestureRecognizer translationInView:view];
    CGFloat v = translatedPoint.x;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        firstX = view.frame.origin.x;
    }

    CGFloat lowerClampedX = MAX(firstX + v, 0);
    CGFloat upperClampedX = MIN(CGRectGetWidth(self.view.frame), lowerClampedX);

    CGFloat m = CGRectGetWidth(self.view.frame);

    self.containerLeftEdgeConstraint.constant = upperClampedX;
    [self.view layoutIfNeeded];

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
        gestureRecognizer.state == UIGestureRecognizerStateFailed ||
        gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGFloat orientationVelocity = [gestureRecognizer velocityInView:view].x;
        CGFloat lm3 = (m - kJCNavDeckLedgeWidth) / 3.0f;

        if (ABS(orientationVelocity) < 500)
        {
            if (firstX + v >= lm3)
            {
                [self open];
            }
            else if (firstX + v >= m - kJCNavDeckLedgeWidth - lm3)
            {
                [self open];
            }
            else
            {
                [self close];
            }
        }
        else if (orientationVelocity != 0.0f)
        {
            if (orientationVelocity < 0)
            {
                // swipe to the left
                // Animation duration based on velocity
                CGFloat pointsToAnimate = view.frame.origin.x;
                NSTimeInterval animationDuration = durationToAnimate(pointsToAnimate, orientationVelocity);

                [self closeAnimated:YES duration:animationDuration];
            }
            else if (orientationVelocity > 0)
            {
                // swipe to the right
                // Animation duration based on velocity
                CGFloat pointsToAnimate = fabsf(m - kJCNavDeckLedgeWidth - view.frame.origin.x);
                NSTimeInterval animationDuration = durationToAnimate(pointsToAnimate, orientationVelocity);

                [self openAnimated:YES duration:animationDuration];
            }
        }
    }
}

@end

//
//  JCNavDeckContainerViewController.m
//  JCNavDeckDemo
//

#import "JCNavDeckContainerViewController.h"
#import "JCNavDeckController.h"
#import "UIViewController+JCNavDeckController(Private).h"

@interface JCNavDeckContainerViewController ()
@property (nonatomic, strong) UIView *coverView;
@end

@implementation JCNavDeckContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark - Setters

- (void)setRootViewController:(UIViewController *)rootViewController
{
    NSParameterAssert([self isViewLoaded]); //the view must be loaded at this point

    if (_rootViewController != rootViewController)
    {
        //Standard view controller containment teardown procedure
        [_rootViewController willMoveToParentViewController:nil];
        [_rootViewController.view removeFromSuperview];
        [_rootViewController removeFromParentViewController];

        _rootViewController = rootViewController;
        //Using the private category
        _rootViewController.navDeckController = self.navDeckController;

        //Standard view controller containment setup procedure
        [self addChildViewController:_rootViewController];
        [self.view addSubview:_rootViewController.view];
        [_rootViewController didMoveToParentViewController:self];

        [self.view bringSubviewToFront:self.coverView];

        [self updateViewConstraints];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];

    UIView *rootvc = self.rootViewController.view;
    rootvc.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(rootvc);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[rootvc]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rootvc]|" options:0 metrics:nil views:views]];
}

- (void)setTapCaptureEnabled:(BOOL)tapCaptureEnabled
{
    _tapCaptureEnabled = tapCaptureEnabled;

    if (tapCaptureEnabled)
    {
	if (self.coverView == nil)
	{
	    self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
            self.coverView.translatesAutoresizingMaskIntoConstraints = NO;

	    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerContainerTapGestureRecognised:)];
	    [self.coverView addGestureRecognizer:tapGestureRecognizer];
	}
	[self.view addSubview:self.coverView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_coverView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_coverView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_coverView]|" options:0 metrics:nil views:views]];
    }
    else
    {
	[self.coverView removeFromSuperview];
    }
}

- (void)topViewControllerContainerTapGestureRecognised:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.navDeckController toggle];
}

@end

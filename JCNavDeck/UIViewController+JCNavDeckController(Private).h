//
//  UIViewController+JCNavDeckController(Private).h
//

#import <UIKit/UIKit.h>

//This private category which marks the navDeckController property as readwrite is used within the JCNavDeckController.
//It is not designed to be used outside of that class.

@class JCNavDeckController;

@interface UIViewController (JCNavDeckViewControllerItemPrivate)

@property (nonatomic, strong, readwrite) JCNavDeckController *navDeckController;

@end

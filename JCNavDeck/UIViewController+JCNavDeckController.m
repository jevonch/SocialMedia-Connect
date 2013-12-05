//
//  UIViewController+JCNavDeckController.m
//

#import "JCNavDeckController.h"
#import "UIViewController+JCNavDeckController(Private).h"

#import <objc/runtime.h>


// Note: JC - In order to add instance variables to classes through categories we need to use a feature of the objective C runtime
// see: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html -> Associative References
// see: http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references

static char navDeckItem_key;
static char navDeckController_key;

@implementation UIViewController (JCNavDeckViewControllerItem)

//Properties on categories must be dynamic because it's not possible to synthesize ivars
@dynamic navDeckItem;
@dynamic navDeckController;

- (JCNavDeckItem *)navDeckItem
{
    JCNavDeckItem *ndi = objc_getAssociatedObject(self, &navDeckItem_key);
    if (ndi == nil)
    {
        ndi = [[JCNavDeckItem alloc] init];
        //emulating UITabBarItem by creating this item lazily and setting it's title to the title of the view controller
        ndi.title = self.title;
        objc_setAssociatedObject(self, &navDeckController_key, ndi, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ndi;
}

@end

@implementation UIViewController (JCNavDeckViewControllerItemPrivate)
@dynamic navDeckController;

- (JCNavDeckController *)navDeckController
{
    return objc_getAssociatedObject(self, &navDeckController_key);
}

- (void)setNavDeckController:(JCNavDeckController *)navDeckController
{
    objc_setAssociatedObject(self, &navDeckController_key, navDeckController, OBJC_ASSOCIATION_ASSIGN);
}

@end

//
//  JCNavDeckMenuViewController.m
//  JCNavDeckDemo

#import "JCNavDeckMenuViewController.h"
#import "JCNavDeckController.h"

static NSString * const kMenuCellReuseIdentifier = @"kMenuCellReuseIdentifier";

@interface JCNavDeckMenuViewController ()
@end

@implementation JCNavDeckMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuCellReuseIdentifier];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.navDeckController.viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellReuseIdentifier forIndexPath:indexPath];

    //Fetch the particular controller in the nav deck controller's 
   // UIViewController *controller = self.navDeckController.viewControllers[indexPath.row];
   // JCNavDeckItem *navDeckItem = controller.navDeckItem;

    if (indexPath.row==0) {
        cell.textLabel.text = @"Facebook";
    }
    else if (indexPath.row==1) {
        cell.textLabel.text = @"Twitter";
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navDeckController setSelectedIndex:indexPath.row];
}

@end

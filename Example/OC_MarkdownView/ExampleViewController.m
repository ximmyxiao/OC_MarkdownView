//
//  ExampleViewController.m
//  testSSE
//
//  Created by ximmy on 2025/4/25.
//

#import "ExampleViewController.h"
#import "MVViewController.h"
#import "MarkdownViewStyleManager.h"

@interface ExampleViewController () <UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath* currentSelectIndexPath;
@end

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MarkdownViewStyleManager sharedInstance].mainFontSize = 20.0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    self.currentSelectIndexPath = indexPath;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        UIViewController* destinationVC = segue.destinationViewController;

        // 传递参数到目标视图控制器
        if ([destinationVC respondsToSelector:@selector(setMarkdownContentType:)]) {
            if (self.currentSelectIndexPath.section == 0) {
                NSArray* allTypes = @[ @"Heading", @"List", @"TextStyles", @"Quote", @"Code", @"Table" ];
                if (self.currentSelectIndexPath.row < allTypes.count) {
                    NSString* type = allTypes[self.currentSelectIndexPath.row];
                    destinationVC.navigationItem.title = type;
                    [destinationVC performSelector:@selector(setMarkdownContentType:) withObject:type];
                }
            } else {
                NSString* type = @"SSE";
                destinationVC.navigationItem.title = type;
                [destinationVC performSelector:@selector(setMarkdownContentType:) withObject:type];
            }
        }
    }
}

@end

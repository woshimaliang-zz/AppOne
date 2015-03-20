//
//  FirstViewController.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/13/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageDetailViewController.h"
#import "ImageTableViewCell.h"
#import "ImagesManager.h"
#import "ImageItem.h"
#import <UIImageView+WebCache.h>

@interface ImagesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate> {
    NSString* _keyword;
}

@property (nonatomic) IBOutlet UISearchBar* searchBar;
@property (nonatomic) IBOutlet UITableViewCell* loadingCell;
@property (nonatomic) NSMutableArray *tableData; //array of ImageItem;

@property (nonatomic) IBOutlet UIActivityIndicatorView* activityView;

@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.searchBar.text = @"Obama";
    [self searching:self.searchBar.text withCursor:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - searchbox
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    [self searching:searchBar.text withCursor:0];
    _tableData = nil;
}

-(void) searching:(NSString*)keyword withCursor:(NSInteger)index  {
    _keyword = keyword;
    
    __block ImagesViewController* __weak weakSelf = self;
    
    [[ImagesManager sharedInstance] loading:keyword withCursor:index returnResponse:^(NSArray * array) {
        if (!array) return;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (weakSelf.tableData == nil) {
                weakSelf.tableData = [NSMutableArray arrayWithArray:array];
            } else {
                [weakSelf.tableData addObjectsFromArray:array];
            }
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    
//    NSArray* filteredData = nil;
//    
//    if (searchText.length >0) {
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"rawTitle CONTAINS[cd] %@", searchText];
//        filteredData = [_tableData filteredArrayUsingPredicate:predicate];
//    } else {
//        filteredData = _tableData;
//    }
//    
//    [self.tableView reloadData];
//}

#pragma mark UIGestureRecognizerDelegate methods
- (IBAction)handleTap {
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (_tableData.count==0) return 0;
    
    if ( _tableData.count < [ImagesManager sharedInstance].max_results) {
        return _tableData.count +1;
    }
    
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_tableData.count) {
        return 40;
    }
    
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==_tableData.count) {
        self.loadingCell.textLabel.text = @"Loading More...";
        [self.activityView startAnimating];
        [self searching:self.searchBar.text withCursor:_tableData.count];
        return self.loadingCell;
    }
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagecell" forIndexPath:indexPath];
    // nil will always be valid
    ImageItem* item = [_tableData objectAtIndex:indexPath.row];
    
    cell.label.text = item.rawTitle;
    [self highlightLabelText:cell.label forText:_keyword];
    [cell.tbImage sd_setImageWithURL:[NSURL URLWithString:item.tbImgUrl]];
    return cell;
}

-(void) highlightLabelText:(UILabel*) label forText:(NSString*)text {
    if(label.text.length==0) return;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text attributes:nil];
    
    // Red text attributes
    NSRange textRange = [label.text rangeOfString:text options:NSCaseInsensitiveSearch];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:textRange];
    [attributedText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} range:textRange];
    
    label.attributedText = attributedText;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    
    ImageDetailViewController* p = segue.destinationViewController;
    NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;
    ImageItem* item = [_tableData objectAtIndex:indexPath.row];
    
    //p.title =  item.rawTitle;
    p.imageItem = item;
    
    NSLog(@"%@", p);
}


@end

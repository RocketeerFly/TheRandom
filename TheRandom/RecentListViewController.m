//
//  RecentListViewController.m
//  TheRandom
//
//  Created by RocketeerFly on 9/25/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import "RecentListViewController.h"
#import "RecentListTableViewCell.h"
#import "Constants.h"

@interface RecentListViewController ()

@end

@implementation RecentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id list = [NSUserDefaults.standardUserDefaults objectForKey:@"recent_list"];
    if (list) {
        self.arrayList = (NSArray*)list;
        self.arrayList = [[self.arrayList reverseObjectEnumerator] allObjects];
    } else {
        self.arrayList = [NSArray array];
    }
    self.title = @"Recent List";
    self.tableView.estimatedRowHeight = 44;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem* buttonLeft = self.navigationItem.leftBarButtonItem;
    if (buttonLeft) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = buttonLeft;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecentListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    cell.labelContent.text = [self.arrayList objectAtIndex:indexPath.row];
    cell.backgroundColor = kColorDarkBG;
    cell.labelContent.textColor = UIColor.whiteColor;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.onSelected) {
        self.onSelected(self.arrayList[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

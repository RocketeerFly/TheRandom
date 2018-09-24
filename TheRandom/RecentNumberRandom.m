//
//  RecentNumberRandom.m
//  TheRandom
//
//  Created by Rocketeer on 6/6/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RecentNumberRandom.h"
#import "Constants.h"

@interface RecentNumberRandom ()

@end

@implementation RecentNumberRandom

@synthesize arrRecents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* btnClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearRecent)];
    self.navigationItem.rightBarButtonItem = btnClear;
    tbv.tableFooterView = [UIView new];
    tbv.backgroundColor = kColorDarkBG;
}
-(void)clearRecent{
    if (arrRecents) {
        if ([self.delegate respondsToSelector:@selector(clearRecent)]) {
            [self.delegate clearRecent];
        }
        arrRecents = nil;
        [tbv reloadData];
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrRecents.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"myCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = kColorDarkBG;
        cell.textLabel.textColor = UIColor.whiteColor;
    }
    cell.textLabel.text = [arrRecents objectAtIndex:arrRecents.count-indexPath.row-1];
    return cell;
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

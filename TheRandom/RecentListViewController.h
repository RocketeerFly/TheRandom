//
//  RecentListViewController.h
//  TheRandom
//
//  Created by RocketeerFly on 9/25/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RecentListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void (^onSelected)(NSString *selectedList);
@end

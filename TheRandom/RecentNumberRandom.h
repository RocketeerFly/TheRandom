//
//  RecentNumberRandom.h
//  TheRandom
//
//  Created by Rocketeer on 6/6/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RecentNumberRandom : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray* arrRecents;
    IBOutlet UITableView* tbv;
}
@property (nonatomic,retain) NSArray* arrRecents;
@property(nonatomic,weak) id delegate;
@end

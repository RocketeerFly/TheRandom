//
//  RecentNumberRandom.h
//  TheRandom
//
//  Created by Rocketeer on 6/6/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentNumberRandom : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray* arrRecents;
    IBOutlet UITableView* tbv;
}
@property (nonatomic,retain) NSArray* arrRecents;
@property(nonatomic,weak) id delegate;
@end

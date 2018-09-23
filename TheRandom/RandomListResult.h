//
//  RandomListResult.h
//  TheRandom
//
//  Created by Rocketeer on 6/12/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RandomListResult : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UILabel* lbTip;
    IBOutlet UITableView* tvList;
    NSMutableArray* arrList;
}
@property(nonatomic, retain) NSString* listText;
@end

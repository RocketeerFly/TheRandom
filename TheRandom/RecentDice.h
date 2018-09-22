//
//  RecentDice.h
//  TheRandom
//
//  Created by Rocketeer on 7/7/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentDice : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray* arrRecents;
    IBOutlet UITableView* tbv;
    int heighRow;
    int diceHeight;
    NSArray* arrDiceColor;
}
@property (nonatomic,retain) NSArray* arrRecents;
@property(nonatomic,weak) id delegate;
@end

//
//  ViewController.h
//  TheRandom
//
//  Created by Rocketeer on 5/27/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    IBOutlet UIView* itemRdNumner;
    IBOutlet UIView* itemRdList;
    IBOutlet UIView* itemRdDice;
    IBOutlet UIView* itemRdCard;
    IBOutlet UIImageView* imgView;
    IBOutlet UILabel* lbTheRandom;
    NSArray* listButton;
    NSInteger currentSelect;
}

@end


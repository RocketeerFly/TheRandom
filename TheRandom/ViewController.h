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
    IBOutlet UILabel* lbTheRandom;
    
    IBOutlet UIButton *btnList;
    IBOutlet UIButton *btnCard;
    IBOutlet UIButton *btnDice;
    IBOutlet UIButton *btnNumber;
    
    IBOutlet NSLayoutConstraint *csWidth1;
    IBOutlet NSLayoutConstraint *csWidth2;
    IBOutlet NSLayoutConstraint *csWidth3;
    IBOutlet NSLayoutConstraint *csWidth4;
    IBOutlet NSLayoutConstraint *csHeight1;
    IBOutlet NSLayoutConstraint *csHeight2;
    IBOutlet NSLayoutConstraint *csHeight3;
    IBOutlet NSLayoutConstraint *csHeight4;
    IBOutlet NSLayoutConstraint *csSize1;
    IBOutlet NSLayoutConstraint *csSize2;
    IBOutlet NSLayoutConstraint *csSize3;
    IBOutlet NSLayoutConstraint *csSize4;
    IBOutlet NSLayoutConstraint *csTop;
    NSArray* listButton;
    NSInteger currentSelect;
    bool isSelected;
}

@end


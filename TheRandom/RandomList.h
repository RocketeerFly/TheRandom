//
//  RandomList.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAutoGrowingTextView.h"

@interface RandomList : UIViewController<UITextViewDelegate>{
    IBOutlet AUIAutoGrowingTextView* tfList;
    IBOutlet UIButton* btnRandomize;
    IBOutlet NSLayoutConstraint* constraintTextHeight;
    IBOutlet NSLayoutConstraint* csHeighButtonIphone;
    IBOutlet NSLayoutConstraint* csHeighButtonIpad;
    CGRect previousRect;
}

@end

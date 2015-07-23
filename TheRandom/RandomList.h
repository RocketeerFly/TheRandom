//
//  RandomList.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAutoGrowingTextView.h"
#import <iAd/iAd.h>

@interface RandomList : UIViewController<UITextViewDelegate,ADBannerViewDelegate>{
    IBOutlet AUIAutoGrowingTextView* tfList;
    IBOutlet UIButton* btnRandomize;
    IBOutlet NSLayoutConstraint* constraintTextHeight;
    IBOutlet NSLayoutConstraint* csHeighButtonIphone;
    IBOutlet NSLayoutConstraint* csHeighButtonIpad;
    IBOutlet UILabel* lbTip;
    CGRect previousRect;
    
    ADBannerView* bannerView;
    bool isBannerIsVisible;
}

@end

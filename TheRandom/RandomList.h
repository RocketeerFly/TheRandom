//
//  RandomList.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAutoGrowingTextView.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BaseViewController.h"
#import "RecentListViewController.h"

@interface RandomList : BaseViewController<UITextViewDelegate,GADBannerViewDelegate>{
    IBOutlet AUIAutoGrowingTextView* tfList;
    IBOutlet UIButton* btnRandomize;
    IBOutlet NSLayoutConstraint* constraintTextHeight;
    IBOutlet NSLayoutConstraint* csHeighButtonIphone;
    IBOutlet NSLayoutConstraint* csHeighButtonIpad;
    IBOutlet UILabel* lbTip;
    __weak IBOutlet UILabel *labelCount;
    CGRect previousRect;
    
    bool isBannerIsVisible;
    BOOL isNeedFillRecentList;
}

@end

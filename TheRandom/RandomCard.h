//
//  RandomCard.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "BaseViewController.h"

@interface RandomCard : BaseViewController<GADBannerViewDelegate>{
    
    IBOutlet UIImageView *ivCardTop;
    IBOutlet UIImageView *ivCardBottom;
    IBOutlet UIScrollView *svCardOpened;
    IBOutlet UILabel* lbNumCard;
    IBOutlet UILabel *lbTip;
    NSMutableArray* arrCarOpened;
    CGPoint startPoint;
    int cardThumbSize;
    int cardSpace;
    bool isOpeningCard;
    bool isOpenedCard;
    CGSize sizeListAtInit;
    UIImage* imgCarBack;
    bool isBannerIsVisible;
}

@end

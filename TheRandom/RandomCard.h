//
//  RandomCard.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface RandomCard : UIViewController<ADBannerViewDelegate>{
    
    IBOutlet UIImageView *ivCardTop;
    IBOutlet UIImageView *ivCardBottom;
    IBOutlet UIScrollView *svCardOpened;
    IBOutlet UILabel* lbNumCard;
    NSMutableArray* arrCarOpened;
    CGPoint startPoint;
    int cardThumbSize;
    int cardSpace;
    bool isOpeningCard;
    bool isOpenedCard;
    CGSize sizeListAtInit;
    UIImage* imgCarBack;
    
    ADBannerView* bannerView;
    bool isBannerIsVisible;
}

@end

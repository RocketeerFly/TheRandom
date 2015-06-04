//
//  RandomNumber.h
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomNumber : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    IBOutlet UITextField* tfMin;
    IBOutlet UITextField* tfMax;
    IBOutlet UILabel* lbResult;
    IBOutlet UITextField* tfRecent;
    NSArray* arrColor;
    int currentColorIndex;
}

@end

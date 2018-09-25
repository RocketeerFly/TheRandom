//
//  RandomCard.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomCard.h"
#import <QuartzCore/QuartzCore.h>

#define RATE_W_H_CARD 1.4035f

@interface RandomCard ()

@end

@implementation RandomCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrCarOpened = [[NSMutableArray alloc] init];
    
    //add card shadow
    ivCardTop.layer.shadowColor = [UIColor grayColor].CGColor;
    ivCardTop.layer.shadowOffset = CGSizeMake(2, 2);
    ivCardTop.layer.shadowOpacity = 0.9f;
    ivCardTop.layer.shadowRadius = 4;
    
    ivCardBottom.layer.shadowColor = [UIColor grayColor].CGColor;
    ivCardBottom.layer.shadowOffset = CGSizeMake(2, 2);
    ivCardBottom.layer.shadowOpacity = 0.9f;
    ivCardBottom.layer.shadowRadius = 4;
    
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        cardThumbSize = 57;
        cardSpace = 10;
        lbNumCard.font = [UIFont systemFontOfSize:18];
    }else{
        cardThumbSize = 50;
        cardSpace = 10;
    }
    
    UITapGestureRecognizer* reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCard)];
    [ivCardTop addGestureRecognizer:reg];
    
    //add reset button
    UIBarButtonItem* btnReset = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(resetCards)];
    self.navigationItem.rightBarButtonItem = btnReset;
    
    [self updateNumCardLabel];
}
-(void)resetCards{
    if (!isOpeningCard) {
        for (UIView* view in svCardOpened.subviews) {
            if (view.tag>0) {
                [view removeFromSuperview];
            }
        }
        [svCardOpened setContentSize:sizeListAtInit];
        [arrCarOpened removeAllObjects];
        
        if (isOpenedCard) {
            //Change image top card
            ivCardTop.image = [UIImage imageNamed:@"card_back_1.png"];
            isOpenedCard = NO;
        }
        
        [self updateNumCardLabel];
    }
}
-(void)updateNumCardLabel{
    lbNumCard.text = [NSString stringWithFormat:@"Cards: %d",52-(int)arrCarOpened.count];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if (!bannerAdmobView) {
        CGPoint orgin = CGPointMake(0.0,
                                    self.view.frame.size.height -
                                    CGSizeFromGADAdSize(
                                                        kGADAdSizeSmartBannerPortrait).height);
        bannerAdmobView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:orgin];
        bannerAdmobView.adUnitID = @"ca-app-pub-4565726969790499/2040556564";
        bannerAdmobView.adSize = kGADAdSizeSmartBannerPortrait;
        bannerAdmobView.rootViewController = self;
        bannerAdmobView.delegate = self;
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        bannerAdmobView.frame = CGRectMake(0, screenSize.height - bannerAdmobView.frame.size.height, screenSize.width, bannerAdmobView.frame.size.height);
        
        [self.view addSubview:bannerAdmobView];
        
        GADRequest* request = [[GADRequest alloc] init];
        [bannerAdmobView loadRequest:request];
    }
    [svCardOpened setContentSize:CGSizeMake(svCardOpened.frame.size.width, svCardOpened.frame.size.height)];
    sizeListAtInit = svCardOpened.contentSize;
    [NSUserDefaults.standardUserDefaults setObject:@"3" forKey:@"last_tab_index"];
}
-(void)stopCardAnim{
    isOpeningCard = NO;
    isOpenedCard = YES;
}
-(void)didAddToHistory:(id)sender{
    isOpeningCard = NO;
    isOpenedCard = NO;
    UIImageView* imgView = (UIImageView*)[self.view viewWithTag:arrCarOpened.count];
    CGPoint newPoint = [svCardOpened convertPoint:imgView.frame.origin fromView:self.view];
    imgView.frame = CGRectMake(newPoint.x, newPoint.y, imgView.frame.size.width, imgView.frame.size.height);
    [imgView removeFromSuperview];
    [svCardOpened addSubview:imgView];
    
    [self updateNumCardLabel];
    [svCardOpened setScrollEnabled:YES];
}
-(void)selectCard{
    if (!lbTip.isHidden) {
        [lbTip setHidden:YES];
        [lbTip removeFromSuperview];
    }
    if (arrCarOpened.count>=52 || isOpenedCard || isOpeningCard) {
        //no card anymore
        if (arrCarOpened.count>=52 && !isOpenedCard) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"No more card in set! Please press Clear to start new game" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    isOpeningCard = YES;
    //random card
    int cardValue;
    while (true) {
        cardValue = arc4random()%52 +1;
        if (![arrCarOpened containsObject:[NSString stringWithFormat:@"%d",cardValue]]) {
            break;
        }
    }
    [arrCarOpened addObject:[NSString stringWithFormat:@"%d",cardValue]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopCardAnim)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:ivCardTop cache:YES];
    [ivCardTop setImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d",cardValue]]];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isOpenedCard && !isOpeningCard) {
        
        //scroll to left
        [svCardOpened setScrollEnabled:NO];
        [svCardOpened setContentOffset:CGPointZero animated:NO];
        
        
        //Clone new card
        UIImageView* imgview = [[UIImageView alloc] init];
        imgview.frame = ivCardTop.frame;
        imgview.image = ivCardTop.image;
        imgview.tag = arrCarOpened.count;
        [self.view addSubview:imgview];
        
        //Change image top card
        ivCardTop.image = [UIImage imageNamed:@"card_back_1.png"];
        
        //calculate the position place card
        int widthAllCell = (int)arrCarOpened.count*(cardThumbSize+cardSpace);
        if ((svCardOpened.contentSize.width - widthAllCell)<=0) {
            [svCardOpened setContentSize:CGSizeMake(svCardOpened.contentSize.width+cardThumbSize+cardSpace, svCardOpened.contentSize.height)];
            for (UIView* view in svCardOpened.subviews) {
                CGRect rectOld = view.frame;
                view.frame = CGRectMake(rectOld.origin.x+cardThumbSize+cardSpace, rectOld.origin.y, rectOld.size.width, rectOld.size.height);
            }
        }
        CGRect rect = CGRectMake(svCardOpened.contentSize.width - widthAllCell, cardSpace, cardThumbSize, cardThumbSize*RATE_W_H_CARD);
        CGPoint point = [self.view convertPoint:rect.origin fromView:svCardOpened];
        rect.origin = point;
        
        isOpeningCard = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didAddToHistory:)];
        imgview.frame = rect;
        [UIView commitAnimations];
        
    }
//    }else{
//        UITouch* touch = [touches anyObject];
//        UIView* view = touch.view;
//        if (view.tag==1) {//touch at card
//            [self selectCard];
//        }
//    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

//
//  RandomCard.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomCard.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
@import FirebaseAnalytics;

#define RATE_W_H_CARD 1.4035f

@interface RandomCard ()
@property (weak, nonatomic) IBOutlet GADBannerView *viewAds;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBannerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightButtonCloseAds;
@property (weak, nonatomic) IBOutlet UIButton *buttonCloseAds;

@end

@implementation RandomCard

- (void)viewDidLoad {
    [super viewDidLoad];
    [_buttonCloseAds setHidden:YES];
    // Do any additional setup after loading the view.
    _viewAds.rootViewController = self;
    _viewAds.adUnitID = @"ca-app-pub-4565726969790499/8514822338";
    _viewAds.adSize = kGADAdSizeBanner;
    _viewAds.delegate = self;
    
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
    
    if ([self areAdsRemoved]) {
        _constraintBannerHeight.constant = 0;
        _constraintHeightButtonCloseAds.constant = 0;
    }
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hideAdsBanner) name:@"areAdsRemoved" object:nil];
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
    GADRequest* request = [GADRequest request];
    request.testDevices = @[@"065021724f61ad8f1506dac2139b750a6079b804"];
    [self.viewAds loadRequest:request];
    [svCardOpened setContentSize:CGSizeMake(svCardOpened.frame.size.width, svCardOpened.frame.size.height)];
    sizeListAtInit = svCardOpened.contentSize;
    [FIRAnalytics logEventWithName:@"ShowScreen_Card" parameters:nil];
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

-(IBAction)onPressCloseAds {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    vc.isPopup = YES;
    [FIRAnalytics logEventWithName:@"PressCloseAds_Card" parameters:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)hideAdsBanner {
    _constraintBannerHeight.constant = 0;
    _constraintHeightButtonCloseAds.constant = 0;
    [self.view layoutSubviews];
}
-(void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [_buttonCloseAds setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buttonCloseAds:(id)sender {
}
@end

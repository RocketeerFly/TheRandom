//
//  RandomNumber.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomNumber.h"
#import "RecentNumberRandom.h"
#define MAXLENGTH 9
#define INTERVAL_TICK 0.001
#define TIME_RANDOM 0.05
#define NUM_RECENT 10
@interface RandomNumber ()

@end

@implementation RandomNumber

static NSString* placeholder = @"Press and release button or shake to start";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrColor = [NSArray arrayWithObjects:
                [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:152.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:0.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:74.0f/255.0f green:134.0f/255.0f blue:232.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:204.0f/255.0f green:65.0f/255.0f blue:37.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:106.0f/255.0f green:168.0f/255.0f blue:79.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:166.0f/255.0f green:77.0f/255.0f blue:121.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:28.0f/255.0f green:69.0f/255.0f blue:135.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:182.0f/255.0f green:215.0f/255.0f blue:168.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:213.0f/255.0f green:166.0f/255.0f blue:189.0f/255.0f alpha:1.0],
                [UIColor colorWithRed:38.0f/255.0f green:232.0f/255.0f blue:89.0f/255.0f alpha:1.0]
                , nil];
    currentColorIndex = 0;
    lbResult.textColor = [arrColor objectAtIndex:currentColorIndex];
    lbResult.adjustsFontSizeToFitWidth = YES;
    lbResult.contentMode = UIViewContentModeCenter;
    countTimer = 0;
    isRolling = NO;
    isHoldButtonMode = NO;
    isIphone = YES;
    isNoRepeat = NO;
    isLoaded = NO;
    arrRecent = [[NSMutableArray alloc] init];
    float heightButton = csHeighButtonIphone.constant;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        btnRecent.titleLabel.font = [UIFont systemFontOfSize:18];
        btnRandomize.titleLabel.font = [UIFont systemFontOfSize:20];
        heightButton = csHeighButtonIpad.constant;
        isIphone = NO;
    }else{
        //iphone 6+
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height==736.0f) {
            tfMin.layer.borderColor = [UIColor lightGrayColor].CGColor;
            tfMin.layer.borderWidth = 1.0f;
            tfMin.layer.cornerRadius = 8;
            tfMax.layer.borderColor = [UIColor lightGrayColor].CGColor;
            tfMax.layer.borderWidth = 1.0f;
            tfMax.layer.cornerRadius = 8;
        }
    }
    [btnRecent setTitle:placeholder forState:UIControlStateNormal];
    btnRecent.enabled = NO;
    
    //border randomize button
    btnRandomize.layer.borderWidth = 1;
    btnRandomize.layer.borderColor = [UIColor colorWithRed:26/255.0f green:203/255.0f blue:102/255.0f alpha:1.0f].CGColor;
    btnRandomize.layer.cornerRadius = heightButton/2;
    [btnRandomize setTitleColor:[UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [btnRandomize setTitleColor:[UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    //btn random events
    [btnRandomize addTarget:self action:@selector(buttonOffTouch) forControlEvents:UIControlEventTouchCancel];
    [btnRandomize addTarget:self action:@selector(buttonOffTouch) forControlEvents:UIControlEventTouchDragExit];
    [btnRandomize addTarget:self action:@selector(buttonOnTouch) forControlEvents:UIControlEventTouchDown];
    [btnRandomize addTarget:self action:@selector(buttonOffTouch) forControlEvents:UIControlEventTouchUpInside];
    [btnRandomize addTarget:self action:@selector(buttonOnTouch) forControlEvents:UIControlEventTouchDragEnter];
    
    //add reset button
    UIBarButtonItem* btnReset = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetRandom)];
    self.navigationItem.rightBarButtonItem = btnReset;
    
    //load history input
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* min = [userDef valueForKey:@"rand_num_min"];
    NSString* max = [userDef valueForKey:@"rand_num_max"];
    if (min && max) {
        @try {
            tfMin.text=min;
            tfMax.text=max;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        lbDefault.hidden = YES;
    }
    //use observer to hanele when app will close
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}
-(void)buttonOnTouch{
    btnRandomize.layer.borderColor = [UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1.0f].CGColor;
    btnRandomize.titleLabel.alpha = 1.0f;
}
-(void)buttonOffTouch{
    btnRandomize.layer.borderColor = [UIColor colorWithRed:26/255.0f green:203/255.0f blue:102/255.0f alpha:1.0f].CGColor;
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated{
    //show banner iAds
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
    isLoaded = YES;
    [self.view layoutSubviews];
}
- (void) viewWillLayoutSubviews{
    if (!isLoaded) {
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 480) {
            csResultCenterY.constant = 0;
            csMaxCenterY.constant = 90;
            csMinCenterY.constant = 90;
            NSLog(@"layout");
        }
    }
}
- (IBAction)changeRepeatSetting:(id)sender {
    isNoRepeat = !isNoRepeat;
    if(isNoRepeat){
        [btnNoRepeats setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
        indexBeginNotRepeat = (int)arrRecent.count;
    }else{
        [btnNoRepeats setImage:[UIImage imageNamed:@"ico_not_check"] forState:UIControlStateNormal];
    }
    NSLog(@"repeat: %@ index:%d", isNoRepeat? @"YES":@"NO",indexBeginNotRepeat);
}

-(void)resetRandom{
    if (isRolling) {
        return;
    }
    tfMax.text=@"";
    tfMin.text=@"";
    lbDefault.hidden = NO;
    lbResult.text=@"?";
    indexBeginNotRepeat = 0;
    [arrRecent removeAllObjects];
    currentColorIndex = 0;
    [btnRecent setTitle:placeholder forState:UIControlStateNormal];
    btnRecent.enabled = NO;
    lbResult.textColor = [arrColor objectAtIndex:0];
}
-(void)clearRecent{
    [arrRecent removeAllObjects];
    [btnRecent setTitle:placeholder forState:UIControlStateNormal];
    btnRecent.enabled = NO;
}
-(IBAction)tapRandomizeButton:(id)sender{
    [self motionBegan:UIEventSubtypeMotionShake withEvent:nil];
}
-(IBAction)beginRandom:(id)sender{
    [self motionBegan:UIEventSubtypeMotionShake withEvent:nil];
    isHoldButtonMode = YES;
}
-(IBAction)endRandom:(id)sender{
    //check stop
    float time = INTERVAL_TICK*countTimer;
    float maxTime = (float)TIME_RANDOM;
    
    //stop if over max time
    if(time>=maxTime){
        //stop
        [self stopRandom];
        return;
    }else{
        isHoldButtonMode = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([tfMin isFirstResponder]) {
        [tfMin resignFirstResponder];
    }else{
        if ([tfMax isFirstResponder]) {
            [tfMax resignFirstResponder];
        }else{
            if (isRolling) {
                return;
            }
            //check touch inside result to copy
            UITouch* touch = [touches anyObject];
            CGRect frame = lbResult.frame;
            CGSize size = [lbResult sizeThatFits:frame.size];
            CGRect realRect = CGRectMake((frame.size.width-size.width)/2,
                                         (frame.size.height-size.height)/2,
                                         size.width, size.height);
            if (CGRectContainsPoint(realRect, [touch locationInView:lbResult]) && ![lbResult.text isEqualToString:@"?"]) {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy number", nil];
                [actionSheet showInView:self.view];
            }
        }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        UIPasteboard* pasetBoard = [UIPasteboard generalPasteboard];
        pasetBoard.string = lbResult.text;
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        
        //cancel if it's rolling
        if (isRolling) {
            return;
        }
        
        //validate
        if (![self isNumeric:tfMin.text]) {
            UIAlertView* aler = [[UIAlertView alloc] initWithTitle:nil message:@"Please input numeric characters only" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [aler show];
            return;
        }
        if (![self isNumeric:tfMax.text]) {
            UIAlertView* aler = [[UIAlertView alloc] initWithTitle:nil message:@"Please input numeric characters only" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [aler show];
            return;
        }
        
        if (([tfMax.text isEqualToString:@""] || [tfMin.text isEqualToString:@""]) && !([tfMin.text isEqualToString:@""] && [tfMax.text isEqualToString:@""])) {
            return;
        }
        
        [self starRandom];
    }
}
-(void)doRandom{
    //hide default
    if (!lbDefault.isHidden) {
        [lbDefault setHidden:YES];
    }
    
    //check stop
    float time = INTERVAL_TICK*countTimer;
    float maxTime = (float)TIME_RANDOM;
    
    //stop if over max time
    if(time>=maxTime && !isHoldButtonMode){
        //stop
        [self stopRandom];
        return;
    }
    countTimer++;
    
    //[lbResult sizeToFit];
    //set up min, max
    int min,max;
    min = tfMin.text.intValue;
    max = tfMax.text.intValue;
    if (min==max && min==0) {
        min=0;
        max = 99;
        if ([tfMin.text isEqualToString:@""] && [tfMax.text isEqualToString:@""]) {
            tfMin.text = @"0";
            tfMax.text = @"99";
            lbDefault.hidden = YES;
        }
    }
    if (min>max) {
        int tmp = min;
        min = max;
        max = tmp;
    }
    
    int randNumber = [self generateRandomNumber:min max:max];
    
    //show number
    lbResult.text = [NSString stringWithFormat:@"%d",randNumber];
    
    while (true) {
        int randomColorIndex = rand()%arrColor.count;
        if (randomColorIndex!=currentColorIndex) {
            currentColorIndex = randomColorIndex;
            break;
        }
    }
    
    lbResult.textColor = (UIColor*)[arrColor objectAtIndex:currentColorIndex];
}
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}
-(int)generateRandomNumber:(int)min max:(int)max{
    int distance = max-min+1;
    int result = min + rand()%distance;
    
    //save min,max
    minInput = min;
    maxInput = max;
    
    return result;
}
-(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (![self isNumeric:tfMin.text]) {
            [tfMin becomeFirstResponder];
        }else{
            [tfMax becomeFirstResponder];
        }
    }
}
-(void)starRandom{
    countTimer = 0;
    isRolling = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL_TICK target:self selector:@selector(doRandom) userInfo:nil repeats:YES];
}
-(void)stopRandom{
    if (timer) {
        [timer invalidate];
        timer = nil;
        
        //check the same color
        if (currentColorIndex == oldColorIndex) {
            while (true) {
                int randomColorIndex = rand()%arrColor.count;
                if (randomColorIndex!=currentColorIndex) {
                    currentColorIndex = randomColorIndex;
                    break;
                }
            }
            lbResult.textColor = (UIColor*)[arrColor objectAtIndex:currentColorIndex];
        }
        
        oldColorIndex = currentColorIndex;
        
        //random another number if no repeats is YES
        if (isNoRepeat) {
            if (indexBeginNotRepeat == arrRecent.count) {
                NSLog(@"Do nothing");
            }else{
                int distance = (int)maxInput - (int)minInput + 1;
                NSArray* arrNotRepeat = [arrRecent subarrayWithRange:NSMakeRange(indexBeginNotRepeat, arrRecent.count-indexBeginNotRepeat)];
                
                if (arrNotRepeat.count>0) {
                    NSString* stringNumber = lbResult.text;
                    while (true) {
                        if ([arrNotRepeat indexOfObject:stringNumber] == NSNotFound) {
                            break;
                        }
                        stringNumber = [NSString stringWithFormat:@"%d",[self generateRandomNumber:(int)minInput max:(int)maxInput]];
                    }
                    lbResult.text = stringNumber;
                    
                    if (arrNotRepeat.count == (distance-1)) {
                        //alert: You generated all numbers in between min and max. You must reset to start over
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"You generated all numbers in between min and max. We gonna start over again"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        indexBeginNotRepeat = (int)arrRecent.count+1;
                    }
                }
            }
        }
        
        //add to recent
        [arrRecent addObject:lbResult.text];
        [self updateRecent];
        isRolling  = NO;
        isHoldButtonMode = NO;
    }
}
-(void)updateRecent{
    btnRecent.enabled = YES;
    int size = (int)arrRecent.count;
    int bottom = 0;
    if (size>20) {
        bottom = size-20;
    }
    NSString* recentStr=@"Recent: ";
    for (int i=size-1; i>=bottom; i--) {
        recentStr = [recentStr stringByAppendingFormat:@"%@, ",(NSString*)[arrRecent objectAtIndex:i]];
    }
    recentStr = [recentStr substringToIndex:recentStr.length-2];
    [btnRecent setTitle:recentStr forState:UIControlStateNormal];
}
-(IBAction)showFullRecent:(id)sender{
    [self performSegueWithIdentifier:@"showRecentFull" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RecentNumberRandom* detailView = segue.destinationViewController;
    detailView.arrRecents = arrRecent;
    detailView.delegate = self;
}
-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (!parent) {
        [self saveUserInput];
    }
}
-(void)applicationWillTerminate{
    [self saveUserInput];
}
-(void)saveUserInput{
    //save user
    if (minInput>0 || maxInput>0) {
        NSUserDefaults* userdef = [NSUserDefaults standardUserDefaults];
        [userdef setValue:[NSString stringWithFormat:@"%ld",(long)minInput] forKey:@"rand_num_min"];
        [userdef setValue:[NSString stringWithFormat:@"%ld",(long)maxInput] forKey:@"rand_num_max"];
        [userdef synchronize];
    }

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

//
//  RandomList.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomList.h"
#import "RandomListResult.h"

@interface RandomList ()
@end

@implementation RandomList

static NSString *const placeholder = @"Please input list";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int radius = 10;
    //update height
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        tfList.font = [UIFont systemFontOfSize:20];
        btnRandomize.titleLabel.font = [UIFont systemFontOfSize:20];
        radius = 14;
        lbTip.font = [UIFont systemFontOfSize:18];
    }
    
    tfList.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfList.layer.borderWidth = 1;
    tfList.layer.cornerRadius = radius;
    tfList.contentMode = UIViewContentModeTopLeft;
    [tfList setContentOffset:CGPointZero];
    
    CGSize size = [tfList sizeThatFits:CGSizeMake(tfList.frame.size.width, INT_MAX)];
    constraintTextHeight.constant = size.height;
    tfList.minHeight = size.height;
    tfList.maxHeight = 200;
    
    //add observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:@"UIKeyboardDidHideNotification" object:nil];
    
    float heightButton = csHeighButtonIphone.constant;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        btnRandomize.titleLabel.font = [UIFont systemFontOfSize:20];
        heightButton = csHeighButtonIpad.constant;
    }
    
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
}
-(void)viewDidAppear:(BOOL)animated{
    if (!bannerView) {
        bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        bannerView.delegate = self;
        bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
}
-(void)buttonOnTouch{
    btnRandomize.layer.borderColor = [UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1.0f].CGColor;
    btnRandomize.titleLabel.alpha = 1.0f;
}
-(void)buttonOffTouch{
    btnRandomize.layer.borderColor = [UIColor colorWithRed:26/255.0f green:203/255.0f blue:102/255.0f alpha:1.0f].CGColor;
}
-(void)keyboardWillShow:(NSNotification*)note{
    NSDictionary* dic =[note userInfo];
    CGSize size = [[dic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int maxheight = [UIScreen mainScreen].bounds.size.height-tfList.frame.origin.y-size.height-10;
    tfList.maxHeight = maxheight;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
-(void)keyboardDidHide:(NSNotification*)note{
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([tfList isFirstResponder]) {
        [self hideDoneButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [tfList setContentOffset:CGPointZero];
    if ([self color:textView.textColor isEqualToColor:[UIColor lightGrayColor] withTolerance:0.1f]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [self showDoneButton];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
            NSArray* arrStr = [textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSString* lastLine = [arrStr lastObject];
        if ([lastLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
            return NO;
        }
    }
    return YES;
}
-(void)showDoneButton{
    if (!self.navigationItem.rightBarButtonItem) {
        UINavigationItem* topItem = self.navigationItem;
        UIBarButtonItem* tbnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideDoneButton)];
        topItem.rightBarButtonItem = tbnDone;
    }
}
-(void)hideDoneButton{
    [tfList resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    if ([tfList.text isEqualToString:@""]) {
        tfList.textColor = [UIColor lightGrayColor];
        tfList.text = placeholder;
    }
}
-(IBAction)proceed:(id)sender{
    if (![tfList.text isEqualToString:placeholder]) {
        [self performSegueWithIdentifier:@"showListRandom" sender:self];
    }
}

//banner delegates
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (!isBannerIsVisible) {
        if (!bannerView.superview) {
            CGRect rect = bannerView.frame;
            rect.origin.x = 0;
            rect.origin.y = self.view.frame.size.height;
            bannerView.frame = rect;
            [self.view addSubview:bannerView];
            
            [UIView animateWithDuration:0.2f animations:^{
                bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
            }];
            
        }
        isBannerIsVisible = YES;
    }
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RandomListResult* destView = segue.destinationViewController;
    destView.listText = tfList.text;
}

- (BOOL)color:(UIColor *)color1
isEqualToColor:(UIColor *)color2
withTolerance:(CGFloat)tolerance {
    
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;
}
@end

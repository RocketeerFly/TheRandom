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

static NSString* placeholder = @"Shake or tap the button to start";

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
    arrRecent = [[NSMutableArray alloc] init];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        btnRecent.titleLabel.font = [UIFont systemFontOfSize:18];
        btnRandomize.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    [btnRecent setTitle:placeholder forState:UIControlStateNormal];
    btnRecent.enabled = NO;
//    btnRandomize.layer.borderColor = [UIColor grayColor].CGColor;
//    btnRandomize.layer.borderWidth = 1;
//    btnRandomize.layer.cornerRadius = 15;
    
    //add reset button
    UIBarButtonItem* btnReset = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetRandom)];
    self.navigationItem.rightBarButtonItem = btnReset;
}
-(void)resetRandom{
    if (isRolling) {
        return;
    }
    NSLog(@"Reset");
    tfMax.text=@"";
    tfMin.text=@"";
    lbResult.text=@"?";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([tfMin isFirstResponder]) {
        [tfMin resignFirstResponder];
    }else{
        if ([tfMax isFirstResponder]) {
            [tfMax resignFirstResponder];
        }else{
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
    
    //check stop
    float time = INTERVAL_TICK*countTimer;
    float maxTime = (float)TIME_RANDOM;
    if(time>=maxTime){
        //stop
        [self stopRandom];
        return;
    }
    countTimer++;
    lbResult.text = [NSString stringWithFormat:@"%ld",(long)[self generateRandomNumber]];
    //[lbResult sizeToFit];
    
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
-(NSInteger)generateRandomNumber{
    int min,max;
    min = tfMin.text.intValue;
    max = tfMax.text.intValue;
    if (min==max && min==0) {
        min=0;
        max = 99;
        if ([tfMin.text isEqualToString:@""] && [tfMax.text isEqualToString:@""]) {
            tfMin.text = @"0";
            tfMax.text = @"99";
        }
    }
    if (min>max) {
        int tmp = min;
        min = max;
        max = tmp;
    }
    int distance = max-min+1;
    int result = min + rand()%distance;
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
        
        //add to recent
        [arrRecent addObject:lbResult.text];
        [self updateRecent];
        isRolling  = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

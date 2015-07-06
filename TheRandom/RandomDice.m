//
//  RandomDice.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomDice.h"

@interface RandomDice ()

@end

#define DICE_ROLL_DURATION 0.5f
#define DICE_SIZE_IPHONE 60
#define DICE_SIZE_IPAD 120
#define DICE_SIZE_INTERVAL 5
#define DICE_RANGE_INTERVAL 25
#define DICE_MAX 5
#define BTN_IMG_INSET 10
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define colorTintButton [UIColor grayColor]
#define colorSelectedButton [UIColor colorWithRed:14/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f]
#define TIP_MESSAGE @"Select number of dices and then touch the screen \n or shake your %@"
#define TIP_MESSAGE_FIRST @"Touch the screen or shake your %@ to roll"

@implementation RandomDice

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"ColorPicker" owner:self options:nil];
    // Do any additional setup after loading the view.
    arrDices = [[NSMutableArray alloc] init];
    arrPosDices = [[NSMutableArray alloc] init];
    
    //Dice Colors
    arrDiceColor = [NSArray arrayWithObjects:
                    [UIColor colorWithRed:0 green:162/255.0f blue:232/255.0f alpha:1.0f],
                    [UIColor colorWithRed:93/255.0f green:193/255.0f blue:89/255.0f alpha:1.0f],
                    [UIColor colorWithRed:252/255.0f green:76/255.0f blue:84/255.0f alpha:1.0f] ,
                    [UIColor colorWithRed:137/255.0f green:0/255.0f blue:44/255.0f alpha:1.0f],
                    [UIColor colorWithRed:67/255.0f green:67/255.0f blue:67/255.0f alpha:1.0f],
                    [UIColor colorWithRed:255/255.0f green:102/255.0f blue:255/255.0f alpha:1.0f],nil];
    
    
    UIBarButtonItem* btnRecent = [[UIBarButtonItem alloc] initWithTitle:@"Recent" style:UIBarButtonItemStyleBordered target:self action:@selector(showRecent)];
    self.navigationItem.rightBarButtonItem = btnRecent;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float heightButton = csHeighButtonIphone.constant;
    float heightBtnNumber = csHeighNumberIphone.constant;
    float extractWidth = 2;
    float cornerRadiusBtnColor = 22.5f;
    isLoadedAccessoryAlert = NO;
    //calculate size of dice
    diceSize = (screenSize.width/100.0)*10*2.5;
    
    //change size of lable for Ipad device
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        btn1.titleLabel.font = [UIFont systemFontOfSize:20];
        btn2.titleLabel.font = [UIFont systemFontOfSize:20];
        btn3.titleLabel.font = [UIFont systemFontOfSize:20];
        lbNumDices.font = [UIFont systemFontOfSize:20];
        heightBtnNumber = csHeighNumberButtonIpad.constant;
         heightButton = csHeighButtonIpad.constant;
        diceSize = DICE_SIZE_IPAD;
        extractWidth = 3;
        cornerRadiusBtnColor = 27.5;
    }
    //btn color picker
    btnColor.layer.cornerRadius = cornerRadiusBtnColor;
    btnColor.layer.shadowColor = [UIColor grayColor].CGColor;
    btnColor.layer.shadowOffset = CGSizeMake(1, 1);
    btnColor.layer.shadowOpacity = 0.9f;
    btnColor.layer.shadowRadius = 0;
    
    //btn choose num dices
    UIBezierPath* path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, heightBtnNumber, heightBtnNumber) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft cornerRadii:CGSizeMake(heightBtnNumber/3, heightBtnNumber/3)];
    CAShapeLayer* shape1 = [[CAShapeLayer alloc] init];
    shape1.lineWidth=1;
    shape1.strokeColor =[UIColor grayColor].CGColor;
    shape1.fillColor = [UIColor clearColor].CGColor;
    shape1.path = path1.CGPath;
    [btn1.layer addSublayer:shape1];
    [btn1 setTitleColor:colorSelectedButton forState:UIControlStateSelected];
    [btn1 setTitleColor:colorSelectedButton forState:UIControlStateHighlighted];
    
    CALayer* line1 = [CALayer layer];
    line1.frame = CGRectMake(0,-0.5, heightBtnNumber, 1);
    line1.borderColor = [UIColor grayColor].CGColor;
    line1.borderWidth = 1;
    CALayer* line2 = [CALayer layer];
    line2.frame = CGRectMake(heightBtnNumber, heightBtnNumber-0.5, heightBtnNumber, 1);
    line2.borderColor = [UIColor grayColor].CGColor;
    line2.borderWidth = 1;
    [btn2.layer addSublayer:line1];
    [btn1.layer addSublayer:line2];
    
    [btn2 setTitleColor:colorSelectedButton forState:UIControlStateSelected];
    [btn2 setTitleColor:colorSelectedButton forState:UIControlStateHighlighted];

    UIBezierPath* path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, heightBtnNumber, heightBtnNumber) byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake(heightBtnNumber/3, heightBtnNumber/3)];
    CAShapeLayer* shape3 = [[CAShapeLayer alloc] init];
    shape3.lineWidth=1;
    shape3.strokeColor =[UIColor grayColor].CGColor;
    shape3.fillColor = [UIColor clearColor].CGColor;
    shape3.path = path3.CGPath;
    [btn3.layer addSublayer:shape3];
    
    [btn3 setTitleColor:colorSelectedButton forState:UIControlStateSelected];
    [btn3 setTitleColor:colorSelectedButton forState:UIControlStateHighlighted];
    
    //calculate the area which place dices
    int rectY = screenSize.height*3/10;
    int rectWidth = screenSize.width - extractWidth*diceSize;
    int rectHeight = screenSize.height*0.5;
    diceArea = CGRectMake(diceSize*extractWidth/2, rectY, rectWidth, rectHeight);
    
    UIView* area = [[UIView alloc] initWithFrame:diceArea];
    area.backgroundColor = [UIColor grayColor];
    area.tag = 99;
    //[self.view addSubview:area];
    
    //calcuate the point to place dices at the begin
    pointPlaceDice = CGPointMake(screenSize.width+1, (screenSize.height-diceSize)/2);
    
    //load the last selected num dice
    numDice = 3;
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* numD = [userDef valueForKey:@"rand_dice_num"];
    if (numD) {
        numDice = numD.intValue;
    }
    //set default amount of dices
    [self chooseNumDices:nil];
    
    [self.view updateConstraints];
    
    //load default sound setting
    NSString* soundDice = [userDef valueForKey:@"rand_dice_sound"];
    if (soundDice) {
        if (soundDice.intValue==1) {
            isPlaySound = YES;
        }else{
            isPlaySound = NO;
        }
    }else{
        isPlaySound = YES;
    }
    isPlaySound = !isPlaySound;
    [self changeSound:nil];
    btnSound.imageEdgeInsets = UIEdgeInsetsMake(BTN_IMG_INSET, BTN_IMG_INSET, BTN_IMG_INSET, BTN_IMG_INSET);
    
    //dice's color default
    NSString* colorIndexSaved = [userDef valueForKey:@"rand_dice_color"];
    colorDiceIndex = 0;
    if (colorDiceIndex) {
        colorDiceIndex = colorIndexSaved.intValue;
    }
    diceColor = [arrDiceColor objectAtIndex:colorDiceIndex];
    
    //use observer to hanele when app will close
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
    //load sound
    NSString* url = [[NSBundle mainBundle] pathForResource:@"roll_dice" ofType:@"caf"];
    NSURL *soundURL = [NSURL URLWithString:url];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
}
-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)showRecent{
    
}
-(IBAction)chooseNumDices:(id)sender{
    if (sender) {
        UIButton* btn = (UIButton*)sender;
        NSInteger tag = btn.tag;
        if (tag == 1) {
            if (numDice>1) {
                numDice--;
                diceSize+=DICE_SIZE_INTERVAL;
                diceArea.origin.y = diceArea.origin.y+DICE_RANGE_INTERVAL;
                diceArea.size.height = diceArea.size.height - 2*DICE_RANGE_INTERVAL;
                [btn2 setTitle:[NSString stringWithFormat:@"%d",numDice] forState:UIControlStateNormal];
            }
        }else{
            if (tag == 2) {
                if (numDice<DICE_MAX) {
                    numDice++;
                    diceSize-=DICE_SIZE_INTERVAL;
                    diceArea.origin.y = diceArea.origin.y-DICE_RANGE_INTERVAL;
                    diceArea.size.height = diceArea.size.height + 2*DICE_RANGE_INTERVAL;
                    [btn2 setTitle:[NSString stringWithFormat:@"%d",numDice] forState:UIControlStateNormal];
                }
            }
        }
    }else{
        [btn2 setTitle:[NSString stringWithFormat:@"%d",numDice] forState:UIControlStateNormal];
        diceSize = diceSize - (numDice-1)*DICE_SIZE_INTERVAL;
        float heightLoose =(DICE_MAX-numDice)*DICE_RANGE_INTERVAL;
        diceArea.origin.y = diceArea.origin.y+heightLoose;
        diceArea.size.height = diceArea.size.height - 2*heightLoose;
        
    }
    UIView* view = [self.view viewWithTag:99];
    view.frame = diceArea;
    //max length dice move
    maxLengthMove = hypot(pointPlaceDice.x-diceArea.origin.x, pointPlaceDice.y-diceArea.origin.y);
}
-(IBAction)rollDices:(id)sender{
    [self clearDices];
    [self makeSomeNewDice:numDice];
}
-(IBAction)changeSound:(id)sender{
    isPlaySound = !isPlaySound;
    if (isPlaySound) {
        [btnSound setImage:[UIImage imageNamed:@"ico_sound"] forState:UIControlStateNormal];
        [btnSound setImage:[UIImage imageNamed:@"ico_sound_off"] forState:UIControlStateHighlighted];
    }else{
        [btnSound setImage:[UIImage imageNamed:@"ico_sound"] forState:UIControlStateHighlighted];
        [btnSound setImage:[UIImage imageNamed:@"ico_sound_off"] forState:UIControlStateNormal];
    }
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        [self rollDices:nil];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = touches.anyObject;
    UIView* view = touch.view;
    if ([view isEqual:self.view]) {
        CGPoint p = [touch locationInView:self.view];\
        int bottom = btnSound.frame.origin.y+btnSound.frame.size.height;
        if (p.y>bottom) {
            [self rollDices:nil];
        }
    }
}
-(void)chooseDices:(int)numDices{
    NSLog(@"Select %d dices!",numDices);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIFont *)boldFontFromFont:(UIFont *)font
{
    NSString *familyName = [font familyName];
    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    for (NSString *fontName in fontNames)
    {
        if ([fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIFont *boldFont = [UIFont fontWithName:fontName size:font.pointSize];
            return boldFont;
        }
    }
    return nil;
}
-(void)makeSomeNewDice:(int)amount{
    for (int i =0; i<amount; i++) {
        CALayer* layer = [CALayer layer];
        layer.frame = CGRectMake(pointPlaceDice.x, pointPlaceDice.y, diceSize, diceSize);
        layer.cornerRadius = diceSize/8;
        layer.backgroundColor = diceColor.CGColor;
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOffset = CGSizeMake(-2, 2);
        layer.shadowOpacity = 1.0f;
        layer.shadowRadius = diceSize/20;
        [layer setName:@"dice"];
        //random
        int diceValue = 1 + arc4random()%5;
        layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"dice_%d.png",diceValue]].CGImage;
        
        //attach to parent layer
        [self.view.layer addSublayer:layer];
        
        //add animations
        //duration
        
        //rotate
        CABasicAnimation* aniRotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        aniRotate.fromValue = @0.0f;
        int direction = arc4random()%2;
        direction = direction==0?-1:1;
        long angle =((arc4random()%29 +5)/10.0f)*M_PI*direction;
        aniRotate.toValue = @(angle);
        aniRotate.duration = DICE_ROLL_DURATION;
        aniRotate.delegate = self;
        aniRotate.fillMode = kCAFillModeForwards;
        aniRotate.removedOnCompletion = NO;
        [aniRotate setValue:[NSNumber numberWithInt:1] forKey:@"tag"];
        [aniRotate setValue:[NSNumber numberWithDouble:angle] forKey:@"angle"];
        
        //randomize location to place dice
        CGPoint p;
        while (true) {
            p = CGPointMake(diceArea.origin.x+arc4random()%((int)diceArea.size.width),
                                    diceArea.origin.y+arc4random()%((int)diceArea.size.height));
            int size = (int)arrPosDices.count;
            int count = 0;
            for (int i = 0; i<size; i++) {
                NSValue* value = [arrPosDices objectAtIndex:i];
                CGPoint p1 = value.CGPointValue;
                float distance =sqrt(pow(p.x-p1.x, 2.0) + pow(p.y-p1.y, 2.0));
                if (distance >= diceSize) {
                    count++;
                }
            }
            if (size==count) {
                break;
            }
        }
        [arrPosDices addObject:[NSValue valueWithCGPoint:p]];
        
        //distance move
        float distance = hypot(pointPlaceDice.x-p.x, pointPlaceDice.y-p.y);
        float timeAnim = (distance/(maxLengthMove))*DICE_ROLL_DURATION;
        
        //move by
        CABasicAnimation* aniMove = [CABasicAnimation animationWithKeyPath:@"position"];
        aniMove.fromValue = [NSValue valueWithCGPoint:pointPlaceDice];
        aniMove.toValue = [NSValue valueWithCGPoint:p];
        aniMove.duration = DICE_ROLL_DURATION;
        aniMove.delegate = self;
        aniMove.fillMode = kCAFillModeForwards;
        aniMove.removedOnCompletion = NO;
        [aniMove setValue:[NSString stringWithFormat:@"%f",p.y] forKey:@"y"];
        [aniMove setValue:[NSString stringWithFormat:@"%f",p.x] forKey:@"x"];
        [aniMove setValue:[NSNumber numberWithInt:2] forKey:@"tag"];
        
        //set time animation
        aniRotate.duration = timeAnim;
        aniMove.duration = timeAnim;
        
        //add animation to dice layers
        [layer addAnimation:aniMove forKey:@"moveby"];
        [layer addAnimation:aniRotate forKey:@"rotation"];
        [arrDices addObject:layer];
    }
    
    //play sound
    if (isPlaySound) {
        AudioServicesPlaySystemSound(sound1);
    }
}
-(void)clearDices{
    //clear old dices
    for (CALayer* layer in arrDices) {
        [layer removeFromSuperlayer];
    }
    [arrDices removeAllObjects];
    [arrPosDices removeAllObjects];
}
-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (!parent) {
        [self saveUserInfo];
        AudioServicesRemoveSystemSoundCompletion(sound1);
        AudioServicesDisposeSystemSoundID(sound1);
    }
}
-(void)applicationWillTerminate{
    [self saveUserInfo];
}
-(void)saveUserInfo{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:[NSString stringWithFormat:@"%d",numDice] forKey:@"rand_dice_num"];
    [userDef setValue:[NSString stringWithFormat:@"%d",isPlaySound==YES?1:0] forKey:@"rand_dice_sound"];
    [userDef setValue:[NSString stringWithFormat:@"%d",colorDiceIndex] forKey:@"rand_dice_color"];
    [userDef synchronize];
}

-(IBAction)showChooseColor:(id)sender{
    if (!colorPicker) {
        colorPicker = [[UIAlertView alloc] initWithTitle:@"Choose color" message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        if (!IS_OS_8_OR_LATER) { //ios7
            [colorPicker setValue:self.colorPickerView forKey:@"accessoryView"];
        }
    }
    [colorPicker show];
}
-(void)willPresentAlertView:(UIAlertView *)alertView{
    if (IS_OS_8_OR_LATER && !isLoadedAccessoryAlert) {//ios 8
        [alertView setValue:self.colorPickerView forKey:@"accessoryView"];
//        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//        view.backgroundColor = [UIColor grayColor];
//        [alertView setValue:view forKey:@"accessoryView"];
        isLoadedAccessoryAlert = YES;
    }
}
-(IBAction)chooseColor:(id)sender{
    NSLog(@"ChooseColor");
    UIButton* oldColorBtn = (UIButton*)[self.colorPickerView viewWithTag:colorDiceIndex+1];
    oldColorBtn.layer.borderWidth = 0;
    UIButton* newColorBtn = (UIButton*)sender;
    newColorBtn.layer.borderWidth = 4;
    newColorBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    colorDiceIndex = (int)newColorBtn.tag-1;
    [colorPicker dismissWithClickedButtonIndex:-1 animated:YES];
    
    //change dices color
    diceColor = [arrDiceColor objectAtIndex:colorDiceIndex];
    for (CALayer* layerDice in self.view.layer.sublayers) {
        if ([layerDice.name isEqualToString:@"dice"]) {
            NSLog(@"Dice");
            layerDice.backgroundColor = diceColor.CGColor;
        }
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

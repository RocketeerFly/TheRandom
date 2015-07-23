//
//  ViewController.m
//  TheRandom
//
//  Created by Rocketeer on 5/27/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define colorLigthGreen [UIColor colorWithRed:0.0f green:188/255.0 blue:1/255.0 alpha:1.0f].CGColor;
#define colorUpGreen [UIColor colorWithRed:110/255.0 green:255/255.0 blue:80/255.0 alpha:1.0f].CGColor;
//#define colorGreen [UIColor colorWithRed:0/255.0 green:193/255.0 blue:0/255.0 alpha:1.0f].CGColor;
#define colorGreen [UIColor whiteColor].CGColor;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSelected = NO;
    int borderWidth=0;
    //check ipad or iphone
    float rateCorner = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        rateCorner = 7/9.0;
        borderWidth = 2;
        btnCard.titleLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",btnCard.titleLabel.font.fontName] size:22];
        btnDice.titleLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",btnDice.titleLabel.font.fontName] size:22];
        btnList.titleLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",btnList.titleLabel.font.fontName] size:22];
        btnNumber.titleLabel.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",btnNumber.titleLabel.font.fontName] size:22];
        [self setConstraintForIpad];
    }else{
        rateCorner = 0.5;
        UIFont* font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",lbTheRandom.font.fontName] size:20];
        borderWidth = 1;
        lbTheRandom.font = font;
        
        //6,6 plus
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height==736.0f || height == 667.0f) {
            UIFont* font1 = [UIFont fontWithName:[NSString stringWithFormat:@"%@",lbTheRandom.font.fontName] size:22];
            lbTheRandom.font = font1;
            [self setConstraintForIphone6];
        }
    }
    // Do any additional setup after loading the view, typically from a nib.

    //set size icon
    [self updateSizeIcon];
    
    itemRdNumner.tag = 1;
    [itemRdNumner setExclusiveTouch:YES];
    CALayer* line1 = [CALayer layer];
    line1.frame = CGRectMake(csSize1.constant+20, 0, csWidth1.constant-csSize1.constant-10, 1);
    line1.backgroundColor = colorLigthGreen;
    [itemRdNumner.layer addSublayer:line1];
    
    itemRdDice.tag = 2;
    [itemRdDice setExclusiveTouch:YES];
    CALayer* line2 = [CALayer layer];
    line2.frame = CGRectMake(csSize2.constant+10, 0, csWidth2.constant-csSize2.constant, 1);
    line2.backgroundColor = colorLigthGreen;
    [itemRdDice.layer addSublayer:line2];
    
    itemRdList.tag = 3;
    [itemRdList setExclusiveTouch:YES];
    CALayer* line3 = [CALayer layer];
    line3.frame = CGRectMake(csSize3.constant+20, 0, csWidth3.constant-csSize3.constant-10, 1);
    line3.backgroundColor = colorLigthGreen;
    [itemRdList.layer addSublayer:line3];
    
    itemRdCard.tag = 4;
    [itemRdCard setExclusiveTouch:YES];
    CALayer* line4 = [CALayer layer];
    line4.frame = CGRectMake(csSize4.constant+10, 0, csWidth4.constant-csSize4.constant, 1);
    line4.backgroundColor = colorLigthGreen;
    [itemRdCard.layer addSublayer:line4];
    
    CALayer* line5 = [CALayer layer];
    line5.frame = CGRectMake(csSize4.constant+20, csHeight4.constant-1, csWidth4.constant-csSize4.constant-10, 1);
    line5.backgroundColor = colorLigthGreen;
    [itemRdCard.layer addSublayer:line5];
    
    listButton = [NSArray arrayWithObjects:itemRdNumner, itemRdDice, itemRdList, itemRdCard, nil];
}
-(void)setConstraintForIphone6{
    csHeight1.constant = 60;
    csHeight2.constant = 60;
    csHeight3.constant = 60;
    csHeight4.constant = 60;
    
    csWidth1.constant+=10;
    csWidth2.constant+=10;
    csWidth3.constant+=10;
    csWidth4.constant+=10;
}
-(void)setConstraintForIpad{
    csHeight1.constant = 80;
    csHeight2.constant = 80;
    csHeight3.constant = 80;
    csHeight4.constant = 80;
    
    csWidth1.constant = 300;
    csWidth2.constant = 300;
    csWidth3.constant = 300;
    csWidth4.constant = 300;
}
-(void)updateSizeIcon{
    csSize3.constant = csHeight3.constant-10;
    csSize1.constant = csHeight1.constant-10;
    csSize2.constant = csHeight2.constant-10;
    csSize4.constant = csHeight4.constant-10;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height==736.0f || height == 667.0f) {
        [self setConstraintForIphone6];
        [self updateSizeIcon];
    }
}
-(void)viewDidLayoutSubviews{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self setConstraintForIpad];
        [self updateSizeIcon];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [self.view layoutIfNeeded];
}
-(IBAction)gotoRandomNumber:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showNumber" sender:self];
    });
}
-(IBAction)gotoDiceRoller:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showDiceRoller" sender:self];
    });
}
-(IBAction)gotoRandomList:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showList" sender:self];
    });
}
-(IBAction)gotoPlayingCard:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showCard" sender:self];
    });
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    UIView* view = touch.view;
    if (view.tag==14) {
        //open send mail popup
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:thitruongvo@gmail.com"]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

#define colorLigthGreen [UIColor colorWithRed:193/255.0 green:255/255.0 blue:193/255.0 alpha:1.0f].CGColor;
#define colorUpGreen [UIColor colorWithRed:110/255.0 green:255/255.0 blue:80/255.0 alpha:1.0f].CGColor;
#define colorGreen [UIColor colorWithRed:0/255.0 green:193/255.0 blue:0/255.0 alpha:1.0f].CGColor;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int borderWidth=0;
    //check ipad or iphone
    float rateCorner = 0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        rateCorner = 7/9.0;
        borderWidth = 2;
    }else{
        rateCorner = 0.5;
        UIFont* font = [UIFont fontWithName:[NSString stringWithFormat:@"%@",lbTheRandom.font.fontName] size:18];
        borderWidth = 1;
        lbTheRandom.font = font;
    }
    // Do any additional setup after loading the view, typically from a nib.
    itemRdCard.layer.borderColor = colorGreen;
    itemRdCard.layer.borderWidth = borderWidth;
    itemRdCard.layer.cornerRadius = itemRdCard.frame.size.height*rateCorner;
    itemRdCard.backgroundColor = [UIColor clearColor];
    itemRdCard.layer.backgroundColor = colorLigthGreen;
    itemRdCard.tag = 4;
    
    
    itemRdDice.layer.borderColor = colorGreen;
    itemRdDice.layer.borderWidth = borderWidth;
    itemRdDice.layer.cornerRadius = itemRdCard.frame.size.height*rateCorner;
    itemRdDice.backgroundColor = [UIColor clearColor];
    itemRdDice.layer.backgroundColor = colorLigthGreen
    itemRdDice.tag = 2;
    
    itemRdList.layer.borderColor = colorGreen;
    itemRdList.layer.borderWidth = borderWidth;
    itemRdList.layer.cornerRadius = itemRdCard.frame.size.height*rateCorner;
    itemRdList.backgroundColor = [UIColor clearColor];
    itemRdList.layer.backgroundColor = colorLigthGreen;
    itemRdList.tag = 3;
    
    itemRdNumner.layer.borderColor = colorGreen;
    itemRdNumner.layer.borderWidth = borderWidth;
    itemRdNumner.layer.cornerRadius = itemRdCard.frame.size.height*rateCorner;
    itemRdNumner.backgroundColor = [UIColor clearColor];
    itemRdNumner.layer.backgroundColor = colorLigthGreen;
    itemRdNumner.tag = 1;
    
    listButton = [NSArray arrayWithObjects:itemRdNumner, itemRdDice, itemRdList, itemRdCard, nil];
}
-(void)viewDidAppear:(BOOL)animated{
    imgView.layer.borderColor = [UIColor blueColor].CGColor;
    imgView.layer.borderWidth = 1;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView* view = [[touches anyObject] view];
    if ([listButton containsObject:view]) {
        currentSelect = view.tag;
        [self changeColorSelectedButton:view];
        [self performSelector:@selector(showSelection:) withObject:[NSNumber numberWithInteger:currentSelect] afterDelay:0.1];
    }
}

-(void)showSelection:(NSNumber*)selectedIndex{
    
    int index = [selectedIndex intValue];
    switch (index) {
        case 1:
        {
            itemRdNumner.layer.backgroundColor = colorLigthGreen;
            [self performSegueWithIdentifier:@"showNumber" sender:self];
        }
            break;
        case 2:
        {
            itemRdDice.layer.backgroundColor = colorLigthGreen;
            [self performSegueWithIdentifier:@"showDiceRoller" sender:self];
        }
            break;
        case 3:
        {
            itemRdList.layer.backgroundColor = colorLigthGreen;
            [self performSegueWithIdentifier:@"showList" sender:self];
        }
            break;
        case 4:
        {
            itemRdCard.layer.backgroundColor = colorLigthGreen;
            [self performSegueWithIdentifier:@"showCard" sender:self];
        }
            break;
        default:
            break;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch cancelled");
    UIView* view = [[touches anyObject] view];
    if([listButton containsObject:view]){
        if (currentSelect!=0) {
            UIView* viewSelected = [self.view viewWithTag:currentSelect];
            [self changeColorDeselectButton:viewSelected];
        }
        currentSelect = 0;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch End");
    //check touch up inside
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Move");
}
-(void)changeColorSelectedButton:(UIView*)view{
    view.layer.backgroundColor = colorUpGreen;
}
-(void)changeColorDeselectButton:(UIView*)view{
    view.layer.backgroundColor = colorLigthGreen;
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

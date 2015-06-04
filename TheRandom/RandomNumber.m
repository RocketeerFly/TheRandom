//
//  RandomNumber.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomNumber.h"

#define MAXLENGTH 9
@interface RandomNumber ()

@end

@implementation RandomNumber

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
//    tfMin.layer.borderWidth = 1;
//    tfMin.layer.cornerRadius = 15;
//    tfMin.layer.borderColor = [UIColor grayColor].CGColor;
//    tfMax.layer.borderWidth = 1;
//    tfMax.layer.cornerRadius = 15;
//    tfMax.layer.borderColor = [UIColor grayColor].CGColor;
//    lbResult.text = @"999999999";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([tfMin becomeFirstResponder]) {
        [tfMin resignFirstResponder];
    }else{
        if ([tfMax becomeFirstResponder]) {
            [tfMax resignFirstResponder];
        }
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        NSLog(@"Shake gusture detected!");
        
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
        
        
        lbResult.text = [NSString stringWithFormat:@"%ld",(long)[self generateRandomNumber]];
        
        while (true) {
            int randomColorIndex = rand()%arrColor.count;
            if (randomColorIndex!=currentColorIndex) {
                currentColorIndex = randomColorIndex;
                NSLog(@"currnetColorIndex %d",currentColorIndex);
                break;
            }
        }
        
        lbResult.textColor = (UIColor*)[arrColor objectAtIndex:currentColorIndex];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  RandomList.m
//  TheRandom
//
//  Created by Rocketeer on 6/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomList.h"

@interface RandomList ()
@end

@implementation RandomList

static NSString *const placeholder = @"Please input list";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tfList.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tfList.layer.borderWidth = 1;
    tfList.layer.cornerRadius = 8;
    tfList.contentMode = UIViewContentModeTopLeft;
    [tfList setContentOffset:CGPointZero];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch began");
    if ([tfList isFirstResponder]) {
        [self hideDoneButton];
    }
    NSLog(@"%@",NSStringFromCGPoint(tfList.contentOffset));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [tfList setContentOffset:CGPointZero];
    if ([self color:textView.textColor isEqualToColor:[UIColor lightGrayColor] withTolerance:0]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    NSLog(@"Begin edit");
    [self showDoneButton];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

//
//  SettingViewController.m
//  TheRandom
//
//  Created by RocketeerFly on 9/26/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnlock;
@property (weak, nonatomic) IBOutlet UIButton *buttonRestore;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewContainer.layer.shadowColor = UIColor.blackColor.CGColor;
    _viewContainer.layer.shadowOffset = CGSizeMake(1, 1);
    _viewContainer.layer.shadowRadius = 4;
    _viewContainer.layer.shadowOpacity = 0.4;
    _viewContainer.layer.cornerRadius = 6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPressEmailContact:(id)sender {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"mailto:thitruongvo@gmail.com?subject=RandomTools"]];
}
- (IBAction)onPressRestore:(id)sender {
}
- (IBAction)onPressUnlock:(id)sender {
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

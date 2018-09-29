//
//  MyTabBarViewController.m
//  TheRandom
//
//  Created by Vo Truong Thi on 9/25/18.
//  Copyright © 2018 Rocketeer. All rights reserved.
//

#import "MyTabBarViewController.h"


@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //get last tab
    NSString* lastTabIndex = [NSUserDefaults.standardUserDefaults stringForKey:@"last_tab_index"];
    if (lastTabIndex) {
        self.selectedIndex = lastTabIndex.integerValue;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

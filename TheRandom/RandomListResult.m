//
//  RandomListResult.m
//  TheRandom
//
//  Created by Rocketeer on 6/12/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RandomListResult.h"

@interface RandomListResult ()

@end

@implementation RandomListResult


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add reset button
    UIBarButtonItem* btnReset = [[UIBarButtonItem alloc] initWithTitle:@"Again!" style:UIBarButtonItemStylePlain target:self action:@selector(randomAgain)];
    self.navigationItem.rightBarButtonItem = btnReset;
    
    //
    arrList = [[NSMutableArray alloc] initWithArray:[self.listText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    NSString* lastString = [arrList lastObject];
    if (lastString.length == 0) {
        [arrList removeLastObject];
    }
    [self shuffleArray];
    tvList.tableFooterView = [UIView new];
}
-(void)randomAgain{
    NSLog(@"Random again!");
    [self shuffleArray];
    NSInteger count = [arrList count];
    [tvList beginUpdates];
    for (int i = 0; i<count; i++) {
        NSArray* arrIndex = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:i inSection:0], nil];
        [tvList deleteRowsAtIndexPaths:arrIndex withRowAnimation:UITableViewRowAnimationBottom];
        [tvList insertRowsAtIndexPaths:arrIndex withRowAnimation:UITableViewRowAnimationBottom];
    }
    [tvList endUpdates];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"myCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@",indexPath.row+1,[arrList objectAtIndex:indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)shuffleArray{
    int count = [arrList count];
    for (int i=0; i<count; i++) {
        int right = count-i;
        int rand = arc4random()%right + i;
        [arrList exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion==UIEventSubtypeMotionShake) {
        [self randomAgain];
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

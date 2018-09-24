//
//  RecentDice.m
//  TheRandom
//
//  Created by Rocketeer on 7/7/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "RecentDice.h"
#import "RandomDice.h"
#import "Constants.h"

@interface RecentDice ()

@end

@implementation RecentDice

@synthesize arrRecents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* btnClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearRecent)];
    self.navigationItem.rightBarButtonItem = btnClear;
    tbv.tableFooterView = [UIView new];
    tbv.backgroundColor = kColorDarkBG;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        heighRow = 66;
        diceHeight = 46;
    }else{
        heighRow = 50;
        diceHeight = 36;
    }
    RandomDice* randDice = (RandomDice*)self.delegate;
    arrDiceColor = randDice.arrDiceColor;
}
-(void)clearRecent{
    if (arrRecents) {
        if ([self.delegate respondsToSelector:@selector(clearRecent)]) {
            [self.delegate clearRecent];
        }
        arrRecents = nil;
        [tbv reloadData];
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrRecents.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return heighRow;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"myCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        const int xBegin = 40;
        const int y = (heighRow-diceHeight)/2;
        NSString* record = [arrRecents objectAtIndex:(arrRecents.count - indexPath.row-1)];
        NSArray* arr = [record componentsSeparatedByString:@","];
        UIColor* color = [arrDiceColor objectAtIndex:[[arr firstObject] integerValue]];
        for (int i=1; i<arr.count; i++) {
            CALayer* layer = [CALayer layer];
            layer.frame = CGRectMake(xBegin+(i-1)*diceHeight+i*y, y, diceHeight, diceHeight);
            layer.borderWidth = 1;
            layer.borderColor = [UIColor lightGrayColor].CGColor;
            layer.backgroundColor = color.CGColor;
            layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"dice_%@",[arr objectAtIndex:i]]].CGImage;
            [cell.layer addSublayer:layer];
        }
        cell.backgroundColor = kColorDarkBG;
        cell.textLabel.textColor = UIColor.whiteColor;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    return cell;
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

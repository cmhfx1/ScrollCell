//
//  ViewController.m
//  testcellpan
//
//  Created by fx on 2017/7/31.
//  Copyright © 2017年 fx. All rights reserved.
//

#import "ViewController.h"
#import "ILIPanCell.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ILIPanCellDelegate>

@property (nonatomic,weak)UITableView *tableview;

@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableview];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellBeginDraging) name:KCellBeginDraging object:nil];

}

- (void)setupTableview
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [tableview registerClass:[ILIPanCell class] forCellReuseIdentifier:@"pan"];
    self.tableview = tableview;

}




#pragma mark   -- tableviewDataSource --


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *btnSource = [NSMutableArray array];
    
    ILIPanCellButtonModel *share = [ILIPanCellButtonModel panCellButtonModelWithType:ILIPanCellButtonTypeShare title:@"share" width:60 titleColor:[UIColor blackColor] backColor:[UIColor brownColor]];
    ILIPanCellButtonModel *delete = [ILIPanCellButtonModel panCellButtonModelWithType:ILIPanCellButtonTypeDelete title:@"delete" width:80 titleColor:[UIColor redColor] backColor:[UIColor grayColor]];
    [btnSource addObject:share];
    [btnSource addObject:delete];


    ILIPanCell *cell = [ILIPanCell pancellWithTableview:tableView identify:@"pan" indexPath:indexPath btnSource:btnSource];
    cell.delegate = self;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ILIPanCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSLog(@"delegate _ cell _ click _ indexpath = %@  cell = %@",indexPath,cell);
}



#pragma mark  -- cell delegate --

- (void)handleClickCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSLog(@"cell _ click _ indexPath = %@",indexPath);
    [self tableView:self.tableview didSelectRowAtIndexPath:indexPath];
}


- (void)handleClickButtonWithCell:(UITableViewCell *)cell type:(ILIPanCellButtonType)type
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSLog(@"cellBtn _ click _ indexPath = %@",indexPath);
}



- (void)cellBeginDraging
{
    [self findCellClose];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self findCellClose];
}




- (void)findCellClose
{
    NSArray *cells =  self.tableview.visibleCells;
    for (ILIPanCell *cell in cells) {
        
        NSLog(@"indexpath = %@",[self.tableview indexPathForCell:cell]);
        if (cell.open) {
            [cell performSelector:@selector(close)];
            break;
        }
    }

}
@end

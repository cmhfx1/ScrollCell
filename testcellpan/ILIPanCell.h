//
//  ILIPanCell.h
//  testcellpan
//
//  Created by fx on 2017/7/31.
//  Copyright © 2017年 fx. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *KCellBeginDraging = @"cellBeginDraging";

typedef NS_ENUM(NSInteger, ILIPanCellButtonType){
    ILIPanCellButtonTypeShare,
    ILIPanCellButtonTypeDelete
};




/***              ILIPanCell  Class                                       **/

/***                 delegate                                            **/

@protocol ILIPanCellDelegate <NSObject>


- (void)handleClickCell:(UITableViewCell *)cell;

- (void)handleClickButtonWithCell:(UITableViewCell *)cell type:(ILIPanCellButtonType)type;


@end





@interface ILIPanCell : UITableViewCell


@property (nonatomic,weak)id<ILIPanCellDelegate>delegate;

+ (id)pancellWithTableview:(UITableView *)tableview identify:(NSString *)identify indexPath:(NSIndexPath *)indexpath btnSource:(NSArray *)btnSource;

@property (nonatomic,assign)BOOL open;

- (void)close;


@end








/***              ILIPanCellButtonModel  Class                                       **/

@interface ILIPanCellButtonModel : NSObject


@property (nonatomic,assign)NSInteger type;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)CGFloat width;

@property (nonatomic,copy)UIColor *titleColor;
@property (nonatomic,copy)UIColor *backColor;


+ (id)panCellButtonModelWithType:(NSInteger)type title:(NSString *)title width:(CGFloat)width titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor;



@end






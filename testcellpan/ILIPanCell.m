//
//  ILIPanCell.m
//  testcellpan
//
//  Created by fx on 2017/7/31.
//  Copyright © 2017年 fx. All rights reserved.
//

#import "ILIPanCell.h"


/***              ILIPanCellButtonModel  Class                                       **/

@implementation ILIPanCellButtonModel


+ (id)panCellButtonModelWithType:(NSInteger)type title:(NSString *)title width:(CGFloat)width titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor
{
    ILIPanCellButtonModel *model = [[self alloc] initWithType:type title:title width:width titleColor:titleColor backColor:backColor];
    return model;
    
}

- (id)initWithType:(NSInteger)type title:(NSString *)title width:(CGFloat)width titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor
{
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        self.width = width;
        self.titleColor = titleColor;
        self.backColor = backColor;
    }
    return self;
}

@end









/***              ILIPanCellButton  Class                                       **/

@interface ILIPanCellButton : UIButton

@property (nonatomic, assign)ILIPanCellButtonType type;

//@property (nonatomic, assign)SEL sel;


@end


@implementation ILIPanCellButton 

@end











/***              ILIPanCell  Class                                       **/


#define KScreenSize [UIScreen mainScreen].bounds.size

@interface ILIPanCell ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *backView;

@property (nonatomic, weak)UIView *rightView;

@property (nonatomic, strong)NSArray  *btnSource;
@property (nonatomic, assign)CGFloat rightviewW;
@end

@implementation ILIPanCell


+ (id)pancellWithTableview:(UITableView *)tableview identify:(NSString *)identify indexPath:(NSIndexPath *)indexpath btnSource:(NSArray *)btnSource
{
    ILIPanCell *cell =  [tableview dequeueReusableCellWithIdentifier:identify forIndexPath:indexpath];
    
    // 在 init之后 ，，
    cell.btnSource = btnSource;
    
    [cell setupButtons];
    
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupScrollview];

        
        [self setupRightview];
        
        [self setupContentview];
        
        [self.backView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
       
 
    }
    return self;
}



- (void)setupScrollview
{
    
    UIScrollView *backview = [[UIScrollView alloc] init];
    backview.delegate = self;
    backview.bounces = NO;
    backview.backgroundColor = [UIColor brownColor];
    backview.showsHorizontalScrollIndicator = NO;
    self.backView = backview;
    [self addSubview:self.backView];
}



- (void)setupRightview
{
    UIView *rightview = [UIView new];
    self.rightView = rightview;
    rightview.backgroundColor = [UIColor redColor];
    
    [self.backView addSubview:rightview];
}



- (void)setupContentview
{
    [self.backView addSubview:self.contentView];
    NSLog(@"___%@",self.contentView.subviews);
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    lb.text = @"         lb";
    [self.contentView addSubview:lb];
    
}


- (void)setBtnSource:(NSArray *)btnSource
{
    _btnSource = btnSource;
    CGFloat length = 0.f;
    for (ILIPanCellButtonModel *mdl in _btnSource) {
        length+=mdl.width;
    }
    self.rightviewW = length;

}


-(void)setupButtons
{
    [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = self.btnSource.count;
    for (int i = 0; i < count; i++) {
        
        ILIPanCellButtonModel *model = self.btnSource[i];
        
        ILIPanCellButton *btn = [ILIPanCellButton buttonWithType:UIButtonTypeCustom];
        btn.type = model.type;
        [btn setTitleColor:model.titleColor forState:UIControlStateNormal];
        [btn setBackgroundColor:model.backColor];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightView addSubview:btn];
        
    }    
}



- (void)handleClickBtn:(ILIPanCellButton *)btn
{
    NSLog(@"btn click   %ld",btn.type);
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleClickButtonWithCell:type:)]) {
        [self.delegate handleClickButtonWithCell:self type:btn.type];
    }
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame = self.bounds;
    
    NSInteger count = _btnSource.count;
    
    self.backView.contentSize = CGSizeMake(KScreenSize.width + _rightviewW, 0);

    
    self.rightView.frame = CGRectMake(KScreenSize.width - _rightviewW, 0, _rightviewW, self.backView.bounds.size.height);
    
    
    CGFloat total = 0.f;
    for (int i = 0; i < count; i++) {
        ILIPanCellButton *btn = self.rightView.subviews[i];
        ILIPanCellButtonModel *model = self.btnSource[i];
        btn.frame = CGRectMake(total, 0, model.width, self.rightView.frame.size.height);
        total += model.width;
    }
    
}







#pragma mark --- UIScrollViewDelegate ---



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

    
    CGFloat x = targetContentOffset -> x;
    
    
//    if (x >=  _rightviewW) {
//        x = _rightviewW;
//    }else{
//        x= 0;
//    }
//    
    
    
    CGFloat tmp = 0;
    for (NSInteger i = _btnSource.count - 1; i >= 0; i--) {
       
        ILIPanCellButtonModel *model = self.btnSource[i];
        
        
        if(x >= _rightviewW){
            x = _rightviewW;
            break;
        }
        if (x < tmp + model.width) {
            if (x < model.width / 2.0 + tmp) {
                x = tmp;
            }else{
                x = model.width + tmp;
            }
            break;
        }else{
            tmp += model.width;
        }
        
    }
    
    
    
    if (x == 0) {
        self.open = NO;
    }else{
        self.open = YES;
    }
    
    targetContentOffset -> x = x;
}







#pragma mark  --  scrollview delegate ---


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"sc did sc");
    CGPoint point =  scrollView.contentOffset;
    self.rightView.transform = CGAffineTransformMakeTranslation(point.x, 0);
}






#pragma mark -- kvo ----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)object;
    if (pan.state == UIGestureRecognizerStateFailed) {
        NSLog(@"panGes _ fail -> cell click");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleClickCell:)]) {
            [self.delegate handleClickCell:self];
        }
        
        
    }else if (pan.state == UIGestureRecognizerStateBegan){
        
        NSLog(@"panGes _ begin -> sc scroll");
        [[NSNotificationCenter defaultCenter] postNotificationName:KCellBeginDraging object:nil];
        
    }
    
}


- (void)close
{
    NSLog(@"cell _ close");
    self.open = NO;
    [UIView animateWithDuration:.4f animations:^{
        [self.backView setContentOffset:CGPointZero];
    }];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

{
    if (self.open) {
        
        CGPoint rightViewPoint =  [self convertPoint:point toView:self.rightView];
        
        BOOL rightViewinside = [self.rightView pointInside:rightViewPoint withEvent:event];
        
        if (rightViewinside) {
            
            for (ILIPanCellButton *view in self.rightView.subviews) {
                
                CGPoint viewPoint =  [self convertPoint:point toView:view];
                
                BOOL viewInside = [view pointInside:viewPoint withEvent:event];
                
                if (viewInside) {
                    NSLog(@"before close _ click btn");
                    [self handleClickBtn:view];
                    break;
                }
            }
        }
        
        [self close];
        return nil;
    }else return [super hitTest:point withEvent:event];
    
}


@end

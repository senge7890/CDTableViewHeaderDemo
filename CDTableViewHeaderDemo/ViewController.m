//
//  ViewController.m
//  CDTableViewHeaderDemo
//
//  Created by Alex on 15/8/21.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Height [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"



const CGFloat BackGroupHeight = 200;
const CGFloat HeadImageHeight= 80;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    
    UITableView *demoTableView;
    
    UIImageView *imageBG;
    UIView *BGView;
    
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *titleLabel;
    
    UIButton *leftBtn;
    UIButton *rightBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
   
    
    
    [self setupUI];
}


-(void)setupUI
{
    demoTableView=[[UITableView alloc]init];
    demoTableView.delegate=self;
    demoTableView.dataSource=self;
    [demoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    demoTableView.frame=[UIScreen mainScreen].bounds;
    demoTableView.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    
    [self.view addSubview:demoTableView];
    
    //
    imageBG=[[UIImageView alloc]init];
    imageBG.frame=CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    imageBG.image=[UIImage imageNamed:@"BGimage.jpg"];
    
    [demoTableView addSubview:imageBG];
    //
    BGView=[[UIView alloc]init];
    BGView.backgroundColor=[UIColor clearColor];
    BGView.frame=CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    
    [demoTableView addSubview:BGView];
    
    //
    headImageView=[[UIImageView alloc]init];
    headImageView.image=[UIImage imageNamed:@"myheadimage.jpg"];
    headImageView.frame=CGRectMake((KScreen_Width-HeadImageHeight)/2, 50, HeadImageHeight, HeadImageHeight);
    [BGView addSubview:headImageView];
    
    //
    
    nameLabel=[[UILabel alloc]init];
    nameLabel.text=@"Alex";
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.frame=CGRectMake((KScreen_Width-HeadImageHeight)/2, CGRectGetMaxY(headImageView.frame), HeadImageHeight, 20);
    nameLabel.backgroundColor=[UIColor whiteColor];
    [BGView addSubview:nameLabel];
    
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"title";
   
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    self.navigationItem.titleView=titleLabel;
     titleLabel.alpha=0;
    
    leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftBtn setTitle:@"left" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightBtn setTitle:@"right" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;

    
}



-(void)leftBtnAction
{
    NSLog(@"leftClick");
}


-(void)rightBtnAction
{
    NSLog(@"rightClick");
}




#pragma mark - tableViewDelegate&DataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",indexPath.row];
    return cell;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    
    if (yOffset < -BackGroupHeight) {
        
        CGRect rect = imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = KScreen_Width + fabs(xOffset)*2;
        
        imageBG.frame = rect;
    }
    
    
    CGFloat alpha = (yOffset+BackGroupHeight)/BackGroupHeight;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor orangeColor]colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    titleLabel.alpha=alpha;
    alpha=fabs(alpha);
    alpha=fabs(1-alpha);
   
    alpha=alpha<0.2? 0:alpha-0.2;
    
    
    BGView.alpha=alpha;


}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

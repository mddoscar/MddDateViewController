//
//  MddDateViewController.h
//  ChildrenLocation
//
//  Created by szalarm on 15/9/10.
//  Copyright (c) 2015年 szalarm. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 时间控制器
 */
@interface MddDateViewController : UIViewController

#pragma mark ib
//标题
@property (weak, nonatomic) IBOutlet UILabel *mUiTitleLabel;
//时间
@property (weak, nonatomic) IBOutlet UIDatePicker *mUiMyDatePick;


- (IBAction)doCancel:(id)sender;

- (IBAction)doOk:(id)sender;
- (IBAction)doSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mUiTimeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *mUiSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *mUiCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *mUiComfirmButton;
#pragma mark add
//是否是带十分秒
@property(nonatomic,assign)BOOL isYMDHms;
//默认显示时间
@property(nonatomic,strong) NSString * mDefDate;
-(void) setDefDateStr:(NSString *) pDateStr;
//日期转换
-(NSDate*) convertDateFromString:(NSString*)uiDate;
//日期
- (NSString *)stringFromDate:(NSDate *)date;
@end

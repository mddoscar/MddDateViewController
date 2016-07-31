//
//  MddDateViewController.m
//  ChildrenLocation
//
//  Created by szalarm on 15/9/10.
//  Copyright (c) 2015年 szalarm. All rights reserved.
//

#import "MddDateViewController.h"
//正则表达式
#import "MddRegexHelper.h"
@interface MddDateViewController ()

@end

@implementation MddDateViewController
//@synthesize mUiMyDatePick,mUiTitleLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyDatePick];
    NSLog(@"%d:%s",__LINE__,__FUNCTION__);
}

//初始化
-(void) initMyDatePick
{
    NSLog(@"A:%d:%s",__LINE__,__FUNCTION__);
    NSDate * date=[[NSDate alloc] init];
    //
    self.mUiMyDatePick.translatesAutoresizingMaskIntoConstraints=NO;
    /**
     *  设置只显示中文
     */
    //systemLocale
    [self.mUiMyDatePick setLocale:[NSLocale systemLocale]];
//    [self.mUiMyDatePick setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    /**
     *  设置只显示日期
     */
    if (self.isYMDHms) {
            self.mUiMyDatePick.datePickerMode=UIDatePickerModeDateAndTime;
    }else{
        self.mUiMyDatePick.datePickerMode=UIDatePickerModeDate;
    }
    if ( self.mDefDate!=nil) {
        date =[self convertDateFromString:self.mDefDate];
    }else{
        //没有值
        self.mDefDate=[self stringFromDate:date];
    }
    self.mUiTimeTextfield.text=self.mDefDate;
    NSLog(@"B:%d:%s",__LINE__,__FUNCTION__);
    [self.mUiMyDatePick setDate:date];
    NSLog(@"C:%d:%s",__LINE__,__FUNCTION__);
    //自适应高度
    CGRect frame=self.view.frame;
    //年月日十分秒比较宽
    if (self.isYMDHms) {
        frame.size.width=SCREEN_WIDTH;
    }else{
        frame.size.width=(SCREEN_WIDTH*3/4)>300?(SCREEN_WIDTH*3/4):300;
    }

    
//    frame.size.height=SCREEN_WIDTH/2;//高度不改
    self.view.frame=frame;
    //
    //文字
    [self.mUiComfirmButton setTitle:_LS_(@"kMddToastTipsOk", nil) forState:UIControlStateNormal];
    [self.mUiCancelButton setTitle:_LS_(@"kMddToastTipsCancel", nil) forState:UIControlStateNormal];
    //kMdd_str_user_tips_select
    [self.mUiSelectButton setTitle:_LS_(@"kMdd_str_user_tips_select", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doCancel:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDatePickOut" object:nil];
}

- (IBAction)doOk:(id)sender {
    NSDate * tDate=self.mUiMyDatePick.date;
    self.mDefDate=[self stringFromDate:tDate];
    //缓存一个旧的字符串
    NSString * tOldStr=self.mDefDate;
    //从文本款取之
    if(![@"" isEqualToString:self.mUiTimeTextfield.text])
    {
        //是合法的字符串
        if([MddRegexHelper stringForYMDHMsWithStr:self.mUiTimeTextfield.text])
        {
            @try {
                self.mDefDate=self.mUiTimeTextfield.text;
                //容错
                NSString * lastStr=@"00";
                //还原字符串
                NSString * tReBackStr=@"";
                NSArray *array = [self.mDefDate componentsSeparatedByString:@":"];
                NSString * tSr=array[[array count]-1];
                //空置
                if ([@"" isEqualToString:tSr]) {
                    lastStr=@"00";
                }else{
                    int t=[tSr intValue];
                    if (t<0) {
                        t=0;
                    }
                    if (t>59) {
                        t=59;
                    }
                    if (t<10) {
                        lastStr=[NSString stringWithFormat:@"0%d",t];
                    }else{
                        lastStr=[NSString stringWithFormat:@"%d",t];
                    }
                    
                }
                if (array.count>1) {
                    for (int i=0; i< array.count-1; i++) {
                        tReBackStr=[tReBackStr stringByAppendingString:[NSString stringWithFormat:@"%@:",array[i]]];
                    }
                    //最后一个
                    tReBackStr =[tReBackStr stringByAppendingString:lastStr];
                    self.mUiTimeTextfield.text=tReBackStr;
                    self.mDefDate= self.mUiTimeTextfield.text;
                }
                
                //二次验证
                if([MddRegexHelper stringForYMDHMsWithStr:self.mDefDate])
                {
                    tDate=[self convertDateFromString:self.mDefDate];
                }else{
                    tDate=[self convertDateFromString:tOldStr];
                    self.mDefDate=tOldStr;
                    self.mUiTimeTextfield.text=self.mDefDate;
                    tDate=[self convertDateFromString:self.mDefDate];
                }
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
        //非法的字符串
        }else{
            //还原
            self.mDefDate=tOldStr;
            self.mUiTimeTextfield.text=self.mDefDate;
            tDate=[self convertDateFromString:self.mDefDate];
        }
        
        
    }
    NSDictionary *fParamData = [NSDictionary dictionaryWithObject: tDate forKey:@"date"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDatePickValue" object:fParamData];
}

- (IBAction)doSelect:(id)sender {
    NSDate * tDate=self.mUiMyDatePick.date;
    self.mDefDate=[self stringFromDate:tDate];
    self.mUiTimeTextfield.text=self.mDefDate;
}

//日期转换
-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    if([@"" isEqualToString:uiDate])
    {
        NSDate *date=[NSDate new];
            return date;
    }else if(uiDate.length<=10)
    {
        uiDate =[uiDate stringByAppendingString:@" 00:00:00"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:uiDate];
            return date;
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:uiDate];
        return date;
    }

}
//日期
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
-(void) setDefDateStr:(NSString *) pDateStr
{
    if (pDateStr!=nil) {
        self.mDefDate=pDateStr;
    }else{
    //默认今天
        self.mDefDate=[self stringFromDate:[NSDate new]];
    }
}
@end

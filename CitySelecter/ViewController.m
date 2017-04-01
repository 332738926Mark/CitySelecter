//
//  ViewController.m
//  BaiduTest
//
//  Created by shendan on 16/12/9.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "ViewController.h"
#import "CityPickerViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *addressTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"test_search";
    self.view.backgroundColor = [UIColor whiteColor];
    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 110, 30)];
    _addressTF.delegate = self;
    _addressTF.placeholder = @"address";
    [self.view addSubview:_addressTF];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIColor clearColor],NSForegroundColorAttributeName,
//                                    [UIFont systemFontOfSize:1],NSFontAttributeName, nil];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState: UIControlStateNormal];
    CityPickerViewController *picker = [[CityPickerViewController alloc] init];
    picker.pickedCityCallBack = ^(NSString *city){
        textField.text = city;
    };
    [self presentViewController:picker animated:UIViewAnimationTransitionCurlUp completion:nil];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

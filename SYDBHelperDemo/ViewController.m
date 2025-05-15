//
//  ViewController.m
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import "ViewController.h"
#import "SYDBHelper.h"
#import "Model1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Model1 *model1 = [[Model1 alloc] init];
    model1.userID = @"3112323";
    model1.abc = @"6666";
    model1.model2 = [[Model2 alloc] init];
    model1.model2.name = @"bbbb";
    model1.model2.startTime = 90837910283;
    
    [kDBHelper insert:model1];
}


@end

//
//  ComunidadViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "ComunidadViewController.h"

@interface ComunidadViewController ()

@end

@implementation ComunidadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ghfincas.es/oficina-virtual"]];
    [self.webview loadRequest:request];
    
    
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

@end

//
//  INCIDENCIAPOREMAILViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "INCIDENCIAPOREMAILViewController.h"

@interface INCIDENCIAPOREMAILViewController ()

@end

@implementation INCIDENCIAPOREMAILViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)VOLVER:(id)sender {
    //cerramos VC
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end

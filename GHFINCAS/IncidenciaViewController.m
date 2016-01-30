//
//  IncidenciaViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "IncidenciaViewController.h"

//para el alertView que marque el telfono

#import "ILAlertView.h"

@interface IncidenciaViewController ()

@end

@implementation IncidenciaViewController

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

- (IBAction)TelefonoPulsado:(id)sender {
    
    
    NSString *phNo = @"673787175";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phNo]];
    
    if([[UIApplication sharedApplication] canOpenURL:phoneUrl]){
        
        [ILAlertView showWithTitle:@"LLAMAR GHFINCAS!!"
                           message:[@"Quieres llamar a " stringByAppendingString:phNo]
                  closeButtonTitle:@"No"
                 secondButtonTitle:@"SI"
                tappedSecondButton:^{
                    //aqui ahora llamamos al telefno
                    [[UIApplication sharedApplication] openURL:phoneUrl];
                    
                }];
        
        
    };
}

- (IBAction)EmailPulsado:(id)sender {
}
@end

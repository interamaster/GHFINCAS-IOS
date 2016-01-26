//
//  LoginViewController.m
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 26/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

 
- (IBAction)login_pulsado:(id)sender {
    
    
    //chequeamos los texto corretcos
    
    
    
        if([[self.login text] isEqualToString:@""] || [[self.password text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Introduce email y password" :@"Error!" :0];
            
           self.autolgin.on=NO;
            
            
        } else {
            
            //de momento estara ok
            
            [self.autolgin setOn:YES animated:YES];
            
            [self LoginSuces];
            
            
                   }
    }


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
                                alertView.tag = tag;
                            [alertView show];
}



-(void)LoginSuces{
    
    
    [self performSegueWithIdentifier:@"login_success" sender:self];
    
}



- (IBAction)sign_in_pulsado:(id)sender {
    
    
    //vamos al siggnig in
    
     [self performSegueWithIdentifier:@"sign_in" sender:self];
    
    
}

 

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
      //para quitar teclado si se pulsa en en fin
    
    
    [textField resignFirstResponder];
    return YES;
    
    
}
@end

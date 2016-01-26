//
//  LoginViewController.h
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 26/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCZProgressView.h"



@interface LoginViewController : UIViewController <UITextFieldDelegate>
 
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UISwitch *autolgin;
@property (nonatomic)  UCZProgressView *progressView;

@property (nonatomic)NSTimer* timerProgressBar;

 
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login_pulsado:(id)sender;
- (IBAction)sign_in_pulsado:(id)sender;
 
@end

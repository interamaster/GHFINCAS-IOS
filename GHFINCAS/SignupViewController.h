//
//  SignupViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 29/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *Nombre;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *telefono;
@property (strong, nonatomic) IBOutlet UITextField *nombrecomunidad;
- (IBAction)btnsignup:(id)sender;
 
@end

//
//  SignupViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 29/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

//PARA EL EMAIL IN BACKGROUND


#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h" // for Base64 encoding

#import <MessageUI/MessageUI.h> //para ekl envio email manual si fall el otro
#import <MessageUI/MFMailComposeViewController.h>


@interface SignupViewController : UIViewController<SKPSMTPMessageDelegate,MFMailComposeViewControllerDelegate>{
    
    NSString *PREF_EMAIL;
  
    NSString *PREF_TELEFONO;
    NSString *PREF_NOMBRECMUNIDAD;
    NSString *PREF_NOMBREVECINO;
    NSString *PREF_PASSWORD;
    
   
    
}

@property (strong, nonatomic) IBOutlet UITextField *Nombre;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *telefono;
@property (strong, nonatomic) IBOutlet UITextField *nombrecomunidad;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progresscircular;
- (IBAction)btnsignup:(id)sender;
 
@end

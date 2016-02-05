//
//  LoginViewController.h
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 26/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCZProgressView.h"



@interface LoginViewController : UIViewController <UITextFieldDelegate>{
   
    
    //ivars para email,pass/telfno/nombrecomunidad/hnombrevecion/loginyaok
    
    NSString *PREF_EMAIL;
     NSString *PREF_PASSWORD;
     NSString *PREF_TELEFONO;
     NSString *PREF_NOMBRECMUNIDAD;
    NSString *PREF_NOMBREVECINO;
     BOOL *PREF_BOOL_LOGINYAOK;
    //ivar para el numero de arranques
    int PREF_NUMERO_DEARRANQUES;
    
    //para chequear nombre comunidad ok apartir email
    
    
    NSMutableData *DataNombrecomunidad;

}




 
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UISwitch *autolgin;
@property (nonatomic)  UCZProgressView *progressView;

@property (nonatomic)NSTimer* timerProgressBar;

 
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login_pulsado:(id)sender;
- (IBAction)sign_in_pulsado:(id)sender;
 
@end

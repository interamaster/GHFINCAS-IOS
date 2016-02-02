//
//  INCIDENCIAPOREMAILViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

//PARA EL EMAIL IN BACKGROUND


#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h" // for Base64 encoding

#import <MessageUI/MessageUI.h> //para ekl envio email manual si fall el otro
#import <MessageUI/MFMailComposeViewController.h>


//para la circularProgress:

#import "KVNProgress.h"


@interface INCIDENCIAPOREMAILViewController : UIViewController<SKPSMTPMessageDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
    
    NSString *PREF_EMAIL;
    
    NSString *PREF_TELEFONO;
    NSString *PREF_NOMBRECMUNIDAD;
    NSString *PREF_NOMBREVECINO;
    
    
}
- (IBAction)sendEmail:(id)sender;

- (IBAction)VOLVER:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *titulotext;
@property (strong, nonatomic) IBOutlet UITextView *descripociontextview;

//para la circularProgress:
@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@end

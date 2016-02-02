//
//  INCIDENCIAPOREMAILViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 30/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "INCIDENCIAPOREMAILViewController.h"

#import "UITextView+Placeholder.h"
#import <QuartzCore/QuartzCore.h>

//para el alertView  mas bonita

#import "ILAlertView.h"

#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h" // for Base64 encoding

#import <MessageUI/MessageUI.h> //para ekl envio email manual si fall el otro



//para la circularProgress: 

#import "KVNProgress.h"



@interface INCIDENCIAPOREMAILViewController ()

@end

@implementation INCIDENCIAPOREMAILViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descripociontextview.placeholder=@"Descripcion de su problema";
    
    //y lo redondeamos
    
    self.descripociontextview.clipsToBounds = YES;
    self.descripociontextview.layer.cornerRadius = 10.0f;
    
    
    
    
    //recupermaos datos [del vecino:
                       
                       NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                       
                       PREF_EMAIL=[prefs stringForKey:@"email"];
                       PREF_NOMBREVECINO=[prefs stringForKey:@"nombre_vecino"];
                       PREF_TELEFONO=[prefs stringForKey:@"telefono"];
                       PREF_NOMBRECMUNIDAD=[prefs stringForKey:@"nombre_comunidad"];
    
    
    //Creasmos el KVNPorgress
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    
    
    
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

- (IBAction)sendEmail:(id)sender {
    
    
    NSString *tituloIncidencia=self.titulotext.text;
    NSString *DescripcionIncidencia=self.descripociontextview.text;
    
    if (tituloIncidencia.length>5 && DescripcionIncidencia.length>10) {
        
        
        
        //emepzamos la animacion
        
        [KVNProgress showProgress:0.0f
                           status:@"Loading with progress..."];
        self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;
        
        [KVNProgress showWithStatus:@"Enviando Email..."];
        
        /*
        dispatch_main_after(3.0f, ^{
            [KVNProgress dismiss];
            
            self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeBlurred;
        });
        */
        
       [self sendEmailInBackground];
        
    }
    
    else
    {
        [self alertStatus:@"Entra una descripcion mas clara o un titulo mas descriptivo" :@"Error!" :0];
        
    }
    
    
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////PARA KPN PROGRESSANIAMTION///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}




- (IBAction)VOLVER:(id)sender {
    //cerramos VC
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////PARA EMAIL IN BACKGROUND///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void) sendEmailInBackground {
    
    
    
    
    NSLog(@"Start Sending");
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.fromEmail = @"jrdvsoftyopozi@gmail.com"; //sender email address
    emailMessage.toEmail = @"interamaster@gmail.com";  //receiver email address
    emailMessage.relayHost = @"smtp.gmail.com";
    //emailMessage.ccEmail =@"your cc address";
    //emailMessage.bccEmail =@"your bcc address";
    emailMessage.requiresAuth = YES;
    emailMessage.login = @"jrdvsoftyopozi@gmail.com"; //sender email address
    emailMessage.pass = @"sevilla4"; //sender email password
    
    NSString *subject=[NSString stringWithFormat:@"Nueva Inicidencia en Comunidad: %@",PREF_NOMBRECMUNIDAD];
    
    emailMessage.subject =subject;
    emailMessage.wantsSecure = YES;
    emailMessage.delegate = self; // you must include <SKPSMTPMessageDelegate> to your class
    // NSString *messageBody = @"your email body message";
    //for example :   NSString *messageBody = [NSString stringWithFormat:@"Tour Name: %@\nName: %@\nEmail: %@\nContact No: %@\nAddress: %@\nNote: %@",selectedTour,nameField.text,emailField.text,foneField.text,addField.text,txtView.text];
    
    NSString *tituloIncidencia=self.titulotext.text;
    NSString *DescripcionIncidencia=self.descripociontextview.text;
    
    
    NSString *messageBody = [NSString stringWithFormat:@"Gracias por enviarnos su email estos son sus datos:\n NOMBRE: %@\n TELEFONO: %@ \n Email: %@ \nCOMUNIDAD %@\n  \n \n \n TITULO: %@ \n \n DESCRIPCION: %@",PREF_NOMBREVECINO,PREF_TELEFONO,PREF_EMAIL,PREF_NOMBRECMUNIDAD,tituloIncidencia,DescripcionIncidencia];
    
    // Now creating plain text email message
    NSDictionary *plainMsg = [NSDictionary
                              dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                              messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,nil];
    //in addition : Logic for attaching file with email message.
    /*
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"JPG"];
     NSData *fileData = [NSData dataWithContentsOfFile:filePath];
     NSDictionary *fileMsg = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-
     unix-mode=0644;\r\n\tname=\"filename.JPG\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"filename.JPG\"",kSKPSMTPPartContentDispositionKey,[fileData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
     emailMessage.parts = [NSArray arrayWithObjects:plainMsg,fileMsg,nil]; //including plain msg and attached file msg
     */
    [emailMessage send];
    // sending email- will take little time to send so its better to use indicator with message showing sending...
}

//Now, handling delegate methods :
// On success

-(void)messageSent:(SKPSMTPMessage *)message{
    
    
    
    //activitycircular:
    
   // [self.progresscircular stopAnimating];
   // self.progresscircular.alpha=0.0;
    
    //lo hacemos con KPProgressCircular mejor:
    [KVNProgress dismiss];
    
    self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeBlurred;
    
    
    NSLog(@"delegate - message sent");
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Su informacion se envio correctamente!!" message:@"En menos de 24h recibirá por el email facilitado su contraseña" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];
     
     */
    
    //conIALert
    
    
    //[self alertStatus:@"En menos de 24h recibirá por el email facilitado su contraseña" :@"Su informacion se envio correctamente!!" :0];
    //pongo con dispatch para que se cierre este VC!!!
    
    /*
     
     [ILAlertView showWithTitle:@"Aviso"
     message:@"Lo siento esta aplicacion es LPY COPAS!!!! bajate LPY pulsando OK"
     closeButtonTitle:@"CANCEL"
     secondButtonTitle:@"OK to APPStore"
     tappedSecondButton:^{ //abrimos itunes
     
     
     NSString *iTunesLink = @"https://itunes.apple.com/es/app/lopidoyo/id671685332?mt=8";
     
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];}];
     */
    
    //IALERT para poder cerrar VC
    
    /*
    [ILAlertView showWithTitle:@"Su informacion se envio correctamente!!" message:@"En menos de 24h recibirá por el email facilitado su contraseña" closeButtonTitle:nil secondButtonTitle:@"OK" tappedSecondButton:^{
        //cerramos VC
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    */
    
    //  mientras arreglo el del IALertrtView:
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Su incidencia se envio correctamente!!"
                                                        message:@"En breve procederemos a solucionarlo"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
     
    [alertView show];
    
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
   // SendEmailOK=false;
    
    //enviar manual:
    
    /*
     // open an alert with just an OK button
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [alert show];
     NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
     */
    
    //paramos el progress:
    
    //lo hacemos con KPProgressCircular mejor:
    [KVNProgress dismiss];
    
    self.basicConfiguration.backgroundType = KVNProgressBackgroundTypeBlurred;

    
    
    
    //y probamos el email  manual:
    [self ManualEmailSiFallaAutomatico];
    
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////PARA EMAIL MANUAL///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)ManualEmailSiFallaAutomatico{
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        
        // Email Subject
        NSString *emailTitle = @"nueva alta ghfincas ios";
        // Email Content
        NSString *tituloIncidencia=self.titulotext.text;
        NSString *DescripcionIncidencia=self.descripociontextview.text;
        
        
        NSString *messageBody = [NSString stringWithFormat:@"Gracias por enviarnos su email estos son sus datos:\n NOMBRE: %@\n TELEFONO: %@ \n Email: %@ \nCOMUNIDAD %@\n  \n \n \n TITULO: %@ \n \n DESCRIPCION: %@",PREF_NOMBREVECINO,PREF_TELEFONO,PREF_EMAIL,PREF_NOMBRECMUNIDAD,tituloIncidencia,DescripcionIncidencia];
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"interamaster@gmail.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        if (mc !=nil) {
            
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:nil];
        }
    }
    
    else {
        [self alertStatus:@"Fallo de envio compruebe su conexion a internet!!" :@"Error!" :0];
        
    }
    
}

//delegate del mail composer


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            //[self alertStatus:@"HA cancelado el envio, asi no podremos enviarle su password, vuelva a intentarlo" :@"Error!" :0];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            // [self alertStatus:@"HA guaradao su email, pero aun no se ha enviado,dele a enviar o no podremos facilitarle su password" :@"Error!" :0];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            // [self alertStatus:@"En menos de 24h recibirá por el email facilitado su contraseña" :@"Su informacion se envio correctamente!!" :0];
            
            
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            //   [self alertStatus:@"Fallo de envio compruebe su conexion a internet!!" :@"Error!" :0];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}




- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    
    
    //  mientras arreglo el del IALertrtView:
    
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
     message:msg
     delegate:self
     cancelButtonTitle:@"Ok"
     otherButtonTitles:nil, nil];
     alertView.tag = tag;
     [alertView show];
    
     
    
    
  //[ILAlertView showWithTitle:title message:msg closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    
    
    
    
    
    
}


//delegate del UIALertView mientras arreglo el del IALertrtView


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])//el OK de envio bien es en MATUSCULAS LAS 2 !!!!
    {
        NSLog(@"Envio OK saliendo");
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
     }

@end

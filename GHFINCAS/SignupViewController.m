//
//  SignupViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 29/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "SignupViewController.h"
//para el alertView  mas bonita

#import "ILAlertView.h"

#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h" // for Base64 encoding

@interface SignupViewController (){
    
    BOOL SendEmailOK;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL
    
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SendEmailOK=false;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL de moemnto en false
    
    
    
    //probamos a mandar e,mail del tiron....FUNCIONA!!!!
    
    [self sendEmailInBackground];
    
    
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



- (IBAction)btnsignup:(id)sender {
    
    
  
    
    if (![self validate]) {
        
        
        return;
    }
    //estan ok guaradsmos en PREF y enviamos email
    
     NSLog(@"datos registro ok");
    
    //guaradmos PREF:
    
    
       NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:PREF_NOMBREVECINO forKey:@"nombre_vecino"];
    [prefs setObject:PREF_EMAIL forKey:@"email"];
    [prefs setObject:PREF_TELEFONO forKey:@"telefono"];
    [prefs setObject:PREF_NOMBRECMUNIDAD forKey:@"nombre_comunidad"];
    [prefs synchronize];

    
}


//para validar los datos:

-(BOOL)validate{
    
    BOOL valid=true;
    
    PREF_NOMBRECMUNIDAD= [self.nombrecomunidad text];
    PREF_EMAIL =[self.email text];
    PREF_NOMBREVECINO=[self.Nombre text];
    PREF_TELEFONO=[self.telefono text];
    
    
    if (!PREF_NOMBREVECINO || PREF_NOMBREVECINO.length < 5) {
        
        [self alertStatus:@"Su nombre de ser completo con Apellidos para asegurar confidencialidad de datos a los que puede acceder!!!" :@"Error!" :0];
        
        
        valid = false;
    }
    
    //chequear email:
    //http://stackoverflow.com/questions/12259322/validate-the-email-address-in-uitextfield-in-iphone
    
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if (!PREF_EMAIL || [emailTest evaluateWithObject:PREF_EMAIL] == NO) {
        
         [self alertStatus:@"entre una direccion valida de email para poder enviarle su password" :@"Error!" :0];
        
        valid = false;
    }
    
    
    if (!PREF_TELEFONO || PREF_TELEFONO.length < 9 || PREF_TELEFONO.length > 9) {
         [self alertStatus:@"Por favor entre un numero de telefono valido!!" :@"Error!" :0];
        
        
        valid = false;
    }
    
    if (!PREF_NOMBRECMUNIDAD || PREF_NOMBRECMUNIDAD.length < 5) {
          [self alertStatus:@"Por favor introduzca el nombre completo de su comunidad!!" :@"Error!" :0];
       
        valid = false;
    }
    
    
    return valid;
    
    
}


- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
    */
    
    [ILAlertView showWithTitle:title message:msg closeButtonTitle:@"OK" secondButtonTitle:nil tappedSecondButton:nil];
    
    
    
    
    
    
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
    emailMessage.subject =@"nueva alta ghfincas ios";
    emailMessage.wantsSecure = YES;
    emailMessage.delegate = self; // you must include <SKPSMTPMessageDelegate> to your class
    NSString *messageBody = @"your email body message";
    //for example :   NSString *messageBody = [NSString stringWithFormat:@"Tour Name: %@\nName: %@\nEmail: %@\nContact No: %@\nAddress: %@\nNote: %@",selectedTour,nameField.text,emailField.text,foneField.text,addField.text,txtView.text];
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
    NSLog(@"delegate - message sent");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message sent." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    // open an alert with just an OK button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
}




@end

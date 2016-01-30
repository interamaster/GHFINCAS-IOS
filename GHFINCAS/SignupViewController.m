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

#import <MessageUI/MessageUI.h> //para ekl envio email manual si fall el otro


@interface SignupViewController (){
    
    BOOL SendEmailOK;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL
    
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SendEmailOK=false;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL de moemnto en false
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    PREF_EMAIL=[prefs stringForKey:@"email"];
    PREF_NOMBREVECINO=[prefs stringForKey:@"nombre_vecino"];
    PREF_TELEFONO=[prefs stringForKey:@"telefono"];
    PREF_NOMBRECMUNIDAD=[prefs stringForKey:@"nombre_comunidad"];
    
    if (PREF_EMAIL && PREF_NOMBRECMUNIDAD &&PREF_TELEFONO &&PREF_NOMBREVECINO) {
        self.email.text=PREF_EMAIL;
        self.telefono.text=PREF_TELEFONO;
        self.Nombre.text=PREF_NOMBREVECINO;
        self.nombrecomunidad.text=PREF_NOMBRECMUNIDAD;
        
    }
    
    
    //para el inidcator
    
    //self.progresscircular = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //self.progresscircular.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.progresscircular.alpha=0.0;
    
    
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
    
    
  

    //RECUPERAMOS EL PASSWORD
    PREF_PASSWORD=[prefs stringForKey:@"password"];
    
    
  
   
    
    
    //para el progressbar mientras se nvia email auto:
    
    //self.progresscircular = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //self.progresscircular.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    //self.progresscircular.center = self.view.center;
    //[self.view addSubview:self.progresscircular];
    //[self.progresscircular bringSubviewToFront:self.view];
    self.progresscircular.alpha=1.0;
    [self.progresscircular startAnimating];
    
    
   
    
    //probamos a mandar e,mail del tiron....FUNCIONA!!!!
    
    [self sendEmailInBackground];
    
    
    
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
   // NSString *messageBody = @"your email body message";
    //for example :   NSString *messageBody = [NSString stringWithFormat:@"Tour Name: %@\nName: %@\nEmail: %@\nContact No: %@\nAddress: %@\nNote: %@",selectedTour,nameField.text,emailField.text,foneField.text,addField.text,txtView.text];
    
    NSString *messageBody = [NSString stringWithFormat:@"Gracias por enviarnos su email estos son sus datos:\n NOMBRE: %@\n TELEFONO: %@ \n Email: %@ \nCOMUNIDAD %@\n ADFSDLIFSDLJKHDLKASHDLKHSLKJDHLSDHLKASDKJSKDJJDKJKLDLSKAJDLKAJSDKJLDJLKSJDLKAJSDLKSJADLKJASLDJASKDKJDLKJERIUF KLJHFDKHGJKFHKJHGKJHJKFJKDFHGKJHDFKJGHKJDFHGKJFHJKHJFGKJHFDKJGHKJFDHGJKFHGKJDKHGDFKHGJKFDHGKSHFJGHDFSKGKJFDHGKFHDSADASKDJKASJDLKAJDLKJSALKDJLKJKDLJSALKDJASLKDJLKASDJLKSDJKLSJDLKASJDLKJSLKJDLKJDDSJLKADJSLDSJAKSDKLDSLJ DNSDJLKAJJKVJKVSDIOUFISODUOIFSJKLKDLSFJLKSDJFLKDSJFKLJSDLKFJKLDSJFLKSJDFLKJSDLKFJKLDJFLKSDJFKLJSDFKLJSDKLFJSDKLF\n \n \n el password deberia ser ghfincas+2 utimos digitos del imei osea: %@",PREF_NOMBREVECINO,PREF_TELEFONO,PREF_EMAIL,PREF_NOMBRECMUNIDAD,PREF_PASSWORD];
    
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
    
    SendEmailOK=true;
     [self.progresscircular stopAnimating];
    self.progresscircular.alpha=0.0;
    
    NSLog(@"delegate - message sent");
   
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Su informacion se envio correctamente!!" message:@"En menos de 24h recibirá por el email facilitado su contraseña" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    */
    
    //conIALert
    
    
    [self alertStatus:@"En menos de 24h recibirá por el email facilitado su contraseña" :@"Su informacion se envio correctamente!!" :0];
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
     SendEmailOK=false;
    
    //enviar manual:
    
    /*
    // open an alert with just an OK button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
    */
    
    
    //probamos el manual:
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
    NSString *messageBody = @"iOS programming is so fun!";
    // NSString *messageBody = [NSString stringWithFormat:@"Gracias por enviarnos su email estos son sus datos:\n NOMBRE: %@\n TELEFONO: %@ \n Email: %@ \nCOMUNIDAD %@\n ADFSDLIFSDLJKHDLKASHDLKHSLKJDHLSDHLKASDKJSKDJJDKJKLDLSKAJDLKAJSDKJLDJLKSJDLKAJSDLKSJADLKJASLDJASKDKJDLKJERIUF KLJHFDKHGJKFHKJHGKJHJKFJKDFHGKJHDFKJGHKJDFHGKJFHJKHJFGKJHFDKJGHKJFDHGJKFHGKJDKHGDFKHGJKFDHGKSHFJGHDFSKGKJFDHGKFHDSADASKDJKASJDLKAJDLKJSALKDJLKJKDLJSALKDJASLKDJLKASDJLKSDJ%@LSJDLKASJDLKJSLKJDLKJDDSJLKADJSLDSJAKSDKLDSLJ DNSDJLKAJJKVJKVSDIOUFISODUOIFSJKLKDLSFJLKSDJFLKDSJFKLJSDLKFJKLDSJFLKSJDFLKJSDLKFJKLDJFLKSDJFKLJSDFKLJSDKLFJSDKLF\n \n \n  ",PREF_NOMBREVECINO,PREF_TELEFONO,PREF_EMAIL,PREF_NOMBRECMUNIDAD,PREF_PASSWORD];
    
    
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


@end

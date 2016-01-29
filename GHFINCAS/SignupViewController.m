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


@interface SignupViewController (){
    
    BOOL SendEmailOK;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL
    
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SendEmailOK=false;//PARASABER SI SE MANDO OK  O NO EL AUTO EMAIL de moemnto en false
    
    
    
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

@end

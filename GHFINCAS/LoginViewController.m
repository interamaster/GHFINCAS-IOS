//
//  LoginViewController.m
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 26/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "LoginViewController.h"
//para el alertView  mas bonita

#import "ILAlertView.h"


//par el html

#import "TFHpple.h"

//para la correcion Comunidad segun email

#import "CorrecionComunidadModel.h"

@interface LoginViewController ()



@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //al arrancar si ya existe los user y pass los ponemos:
    
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    PREF_EMAIL=[prefs stringForKey:@"email"];
    
    
    PREF_PASSWORD=[prefs stringForKey:@"password"];
    PREF_NOMBREVECINO=[prefs stringForKey:@"nombre_vecino"];
    PREF_TELEFONO=[prefs stringForKey:@"telefono"];
    PREF_NOMBRECMUNIDAD=[prefs stringForKey:@"nombre_comunidad"];
    
    
    PREF_BOOL_LOGINYAOK=[prefs boolForKey:@"loginyaok"];
    
    NSLog(@"email: %@",PREF_EMAIL);
    NSLog(@"passw: %@",PREF_PASSWORD);
    NSLog(@"vecino: %@",PREF_NOMBREVECINO);
    NSLog(@"telefono: %@",PREF_TELEFONO);
    NSLog(@"comunidad: %@",PREF_NOMBRECMUNIDAD);
    
    NSLog(@"loginyaok: %i",(int)PREF_BOOL_LOGINYAOK);
    
    
    //si existen y ya hemos hecho antes login los ponemos:
    
    
    if (PREF_EMAIL && PREF_PASSWORD &&PREF_BOOL_LOGINYAOK) {
        self.login.text=PREF_EMAIL;
        self.password.text=PREF_PASSWORD;

    }
    
    
    PREF_NUMERO_DEARRANQUES=[prefs integerForKey:@"numero_arranques"];
    PREF_NUMERO_DEARRANQUES++;
    
     NSLog(@"numero de arranques: %i",PREF_NUMERO_DEARRANQUES);
    
    //guaradamos
    [prefs setInteger:PREF_NUMERO_DEARRANQUES forKey:@"numero_arranques"];
    
    
    [prefs synchronize];
    
    
    //si ya hemos arranacadio algnua vez nos ahorramos el sacar el UDID(aqui nohay imei...)
    //TODO poner en 1
    if (PREF_NUMERO_DEARRANQUES<140) {
        [self EncontrarPassword];
        
    }
    
    
    if (PREF_NOMBRECMUNIDAD && PREF_EMAIL) {
        
        //si ya existen nombre comu y emailvecino chequeamos que esten ok:
        
          [self ChequearNombreComunidad];
    }
    
   
}




-(void)ChequearNombreComunidad{
    
    
 

//vamos a ahacerla ASYN del tiron!!:



NSURL *myUrl = [NSURL URLWithString:@"https://jrdvsoft.wordpress.com/correcion-comunidad/"];
NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl
                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                       timeoutInterval:10];

DataNombrecomunidad = [[NSMutableData alloc] initWithLength:0];

NSURLConnection *myConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:YES];

}


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////DELEGATE ASYN TASK//////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [DataNombrecomunidad setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //aqui aun NO tenemos la web!!!
    
    [DataNombrecomunidad appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // The request has failed for some reason!
    // Check the error var
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    //download finished - data is available in myData.
    //aqui ya tenemos la web!!!
    
    // NSLog(@"ya tenemos la web!! %@",DatanotificacionesTable);
    
   
    //1ºhacemos el Parse a texto:
    
    
    TFHpple *tutorialsParser=  [TFHpple hppleWithHTMLData:DataNombrecomunidad];
    
    
    
    NSString *tutorialsXpathQueryString = @"//table[@class='CorreccionComunidad']//tr";
    
    
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    if ([tutorialsNodes count] == 0)
        NSLog(@"nothing there");
    else
        NSLog(@"There are %d nodes", [tutorialsNodes count]);
    
    
    
    
    //2º)Filtramos
    
    NSMutableArray *newTutorials=[[  NSMutableArray alloc] initWithCapacity:0];
    
    NSUInteger index = 0;//para salatrno el peimrmor que son los titulo(header th)
    
    for ( TFHppleElement *element in  tutorialsNodes){
        
        
        
        if (index>0) {//la primera columa es el titulo de latable(email/comunidad/todos....no lo quiero
            index++;
            
            //solo si es >0
            
            if (element.raw.length>0){
                
                //http://stackoverflow.com/questions/16849797/trying-to-pull-tabledata-out-from-html
                
                NSString *cadenadevuleta=element.raw;
                
                NSArray* separatedParts = [cadenadevuleta componentsSeparatedByString:@"<td>"];
                NSMutableArray* arrayOfResults = [[NSMutableArray alloc] init];
                for (int i = 1; i < separatedParts.count; i++) {
                    NSRange range = [[separatedParts objectAtIndex:i] rangeOfString:@"</td>"];
                    NSString *partialResult = [[separatedParts objectAtIndex:i] substringToIndex:range.location];
                    [arrayOfResults addObject:partialResult];
                    
                    
                    
                }
                
                CorrecionComunidadModel *correEmail=[[CorrecionComunidadModel alloc]init ];
                
                [newTutorials addObject:correEmail];
                
                correEmail.WebComunidad=[arrayOfResults objectAtIndex:0];
                correEmail.WebEmail=[arrayOfResults objectAtIndex:1];
                
                
                //ahora chequeamos si es corecto o no:
                
                if ([correEmail.WebEmail isEqualToString:PREF_EMAIL] ) {
                    //si esta en la lista es px hay que chequea el nombre  de la comunidad
                    
                    if ( [correEmail.WebComunidad isEqualToString:PREF_NOMBRECMUNIDAD]){
                        
                        //si ya esta cambiado de antes salimos
                        
                        break;
                        
                    }
                    
                    
                    //guaradmos PREF con nombre OK
                    
                      NSLog(@"cambiada comunidad de :%@  a  %@ ",PREF_NOMBRECMUNIDAD , correEmail.WebComunidad);
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    
                
                    [prefs setObject:correEmail.WebComunidad forKey:@"nombre_comunidad"];
                    
                    
                    [prefs synchronize];
                    
                    NSLog(@"cambiada comunidad de :%@  a  %@ ",PREF_NOMBRECMUNIDAD , correEmail.WebComunidad);
                    
                    
                    break;//con esto ya salimos dl for loop
                    
                }
                
                
                
            }
        }
        
        index++;
    }
    
    
    
    
}






-(void)EncontrarPassword{
    
    
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
        // iOS 6+
        NSUUID *uid = [[UIDevice currentDevice] identifierForVendor];
        NSString *uidStr = [uid UUIDString];
        NSLog(@"para ios6+ el uidid:%@",uidStr);
        NSString *passwordesdeUFID=[NSString stringWithFormat:@"%@%@",@"ghfincas",[uidStr substringToIndex:2]];
        NSLog(@"password creado %@",passwordesdeUFID);
        
        
        
        
        
        //lo guaradamos en PREFS
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:passwordesdeUFID forKey:@"password"];
        [prefs synchronize];
        
    }
    
    else
    {
        // before iOS 6, so just generate an identifier and store it
        CFUUIDRef locUDIDRef = CFUUIDCreate(NULL);
        CFStringRef locUDIDRefString = CFUUIDCreateString(NULL, locUDIDRef);
        NSString *uidStr = [NSString stringWithString:(__bridge NSString *) locUDIDRefString];
        CFRelease(locUDIDRef);
        CFRelease(locUDIDRefString);
        
         NSLog(@"para ios6- el uidid:%@",uidStr);
        
        NSString *passwordesdeUFID=[NSString stringWithFormat:@"%@%@",@"ghfincas",[uidStr substringToIndex:2]];
        NSLog(@"password creado %@",passwordesdeUFID);
        //lo guardamos en PREFS
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:passwordesdeUFID forKey:@"password"];
        [prefs synchronize];
        
    }
    
    
    
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
            
           self.autolgin.on=NO;//esto e s el switch de autologing
            
            
            
        } else {
            
            //de momento estara ok
            
            [self.autolgin setOn:YES animated:YES];
            
            
            //chequeamos el password solo
            if (([[self.password text]isEqualToString:@"sevilla"]) || ([[self.password text]isEqualToString:PREF_PASSWORD])) {
                
                   [self LoginSuces];
            }
            
            else {
                
                //algo esta mal
                
                 [self alertStatus:@"Introduce email y password correctos " :@"Error!" :0];
            }
         
            
            
                   }
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



-(void)LoginSuces{
    
    
    //par el progressView
    
    
    self.progressView = [[UCZProgressView alloc] initWithFrame:self.view.bounds];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.progressView.tintColor = [UIColor greenColor];
    self.progressView.showsText = YES;
    self.progressView.radius = 100.0;
    [self.view addSubview:self.progressView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_progressView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
    
    
    self.progressView.progress=0.0;
    
    self.timerProgressBar=[NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(increaseProgressBar)
                                   userInfo:nil
                                    repeats:YES];
    
    //[self performSegueWithIdentifier:@"login_success" sender:self];
    
    //yponemos el BOLL delo login ya a TRUE:
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    //guaradamos
    [prefs  setBool:true forKey:(@"loginyaok")];
    
    
    [prefs synchronize];
    
    
}

-(void)increaseProgressBar {
    
    self.progressView.progress=self.progressView.progress+0.1;
    
    NSLog(@"increase  progress bar!");

    
    if (self.progressView.progress >=1){
        
        //llego al 100%
        
        NSLog(@"100 progress bar!");
        
        //paramos el timer:
        
        [self.timerProgressBar invalidate];
        
        
        
        //pasamos al FristVCEmpresa)
        
        [self performSegueWithIdentifier:@"login_success" sender:self];
        
    }
        
        
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

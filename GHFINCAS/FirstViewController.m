//
//  FirstViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 25/01/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "FirstViewController.h"
//para el alertView que marque el telfono

#import "ILAlertView.h"



@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIButton *telefono24h;

@end

@implementation FirstViewController
- (IBAction)pulsado_telefono24h:(id)sender {
    
    //NSLog(@"pulsado en 24h");
    
    NSString *phNo = @"673787175";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phNo]];
    
     if([[UIApplication sharedApplication] canOpenURL:phoneUrl]){
        
        [ILAlertView showWithTitle:@"LLAMAR GHFINCAS!!"
                           message:[@"Quieres llamar a " stringByAppendingString:phNo]
                  closeButtonTitle:@"No"
                 secondButtonTitle:@"SI"
                tappedSecondButton:^{
                    //aqui ahora llamamos al telefno
                    [[UIApplication sharedApplication] openURL:phoneUrl];
                    
                }];
        
        
     };
}
- (IBAction)pulsado_info:(id)sender {
     NSLog(@"pulsado info");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //ole yo 2
    
    
    
    CLTickerView *ticker = [[CLTickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    
    ticker.marqueeStr =  @"Somos especialistas en la gestión y administración de comunidades de propietarios. Nuestro compromiso es el de ofrecer el mejor servicio al mejor precio para obtener la confianza del propietario mediante nuestro esfuerzo y trabajo.";
    
    ticker.marqueeFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    [self.TextoMovible addSubview:ticker];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
- (IBAction)logo_pulsado:(id)sender {
    
       NSLog(@"pulsado 7 veces logo!!!");
}
@end

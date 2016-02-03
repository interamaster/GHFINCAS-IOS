//
//  DetalleProveedorViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 03/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "DetalleProveedorViewController.h"


//para elasyn de las imagees




#import "UIImageView+WebCache.h"


//para el alertView que marque el telfono

#import "ILAlertView.h"




@interface DetalleProveedorViewController ()

@end

@implementation DetalleProveedorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.NombreProveedor.text=self.ProveedorPasado.ProveedorName;
    //self.WebDescripcion=self.ProveedorPasado.ProveedorDescripcion;
    [self.WebDescripcion loadHTMLString:self.ProveedorPasado.ProveedorDescripcion baseURL:nil];
    
    
    
    [self.FotoProveedor  sd_setImageWithURL:[NSURL URLWithString:self.ProveedorPasado.ProveedorImagen] placeholderImage:[UIImage imageNamed:@"logo7.jpg"] ];
    
    
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

- (IBAction)BotonLlamar:(id)sender {
    
    
    
   // NSString *phNo = @"673787175";
    
    NSString *phNo = self.ProveedorPasado.ProveedorTelefono;
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phNo]];
    
    
    
    
    
    
    if([[UIApplication sharedApplication] canOpenURL:phoneUrl]){
        
        [ILAlertView showWithTitle:@"LLAMAR PROVEEDOR!!"
                           message:[@"Quieres llamar a " stringByAppendingString:phNo]
                  closeButtonTitle:@"No"
                 secondButtonTitle:@"SI"
                tappedSecondButton:^{
                    //aqui ahora llamamos al telefno
                    [[UIApplication sharedApplication] openURL:phoneUrl];
                    
                }];
        
        
    };
}
@end

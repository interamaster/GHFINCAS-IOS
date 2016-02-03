//
//  DetalleProveedorViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 03/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProveedorModel.h"



@interface DetalleProveedorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *FotoProveedor;

@property (strong, nonatomic) IBOutlet UIWebView *WebDescripcion;
@property(nonatomic,strong)ProveedorModel *ProveedorPasado;
@property (strong, nonatomic) IBOutlet UILabel *NombreProveedor;
- (IBAction)BotonLlamar:(id)sender;

@end

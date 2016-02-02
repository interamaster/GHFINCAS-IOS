//
//  ProveedoresCellTableViewCell.h
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 02/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProveedorModel.h"

@interface ProveedoresCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *Proveedrorfoto;
@property (weak, nonatomic) IBOutlet UILabel *nameProveedor;
@property (weak, nonatomic) IBOutlet UILabel *descripcionProveedor;


- (void)setupWithDictionary:(NSDictionary *)dictionary;

//mio para psarle el proveedor:
-(void)llenarconProveedor:(ProveedorModel *)proveedor;

@end

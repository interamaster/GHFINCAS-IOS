//
//  ProveedoresCellTableViewCell.m
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 02/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "ProveedoresCellTableViewCell.h"


#import "ProveedorModel.h"


//par el html text

#import "NSString_stripHtml.h"




@implementation ProveedoresCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setupWithDictionary:(NSDictionary *)dictionary
{
    
    //NO SE USA!!!
    
    
    
    self.mainView.layer.cornerRadius = 10;
    self.mainView.layer.masksToBounds = YES;
    
    //self.Proveedrorfoto.image = [UIImage imageNamed:[dictionary valueForKey:@"image"]];//asi es i esta en local!!
    
    /*
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
     UIImage *img = ...;
     [dict setObject:img forKey:@"aKeyForYourImage"];
     
     UIImage *imgAgain = [dict objectForKey:@"aKeyForYourImage"];

     */
    
    
    //self.Proveedrorfoto.image=[dictionary objectForKey:@"image"];//asi la imagen del tiron

    self.nameProveedor.text = [dictionary valueForKey:@"name"];
   // self.descripcionProveedor.text = [dictionary valueForKey:@"Descripcion"];
    //lo pngo con formato HTML:
    //http://stackoverflow.com/questions/277055/remove-html-tags-from-an-nsstring-on-the-iphone
    
    NSString *htmlString=[[dictionary valueForKey:@"Descripcion"] stripHtml];
    
    
    
    
    self.descripcionProveedor.text = htmlString;
    
}


-(void)llenarconProveedor:(ProveedorModel *)proveedor{
    
    
    self.mainView.layer.cornerRadius = 10;
    self.mainView.layer.masksToBounds = YES;

    
    self.nameProveedor.text =proveedor.ProveedorName;
   // self.descripcionProveedor.text = proveedor.ProveedorDescripcion;
    
    
    //lo pngo con formato HTML:
    
    NSString *htmlString=[ proveedor.ProveedorDescripcion stripHtml];
    
    
    
    
    self.descripcionProveedor.text = htmlString;
    //pte foto!!!
    
    
    

    
}



@end

//
//  NotificacionesTableViewCell.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 05/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//


#define BodyLabelYOrigin 30
#define BodyLabelWidth 200


#import "NotificacionesTableViewCell.h"

//para el model

#import "NotificacionModel.h"


@implementation NotificacionesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)llenarconNotificacioens:(NotificacionModel *)notificacion{
    
    self.NotificacionTexto.text=notificacion.NotificacionWebComunicado;
    self.NotificacioenFechatexto.text=notificacion.NotificacionWebFechaComunicado;
    
}

@end

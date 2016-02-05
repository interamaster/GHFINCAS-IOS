//
//  NotificacionesTableViewCell.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 05/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

//para el model

#import "NotificacionModel.h"

@interface NotificacionesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NotificacionTexto;
@property (strong, nonatomic) IBOutlet UILabel *NotificacioenFechatexto;



//mio para psarle las notis:
-(void)llenarconNotificacioens:(NotificacionModel *)notificacion;
@end

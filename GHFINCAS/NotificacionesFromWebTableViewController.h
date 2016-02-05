//
//  NotificacionesFromWebTableViewController.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 05/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificacionesFromWebTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>

{
    
    NSMutableData *DatanotificacionesTable;
    
    //ivars para email /nombrecomunidad 
    
    NSString *PREF_EMAIL;
   
    NSString *PREF_NOMBRECMUNIDAD;
   
}


@end

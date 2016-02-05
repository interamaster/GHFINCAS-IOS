//
//  NotificacionesFromWebTableViewController.m
//  GHFINCAS
//
//  Created by jose ramon delgado on 05/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "NotificacionesFromWebTableViewController.h"

//para el model

#import "NotificacionModel.h"

//par el html

#import "TFHpple.h"

//para la cell

#import "NotificacionesTableViewCell.h"



@interface NotificacionesFromWebTableViewController ()

@property (strong, nonatomic) NSArray *NotoficacionesParaTabledesdeWEBSINFILTRAR;
@property (strong, nonatomic) NSMutableArray *NotoficacionesParaTabledesdeWEBOK;
@end

@implementation NotificacionesFromWebTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    //al arrancar  recuperamos EMAIL y nombre comunidad por si le aplica lagiuna notificacionn!!!
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    PREF_EMAIL=[prefs stringForKey:@"email"];
    
    PREF_NOMBRECMUNIDAD=[prefs stringForKey:@"nombre_comunidad"];
    
    
    NSLog(@"email: %@",PREF_EMAIL);
   
    NSLog(@"comunidad: %@",PREF_NOMBRECMUNIDAD);
    
   
    //le ponemos el fondo
    
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo7.jpg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
    [self CargaNotificacionesFromWeb];
    
}


-(void)CargaNotificacionesFromWeb{
    
    //vamos a ahacerla ASYN del tiron!!:
    
    
    
    NSURL *myUrl = [NSURL URLWithString:@"https://jrdvsoft.wordpress.com/comunicados-prueba/"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:10];
    
    DatanotificacionesTable = [[NSMutableData alloc] initWithLength:0];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:YES];
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////DELEGATE ASYN TASK//////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [DatanotificacionesTable setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //aqui aun NO tenemos la web!!!
    
    [DatanotificacionesTable appendData:data];
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
    
    [self FiltrarWeb];
    
    
    
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////




-(void)FiltrarWeb{
    
    //1ºhacemos el Parse a texto:
    
    
    TFHpple *tutorialsParser=  [TFHpple hppleWithHTMLData:DatanotificacionesTable];
    
    
    
    NSString *tutorialsXpathQueryString = @"//table[@class='Comunicados']//tr";//[translate(., '&#xA;', '')]";
    
    
    
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
                
                NotificacionModel *notis=[[NotificacionModel alloc]init ];
                
                [newTutorials addObject:notis];
                
                notis.NotificacionWebComunidad=[arrayOfResults objectAtIndex:0];
                notis.NotificacionWebEmail=[arrayOfResults objectAtIndex:1];
                notis.NotificacionWebTODOS=[arrayOfResults objectAtIndex:2];
                notis.NotificacionWebComunicado=[arrayOfResults objectAtIndex:3];
                notis.NotificacionWebFechaComunicado=[arrayOfResults objectAtIndex:4];
                
            
            }
        }
        
          index++;
    }
    
    
    
    //3º)ya tenesmo los valores de la tabla en un array listo para la tablkeview!!!
    //  PWERO 1º HAY QUIE FILTRARLO!!!
    
    self.NotoficacionesParaTabledesdeWEBSINFILTRAR= newTutorials;
    
    
    [self FiltrarArrayNotisFromWebFinal];
    
    
}


-(void)FiltrarArrayNotisFromWebFinal{
    
    self.NotoficacionesParaTabledesdeWEBOK=[[NSMutableArray alloc]init  ];
    
    
    
    for ( NotificacionModel *element in  self.NotoficacionesParaTabledesdeWEBSINFILTRAR){

    
    
    //1º)Vemos si es para todos
        
        if ([element.NotificacionWebTODOS isEqualToString:@"SI"]) {
            [self.NotoficacionesParaTabledesdeWEBOK addObject:element];
            
            NSLog(@"añadido un com de TODOS!");
            continue;
        }
    
    
    
    //2º) vemos cuales son  para este email
    
        if ([element.NotificacionWebEmail isEqualToString:PREF_EMAIL]) {
            [self.NotoficacionesParaTabledesdeWEBOK addObject:element];
            
               NSLog(@"añadido un com de email: %@",PREF_EMAIL);
            
            
            continue;
        }
    
    
    
    //3º)Vemos cuales son pra esta comunidad
    
      if ([element.NotificacionWebComunidad isEqualToString:PREF_NOMBRECMUNIDAD]) {  //asi si hay un espacio no las considera iguales!!!!
          
          [self.NotoficacionesParaTabledesdeWEBOK addObject:element];
            
              NSLog(@"añadido para ciomunidad: %@",PREF_NOMBRECMUNIDAD);
            
            continue;
        }
        
    }
    
    //4º)refrescamos la tableview
    
    
    
    
      [self.tableView reloadData];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    // Return the number of rows in the section.
    return [self.NotoficacionesParaTabledesdeWEBOK count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    static NSString *CellIdentifier = @"NotificacionesCell";
    NotificacionesTableViewCell *cell = (NotificacionesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // [cell setupWithDictionary:[self.members objectAtIndex:indexPath.row]];
    
    [cell llenarconNotificacioens:[self.NotoficacionesParaTabledesdeWEBOK objectAtIndex:indexPath.row]];
    
    
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

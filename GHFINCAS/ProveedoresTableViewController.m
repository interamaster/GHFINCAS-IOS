//
//  ProveedoresTableViewController.m
//  GHFINCAS
//
//  Created by Jose Ramon MBP on 02/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

#import "ProveedoresTableViewController.h"

//par ala cell


#import "ProveedoresCellTableViewCell.h"


//par el html

#import "TFHpple.h"
#import "ProveedorModel.h"


//para el parallax


#import "ParallaxHeaderView.h"

//para el detalleProveedor

#import "DetalleProveedorViewController.h"


@interface ProveedoresTableViewController ()

@property (strong, nonatomic) NSArray *members;

@end

@implementation ProveedoresTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //de java:
     //String url = "https://jrdvsoft.wordpress.com/prueba-tabla/";
    
    
    
    //parallalalax
    
    
    // Create ParallaxHeaderView with specified size, and set it as uitableView Header, that's it
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"logo7.jpg"]
                                                                             forSize:CGSizeMake(self.tableView.frame.size.width, 200)];
    
    
    
    
    headerView.headerTitleLabel.text =  @"Proveedores de Confianza";
    
    [self.tableView  setTableHeaderView:headerView];
    
    [self CargaProvvedoresFromTableWordPress];
    
    
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


-(void)CargaProvvedoresFromTableWordPress{
    
      NSURL *tutorialsUrl  =[NSURL URLWithString:@"https://jrdvsoft.wordpress.com/prueba-tabla/"];
      NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    
    
    
    
     /*
    // PTE pra hacerl ASYNC!!
    NSURLRequest *site_request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jrdvsoft.wordpress.com/prueba-tabla/"]
                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                 timeoutInterval:10.0];
    
    NSURLConnection *site_connection =
    [[NSURLConnection alloc] initWithRequest:site_request delegate:self];
*/
  
   
    
   
    
    TFHpple *tutorialsParser=  [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    
    
    NSString *tutorialsXpathQueryString = @"//table[@class='ListaProveedores']//tr";//[translate(., '&#xA;', '')]";
    
   

    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    if ([tutorialsNodes count] == 0)
        NSLog(@"nothing there");
    else
        NSLog(@"There are %d nodes", [tutorialsNodes count]);
    
    
    
    
    NSMutableArray *newTutorials=[[  NSMutableArray alloc] initWithCapacity:0];
    
    NSUInteger index = 0;//para salatrno el peimrmor que son los titulo(header th)
    
    for ( TFHppleElement *element in  tutorialsNodes){
        
       
        
        if (index>0) {
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
            
            
            /* esto da lo que quiero!!!:
             
             
             Printing description of arrayOfResults:
             <__NSArrayM 0x7f8a004ee860>(
             0,
             ASCENSORES URGENCIA 24 H,
             <strong>Teléfonos urgencias</strong>
             <p> <br/>
             OTIS <span style="font-family:inherit;font-size:inherit;line-height:1.7;"><a href="tel:901240024">901.24.00.24</a></span></p>
             <p>ORONA <a href="tel:954253869">954.25.38.69</a></p>
             <p>JP ASCENSORES <a href="tel:661003215">661.00.32.15</a></p>
             <p>SCHINDLER <a href="tel:900400272">900.40.02.72</a></p>
             <p>THYSSEN <a href="tel:954515977">954.51.59.77</a></p>
             <p>CARBONELL <a href="tel:954276598">954.27.65.98</a></p>
             <p> </p>,
             <img class="alignnone size-full wp-image-68" src="https://jrdvsoft.files.wordpress.com/2015/12/ascensor.png?w=960" alt="ascensor"/>
             )
             */
   
        }
            
            //una vez todos en el aray +se lo pasamos ok al member array:
            
            ProveedorModel *tutorial =[[ProveedorModel  alloc] init];
            
            
            [newTutorials addObject:tutorial];
            
            
            tutorial.ProveedorTelefono =[arrayOfResults objectAtIndex:0];
             tutorial.ProveedorName =[arrayOfResults objectAtIndex:1];
            tutorial.ProveedorDescripcion=[arrayOfResults objectAtIndex:2];
           // tutorial.ProveedorImagen=[arrayOfResults objectAtIndex:3];
            
            
            
            
            //amos a sacra la image correcta soo con la src:
            
            
            NSArray* soloimagen = [cadenadevuleta componentsSeparatedByString:@"src="];
            NSMutableArray* arrayOfImagsrc = [[NSMutableArray alloc] init];
            for (int i = 1; i < soloimagen.count; i++) {
                NSRange range = [[soloimagen objectAtIndex:i] rangeOfString:@"?"];
                NSString *partialResult = [[soloimagen objectAtIndex:i] substringToIndex:range.location];
                [arrayOfImagsrc addObject:partialResult];
                
            }
            
            
            NSLog(@"imagensrc: %@",[arrayOfImagsrc objectAtIndex:0]);
            
            
            /*
              imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/ascensor.png
              imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/alcantarillado2.png
              imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/extintor1.png
               imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/repvarias.png
               imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/gas.png
               imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/logo_andisur_alta.jpg
               imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/ac.jpg
              imagensrc: "https://jrdvsoft.files.wordpress.com/2015/12/logo-asesorialomas.png
              . . .
             */
            
            
            //sale OK solo falta quitar la ", pero ponendola en la busqueda ' tampoco sale..
            
            
            NSString *src=[arrayOfImagsrc objectAtIndex:0];
            
            
            if ( [src length] > 1) {
                src = [src substringFromIndex:1];
            }
            
            tutorial.ProveedorImagen=src;
            
        
        }
        
        }
        
        index++;
        
        
    }
    
    
   self.members= newTutorials;//ya los tengo ok en formato raw!! de momento
    
    
    
    [self.tableView reloadData];
 
  

}





-(void)connection:(NSURLConnection *)site_connection didReceiveData:(NSData *)data
{
   // _responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
     [_responseData appendData:data];
    
    
    
    
    
    TFHpple *tutorialsParser=  [TFHpple hppleWithHTMLData:_responseData];
    
    
    
    NSString *tutorialsXpathQueryString = @"//table[@class='ListaProveedores']//tr";//[translate(., '&#xA;', '')]";
    
    
    
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    if ([tutorialsNodes count] == 0)
        NSLog(@"nothing there");
    else
        NSLog(@"There are %d nodes", [tutorialsNodes count]);
    
    
    
    
    NSMutableArray *newTutorials=[[  NSMutableArray alloc] initWithCapacity:0];
    
    NSUInteger index = 0;//para salatrno el peimrmor que son los titulo(header th)
    
    for ( TFHppleElement *element in  tutorialsNodes){
        
        
        
        if (index>0) {
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
                    
                    
                    /* esto da lo que quiero!!!:
                     
                     
                     Printing description of arrayOfResults:
                     <__NSArrayM 0x7f8a004ee860>(
                     0,
                     ASCENSORES URGENCIA 24 H,
                     <strong>Teléfonos urgencias</strong>
                     <p> <br/>
                     OTIS <span style="font-family:inherit;font-size:inherit;line-height:1.7;"><a href="tel:901240024">901.24.00.24</a></span></p>
                     <p>ORONA <a href="tel:954253869">954.25.38.69</a></p>
                     <p>JP ASCENSORES <a href="tel:661003215">661.00.32.15</a></p>
                     <p>SCHINDLER <a href="tel:900400272">900.40.02.72</a></p>
                     <p>THYSSEN <a href="tel:954515977">954.51.59.77</a></p>
                     <p>CARBONELL <a href="tel:954276598">954.27.65.98</a></p>
                     <p> </p>,
                     <img class="alignnone size-full wp-image-68" src="https://jrdvsoft.files.wordpress.com/2015/12/ascensor.png?w=960" alt="ascensor"/>
                     )
                     */
                    
                    
                }
                
                //una vez todos en el aray +se lo pasamos ok al member array:
                
                ProveedorModel *tutorial =[[ProveedorModel  alloc] init];
                
                
                [newTutorials addObject:tutorial];
                
                
                tutorial.ProveedorTelefono =[arrayOfResults objectAtIndex:0];
                tutorial.ProveedorName =[arrayOfResults objectAtIndex:1];
                tutorial.ProveedorDescripcion=[arrayOfResults objectAtIndex:2];
                tutorial.ProveedorImagen=[arrayOfResults objectAtIndex:3];
                
                //amos a sacra la image correcta soo con la src:
                
                
                NSArray* soloimagen = [cadenadevuleta componentsSeparatedByString:@"src='"];
                NSMutableArray* arrayOfImagsrc = [[NSMutableArray alloc] init];
                for (int i = 1; i < soloimagen.count; i++) {
                    NSRange range = [[soloimagen objectAtIndex:i] rangeOfString:@"?"];
                    NSString *partialResult = [[soloimagen objectAtIndex:i] substringToIndex:range.location];
                    [arrayOfImagsrc addObject:partialResult];

                  }
                
                
                NSLog(@"imagensrc: %@",[arrayOfImagsrc objectAtIndex:0]);
            }
            
        }
        
        index++;
        
        
    }
    
    
    self.members= newTutorials;//ya los tengo ok en formato raw!! de momento
    
    
    
    [self.tableView reloadData];
    
    
}


-(NSString *)scanString:(NSString *)string
startTag:(NSString *)startTag
endTag:(NSString *)endTag
{
    
    NSString* scanString = @"";
    
    if (string.length > 0) {
        
        
        
        NSArray* separatedParts = [string componentsSeparatedByString:@"<td>"];
        NSMutableArray* arrayOfResults = [[NSMutableArray alloc] init];
        for (int i = 1; i < separatedParts.count; i++) {
            NSRange range = [[separatedParts objectAtIndex:i] rangeOfString:@"</td>"];
            NSString *partialResult = [[separatedParts objectAtIndex:i] substringToIndex:range.location];
            [arrayOfResults addObject:partialResult];
        }
        
        /* esrto da lo que quiero!!!:
         
         
         Printing description of arrayOfResults:
         <__NSArrayM 0x7f8a004ee860>(
         0,
         ASCENSORES URGENCIA 24 H,
         <strong>Teléfonos urgencias</strong>
         <p> <br/>
         OTIS <span style="font-family:inherit;font-size:inherit;line-height:1.7;"><a href="tel:901240024">901.24.00.24</a></span></p>
         <p>ORONA <a href="tel:954253869">954.25.38.69</a></p>
         <p>JP ASCENSORES <a href="tel:661003215">661.00.32.15</a></p>
         <p>SCHINDLER <a href="tel:900400272">900.40.02.72</a></p>
         <p>THYSSEN <a href="tel:954515977">954.51.59.77</a></p>
         <p>CARBONELL <a href="tel:954276598">954.27.65.98</a></p>
         <p> </p>,
         <img class="alignnone size-full wp-image-68" src="https://jrdvsoft.files.wordpress.com/2015/12/ascensor.png?w=960" alt="ascensor"/>
         )
         */
        
        
        
        
        
        
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        
        @try {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            NSLog(@"encontrado string: %@",scanString);
            return scanString;
        }
        
    }
    
    
    NSLog(@"encontrado string: %@",scanString);
    
    return scanString;
    
    
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
   // return 0;
    
     return [self.members count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    
    static NSString *CellIdentifier = @"ProveedorCell";
    ProveedoresCellTableViewCell *cell = (ProveedoresCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // [cell setupWithDictionary:[self.members objectAtIndex:indexPath.row]];
    
    [cell llenarconProveedor:[self.members objectAtIndex:indexPath.row]];
    
    
    return cell;

    
    // Configure the cell...
    
    //return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([[segue identifier] isEqualToString:@"DetalleProveedor"])
    {
        DetalleProveedorViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow]; 
        detailViewController.ProveedorPasado=[self.members objectAtIndex:indexPath.row];
        
        // and add any other code which you want to perform.
        
    }
}


@end

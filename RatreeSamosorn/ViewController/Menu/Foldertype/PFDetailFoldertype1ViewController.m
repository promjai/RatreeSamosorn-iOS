//
//  PFDetailFoldertype1ViewController.m
//  DeLanna
//
//  Created by Pariwat on 8/8/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFDetailFoldertype1ViewController.h"

@interface PFDetailFoldertype1ViewController ()

@end

@implementation PFDetailFoldertype1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.foldertype1Offline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;

    [self.RatreeSamosornApi getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFRatreeSamosornApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response {
    //NSLog(@"folder %@",response);
    
    [self.waitView removeFromSuperview];
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self.foldertype1Offline setObject:response forKey:@"foldertype1Array"];
    [self.foldertype1Offline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFRatreeSamosornApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    for (int i=0; i<[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[[self.foldertype1Offline objectForKey:@"foldertype1Array"] objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSString *type = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"]];
    
    if ([type isEqualToString:@"folder"]) {
        PFFoldertype1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertype1Cell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertype1Cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *img = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    } else {
        PFFoldertypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertypeCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertypeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.image.layer.masksToBounds = YES;
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *img = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.image.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.price.text = [[NSString alloc] initWithFormat:@"%@%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"],@" ฿"];
        cell.detail.text = [[NSString alloc] initWithString:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"]];
        
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
        
        if ([children_length isEqualToString:@"0"]) {
            [[[UIAlertView alloc] initWithTitle:@"ราตรีสโมสร"
                                        message:@"Coming soon."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        } else {
            PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
            if(IS_WIDESCREEN) {
                foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
            } else {
                foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
            }
            self.navigationItem.title = @" ";
            foldertypeView.obj = [self.arrObj objectAtIndex:indexPath.row];
            foldertypeView.delegate = self;
            [self.navigationController pushViewController:foldertypeView animated:YES];
        }
        
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"product"]) {
        
        NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
        
        if ([children_length isEqualToString:@"0"]) {
            [[[UIAlertView alloc] initWithTitle:@"ราตรีสโมสร"
                                        message:@"Coming soon."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        } else {
            PFFoodAndDrinkDetailViewController *detailView = [[PFFoodAndDrinkDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController_Wide" bundle:nil];
            } else {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController" bundle:nil];
            }
            self.navigationItem.title = @" ";
            detailView.obj = [self.arrObj objectAtIndex:indexPath.row];
            detailView.delegate = self;
            [self.navigationController pushViewController:detailView animated:YES];
        }
        
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFDetailFoldertypeViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
}

- (void)PFFoodAndDrinkDetailViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFDetailFoldertype1ViewControllerBack)]){
            [self.delegate PFDetailFoldertype1ViewControllerBack];
        }
    }
}


@end

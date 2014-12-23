//
//  PFSeeprofileViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFSeeprofileViewController.h"

@interface PFSeeprofileViewController ()

@end

@implementation PFSeeprofileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Profile";
    } else {
        self.navigationItem.title = @"โปรไฟล์";
    }
    
    self.tableView.tableHeaderView = self.headerView;
    self.bgheaderView.layer.shadowOffset = CGSizeMake(0.5, -0.5);
    self.bgheaderView.layer.shadowRadius = 2;
    self.bgheaderView.layer.shadowOpacity = 0.1;
    
    self.obj = [[NSDictionary alloc] init];
    
    self.rowCount = [[NSString alloc] init];
    
    [self.RatreeSamosornApi profile:self.user_id];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFRatreeSamosornApi:(id)sender getUserByIdResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"Me %@",response);
    
    [self.waitView removeFromSuperview];
    
    self.display_name.text = [response objectForKey:@"display_name"];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.RatreeSamosornApi getUserSettingById:self.user_id];
}

- (void)PFRatreeSamosornApi:(id)sender getUserByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFRatreeSamosornApi:(id)sender getUserSettingResponse:(NSDictionary *)response {
    self.objUsersetting = response;
    //NSLog(@"getUserSetting %@",response);
    
    int count = [[response objectForKey:@"show_facebook"] intValue]+[[response objectForKey:@"show_email"] intValue]+[[response objectForKey:@"show_website"] intValue]+[[response objectForKey:@"show_mobile"] intValue]+[[response objectForKey:@"show_gender"] intValue]+[[response objectForKey:@"show_birth_date"] intValue];
    self.rowCount = [NSString stringWithFormat:@"%d",count];
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowCount intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFAccountCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFAccountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        if ([[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 1) {
            cell.imgrow.image = [UIImage imageNamed:@"ic_fb.png"];
            cell.detailrow.text = [self.obj objectForKey:@"fb_name"];
        } else {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] == 1 && [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 0) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_mail.png"];
                cell.detailrow.text = [self.obj objectForKey:@"email"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEmail:)];
                [cell addGestureRecognizer:singleTap];
                
            } else {
                if ([[self.objUsersetting objectForKey:@"show_website"] intValue] == 1 && [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_email"] intValue] == 0) {
                    cell.imgrow.image = [UIImage imageNamed:@"ic_web.png"];
                    cell.detailrow.text = [self.obj objectForKey:@"website"];
                    
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWebsite:)];
                    [cell addGestureRecognizer:singleTap];
                    
                } else {
                    if ([[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1 && [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_email"] intValue] == 0  && [[self.objUsersetting objectForKey:@"show_website"] intValue] == 0) {
                        cell.imgrow.image = [UIImage imageNamed:@"ic_iphone.png"];
                        cell.detailrow.text = [self.obj objectForKey:@"mobile"];
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                        [cell addGestureRecognizer:singleTap];
                        
                    } else {
                        if ([[self.objUsersetting objectForKey:@"show_gender"] intValue] == 1 && [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_email"] intValue] == 0  && [[self.objUsersetting objectForKey:@"show_website"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 0) {
                            cell.imgrow.image = [UIImage imageNamed:@"ic_gender.png"];
                            cell.detailrow.text = [self.obj objectForKey:@"gender"];
                        } else {
                            if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1 && [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_email"] intValue] == 0  && [[self.objUsersetting objectForKey:@"show_website"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 0 && [[self.objUsersetting objectForKey:@"show_gender"] intValue] == 0) {
                                cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];
                                
                                NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
                                NSString *mySmallerString = [myString substringToIndex:10];
                                cell.detailrow.text = mySmallerString;
                            }
                        }
                    }
                }
            }
        }
    } else if (indexPath.row == 1) {
        if ([[self.objUsersetting objectForKey:@"show_email"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 1) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_mail.png"];
                cell.detailrow.text = [self.obj objectForKey:@"email"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEmail:)];
                [cell addGestureRecognizer:singleTap];
                
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_website"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 1) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_web.png"];
                cell.detailrow.text = [self.obj objectForKey:@"website"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWebsite:)];
                [cell addGestureRecognizer:singleTap];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] == 1) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_iphone.png"];
                cell.detailrow.text = [self.obj objectForKey:@"mobile"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                [cell addGestureRecognizer:singleTap];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_gender"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_gender.png"];
                cell.detailrow.text = [self.obj objectForKey:@"gender"];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_gender"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];

                NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
                NSString *mySmallerString = [myString substringToIndex:10];
                cell.detailrow.text = mySmallerString;
            }
        }
    } else if (indexPath.row == 2) {
        if ([[self.objUsersetting objectForKey:@"show_website"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] == 2) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_web.png"];
                cell.detailrow.text = [self.obj objectForKey:@"website"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWebsite:)];
                [cell addGestureRecognizer:singleTap];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] == 2) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_iphone.png"];
                cell.detailrow.text = [self.obj objectForKey:@"mobile"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                [cell addGestureRecognizer:singleTap];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_gender"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 2) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_gender.png"];
                cell.detailrow.text = [self.obj objectForKey:@"gender"];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_gender"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 2) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];
                
                NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
                NSString *mySmallerString = [myString substringToIndex:10];
                cell.detailrow.text = mySmallerString;
            }
        }
    } else if (indexPath.row == 3) {
        if ([[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] == 3) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_iphone.png"];
                cell.detailrow.text = [self.obj objectForKey:@"mobile"];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
                [cell addGestureRecognizer:singleTap];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_gender"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 3) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_gender.png"];
                cell.detailrow.text = [self.obj objectForKey:@"gender"];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_gender"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 3) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];
                
                NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
                NSString *mySmallerString = [myString substringToIndex:10];
                cell.detailrow.text = mySmallerString;
            }
        }
    } else if (indexPath.row == 4) {
        if ([[self.objUsersetting objectForKey:@"show_gender"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 4) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_gender.png"];
                cell.detailrow.text = [self.obj objectForKey:@"gender"];
            }
        }
        if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1) {
            if ([[self.objUsersetting objectForKey:@"show_email"] intValue] + [[self.objUsersetting objectForKey:@"show_facebook"] intValue] + [[self.objUsersetting objectForKey:@"show_website"] intValue] + [[self.objUsersetting objectForKey:@"show_gender"] intValue] + [[self.objUsersetting objectForKey:@"show_mobile"] intValue] == 4) {
                cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];
                
                NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
                NSString *mySmallerString = [myString substringToIndex:10];
                cell.detailrow.text = mySmallerString;
            }
        }
    } else if (indexPath.row == 5) {
        if ([[self.objUsersetting objectForKey:@"show_birth_date"] intValue] == 1) {
            cell.imgrow.image = [UIImage imageNamed:@"ic_birthday.png"];
            
            NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
            NSString *mySmallerString = [myString substringToIndex:10];
            cell.detailrow.text = mySmallerString;
        }
    }
    
    return cell;
}

- (void)singleTapWebsite:(UITapGestureRecognizer *)gesture
{
    if (![[self.obj objectForKey:@"website"] isEqualToString:@""]) {
        NSString *website = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"website"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (![[self.obj objectForKey:@"mobile"] isEqualToString:@""]) {
        NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",[self.obj objectForKey:@"mobile"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

- (void)singleTapEmail:(UITapGestureRecognizer *)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        NSLog(@"Send Email");
        // Email Subject
        NSString *emailTitle = @"ราตรีสโมสร";
        // Email Content
        NSString *messageBody = @"ราตรีสโมสร";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:[self.obj objectForKey:@"email"]];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)fullimgTapped:(id)sender {
    NSString *picStr = [[NSString alloc] initWithString:[[self.obj objectForKey:@"picture"] objectForKey:@"url"]];
    [self.delegate PFSeeprofileViewController:self viewPicture:picStr];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFSeeprofileViewControllerBack)]){
            [self.delegate PFSeeprofileViewControllerBack];
        }
    }
    
}

@end

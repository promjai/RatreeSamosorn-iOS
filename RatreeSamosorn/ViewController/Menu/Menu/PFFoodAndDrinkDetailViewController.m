//
//  PFFoodAndDrinkDetailViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 9/2/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFFoodAndDrinkDetailViewController.h"

@interface PFFoodAndDrinkDetailViewController ()

@end

@implementation PFFoodAndDrinkDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.DetailOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.DetailOffline removeObjectForKey:@"DetailfoodArray"];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.order.text = @"Order";
    } else {
        self.order.text = @"สั่งซื้อ";
    }
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    CALayer *orderButton = [self.orderButton layer];
    [orderButton setMasksToBounds:YES];
    [orderButton setCornerRadius:7.0f];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *url = [NSString stringWithFormat:@"%@",[[self.obj objectForKey:@"node"] objectForKey:@"pictures"]];
    [self.RatreeSamosornApi getFoodsAndDrinkByURL:url];
    
    self.name.text = [self.obj objectForKey:@"name"];
    self.price.text = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"price"]];
    self.baht.text = @"Baht";
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    //1
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.imageView1.image = [UIImage imageWithData:imgData];
                          }];
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    self.name1.text = [self.obj objectForKey:@"name"];
    self.price1.text = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"price"]];
    self.baht1.text = @"Baht";
    self.detail1.text = [self.obj objectForKey:@"detail"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)share {
    
    NSString *urlString = [[NSString alloc]init];
    urlString = [[NSString alloc]initWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"node"] objectForKey:@"share"]]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addURL:[NSURL URLWithString:urlString]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], touchPoint))
		{
            self.current = [NSString stringWithFormat:@"%d",index];
			[self ShowDetailView:imgView];
			break;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches] anyObject];
	
	for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], [touch locationInView:scrollView]))
		{
			[self ShowDetailView:imgView];
			break;
		}
	}
}

-(void)ShowDetailView:(UIImageView *)imgView
{
	imageView.image = imgView.image;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)PFRatreeSamosornApi:(id)sender getFoodsAndDrinkByURLResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    [self.DetailOffline setObject:response forKey:@"DetailArray"];
    [self.DetailOffline synchronize];
    
    NSString *length = [NSString stringWithFormat:@"%@",[response objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(255, 255, 255);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(255, 255, 255);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
    [self.waitView removeFromSuperview];
    
}

- (void)PFRatreeSamosornApi:(id)sender getFoodsAndDrinkByURLErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    NSString *length = [NSString stringWithFormat:@"%@",[[self.DetailOffline objectForKey:@"DetailArray"] objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(139, 94, 60);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.detail1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(139, 94, 60);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.DetailOffline objectForKey:@"DetailArray"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[[self.DetailOffline objectForKey:@"DetailArray"] objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.DetailOffline objectForKey:@"DetailArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[[self.DetailOffline objectForKey:@"DetailArray"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
    [self.waitView removeFromSuperview];
    
}

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
}

- (IBAction)fullimgalbumTapped:(id)sender {
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];
}

- (IBAction)orderTapped:(id)sender{
    PFOrderViewController *webView = [[PFOrderViewController alloc] init];
    if(IS_WIDESCREEN) {
        webView = [[PFOrderViewController alloc] initWithNibName:@"PFOrderViewController_Wide" bundle:nil];
    } else {
        webView = [[PFOrderViewController alloc] initWithNibName:@"PFOrderViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    webView.delegate = self;
    webView.product_id = [self.obj objectForKey:@"id"];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)PFOrderViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFFoodAndDrinkDetailViewControllerBack)]){
            [self.delegate PFFoodAndDrinkDetailViewControllerBack];
        }
    }
}

@end

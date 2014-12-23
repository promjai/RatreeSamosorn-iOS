//
//  MWGridViewController.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import "MWGridViewController.h"
#import "MWGridCell.h"
#import "MWPhotoBrowserPrivate.h"

@interface MWGridViewController () {
    
    // Store margins for current setup
    CGFloat _margin, _gutter, _marginL, _gutterL, _columns, _columnsL;
    
}

@end

@implementation MWGridViewController

- (id)init {
    if ((self = [super initWithCollectionViewLayout:[PSTCollectionViewFlowLayout new]])) {
        
        // Defaults
        _columns = 3, _columnsL = 4;
        _margin = 0, _gutter = 1;
        _marginL = 0, _gutterL = 1;
        
        // For pixel perfection...
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            _columns = 6, _columnsL = 8;
            _margin = 1, _gutter = 2;
            _marginL = 1, _gutterL = 2;
        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
            // iPhone 3.5 inch
            _columns = 3, _columnsL = 4;
            _margin = 0, _gutter = 1;
            _marginL = 1, _gutterL = 2;
        } else {
            // iPhone 4 inch
            _columns = 3, _columnsL = 5;
            _margin = 0, _gutter = 1;
            _marginL = 0, _gutterL = 2;
        }

        _initialContentOffset = CGPointMake(0, CGFLOAT_MAX);
 
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[MWGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    self.collectionView.alwaysBounceVertical = YES;
    
    if (IS_WIDESCREEN) {
        self.collectionView.frame = CGRectMake(0, 100 , 320, 468);
    }else{
        self.collectionView.frame = CGRectMake(0, 100 , 320, 380);
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *viewz = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 100)];
    viewz.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    viewz.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewz];
    
    //*******
    UITextView *texttitle = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 300, 30)];
    //texttitle.backgroundColor = [UIColor yellowColor];
    //texttitle.text = [[satitApi getGalleryName] objectForKey:@"galleryName"];
    texttitle.TextAlignment = NSTextAlignmentCenter;
    texttitle.textColor = [UIColor blackColor];
    
    NSTextContainer *containertitle = texttitle.textContainer;
    NSLayoutManager *layoutManagertitle = containertitle.layoutManager;
    
    CGRect textRecttitle = [layoutManagertitle usedRectForTextContainer:containertitle];
    
    UIEdgeInsets insettitle = UIEdgeInsetsZero;
    insettitle.top = ((texttitle.bounds.size.height - textRecttitle.size.height) / 2)/2;
    insettitle.left = (300 - texttitle.bounds.size.width) / 2;
    
    texttitle.textContainerInset = insettitle;
    
    texttitle.editable = NO;
    texttitle.scrollEnabled = NO;
    [texttitle setFont:[UIFont systemFontOfSize:18]];
    
    //*********
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    //textView.backgroundColor = [UIColor redColor];
    //textView.text = [[satitApi getGalleryDesc] objectForKey:@"galleryDesc"];
    textView.TextAlignment = NSTextAlignmentCenter;
    textView.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1.0f];
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset.top = 0;
    inset.left = (300 - textView.bounds.size.width) / 2;
    
    textView.textContainerInset = inset;
    
    textView.editable = NO;
    textView.scrollEnabled = NO;
    [textView setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:texttitle];
    [self.view addSubview:textView];

}

- (void)viewWillDisappear:(BOOL)animated {
    // Cancel outstanding loading
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (visibleCells) {
        for (MWGridCell *cell in visibleCells) {
            [cell.photo cancelAnyLoading];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self performLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move to previous content offset
    if (_initialContentOffset.y != CGFLOAT_MAX) {
        self.collectionView.contentOffset = _initialContentOffset;
    }
    CGPoint currentContentOffset = self.collectionView.contentOffset;
    
    // Get scroll position to have the current photo on screen
    NSIndexPath *currentPhotoIndexPath = [NSIndexPath indexPathForItem:_browser.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:currentPhotoIndexPath atScrollPosition:PSTCollectionViewScrollPositionNone animated:NO];
    CGPoint offsetToShowCurrent = self.collectionView.contentOffset;
    
    // Only commit to using the scrolled position if it differs from the initial content offset
    if (!CGPointEqualToPoint(offsetToShowCurrent, currentContentOffset)) {
        // Use offset to show current
        self.collectionView.contentOffset = offsetToShowCurrent;
    } else {
        // Stick with initial
        self.collectionView.contentOffset = currentContentOffset;
    }
    
}

- (void)performLayout {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
    
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(navBar.frame.origin.y + navBar.frame.size.height + [self getGutter], 0, 0, 0);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadData];
    [self performLayout]; // needed for iOS 5 & 6
}

#pragma mark - Layout

- (CGFloat)getColumns {
    if ((UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) {
        return _columns;
    } else {
        return _columnsL;
    }
}

- (CGFloat)getMargin {
    if ((UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) {
        return _margin;
    } else {
        return _marginL;
    }
}

- (CGFloat)getGutter {
    if ((UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) {
        return _gutter;
    } else {
        return _gutterL;
    }
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_browser numberOfPhotos];
}

- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MWGridCell alloc] init];
    }
    id <MWPhoto> photo = [_browser thumbPhotoAtIndex:indexPath.row];
    cell.photo = photo;
    cell.gridController = self;
    cell.selectionMode = _selectionMode;
    cell.isSelected = [_browser photoIsSelectedAtIndex:indexPath.row];
    cell.index = indexPath.row;
    UIImage *img = [_browser imageForPhoto:photo];
    if (img) {
        [cell displayImage];
    } else {
        [photo loadUnderlyingImageAndNotify];
    }
    return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_browser setCurrentPhotoIndex:indexPath.row];
    [_browser hideGrid];
}

- (void)collectionView:(PSTCollectionView *)collectionView didEndDisplayingCell:(PSTCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [((MWGridCell *)cell).photo cancelAnyLoading];
}

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = [self getMargin];
    CGFloat gutter = [self getGutter];
    CGFloat columns = [self getColumns];
    CGFloat value = floorf(((self.view.bounds.size.width - (columns - 1) * gutter - 2 * margin) / columns));
    return CGSizeMake(value, value);
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self getGutter];
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self getGutter];
}

- (UIEdgeInsets)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat margin = [self getMargin];
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

@end

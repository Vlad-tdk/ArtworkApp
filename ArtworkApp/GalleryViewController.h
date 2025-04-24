//
//  GalleryViewController.h
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

// GalleryViewController.h
#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *artworks;
@property (strong, nonatomic) NSOperationQueue *imageLoadQueue;

@end

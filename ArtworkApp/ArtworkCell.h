//
//  ArtworkCell.h
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

#import <UIKit/UIKit.h>
#import "Artwork.h"

@interface ArtworkCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *artistLabel;

- (void)configureWithArtwork:(Artwork *)artwork;

@end

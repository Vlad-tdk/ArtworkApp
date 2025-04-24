//
//  ArtworkCell.m
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

#import "ArtworkCell.h"

@implementation ArtworkCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10.0;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.contentView.layer.shadowRadius = 4.0;
    self.contentView.layer.shadowOpacity = 0.2;
    self.contentView.clipsToBounds = NO;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.artistLabel = [[UILabel alloc] init];
    self.artistLabel.font = [UIFont systemFontOfSize:12.0];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.artistLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.imageView.heightAnchor constraintEqualToConstant:self.contentView.frame.size.height - 60],
        
        // Ограничения заголовка
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:6],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        
        // Ограничения художника
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:2],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.artistLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-8]
    ]];
}

- (void)configureWithArtwork:(Artwork *)artwork {
    self.titleLabel.text = artwork.title;
    self.artistLabel.text = [NSString stringWithFormat:@"%@ (%ld)", artwork.artist, (long)artwork.year];
    
    if (artwork.image) {
        self.imageView.image = artwork.image;
    } else {
        self.imageView.backgroundColor = artwork.placeholderColor;
        self.imageView.image = nil;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.titleLabel.text = @"";
    self.artistLabel.text = @"";
}

@end

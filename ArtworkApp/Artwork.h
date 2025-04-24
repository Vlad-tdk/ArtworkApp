//
//  Artwork.h
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Artwork : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (assign, nonatomic) NSInteger year;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *placeholderColor;

@end

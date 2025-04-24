//
//  ArtworkDetailViewController.m
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

#import "ArtworkDetailViewController.h"
#import <objc/runtime.h>

@interface ArtworkDetailViewController ()

@property (strong, nonatomic) Artwork *artwork;
@property (strong, nonatomic) UIImageView *artworkImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *artistLabel;
@property (strong, nonatomic) UILabel *yearLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation ArtworkDetailViewController

- (instancetype)initWithArtwork:(Artwork *)artwork {
    self = [super init];
    if (self) {
        _artwork = artwork;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.artwork.title;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    [self setupDetailViews];
    
    // Демонстрация работы с runtime - получаем список всех методов и свойств
    [self inspectArtworkClassUsingRuntime];
    
    // Добавляем кнопку для демонстрации runtime инспекции
    UIBarButtonItem *inspectButton = [[UIBarButtonItem alloc] initWithTitle:@"Inspect"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showRuntimeInfo)];
    self.navigationItem.rightBarButtonItem = inspectButton;
}

- (void)setupDetailViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 800)];
    [scrollView addSubview:contentView];
    
    self.artworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    self.artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.artworkImageView.image = self.artwork.image;
    [contentView addSubview:self.artworkImageView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 250, self.view.bounds.size.width, 100);
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    [contentView.layer insertSublayer:gradient atIndex:0];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.view.bounds.size.width - 40, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.text = self.artwork.title;
    [contentView addSubview:self.titleLabel];
    
    self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, self.view.bounds.size.width - 40, 25)];
    self.artistLabel.font = [UIFont systemFontOfSize:18];
    self.artistLabel.textColor = [UIColor darkGrayColor];
    self.artistLabel.text = self.artwork.artist;
    [contentView addSubview:self.artistLabel];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 390, self.view.bounds.size.width - 40, 25)];
    self.yearLabel.font = [UIFont systemFontOfSize:16];
    self.yearLabel.textColor = [UIColor grayColor];
    self.yearLabel.text = [NSString stringWithFormat:@"Year: %ld", (long)self.artwork.year];
    [contentView addSubview:self.yearLabel];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(20, 430, self.view.bounds.size.width - 40, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:separatorLine];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 450, self.view.bounds.size.width - 40, 300)];
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = [self generateFakeDescriptionForArtwork:self.artwork];
    [self.descriptionLabel sizeToFit];
    [contentView addSubview:self.descriptionLabel];
    
    CGRect descriptionFrame = self.descriptionLabel.frame;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(descriptionFrame) + 40);
    contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, scrollView.contentSize.height);
    
    [self addLoadingAnimation];
}

- (NSString *)generateFakeDescriptionForArtwork:(Artwork *)artwork {
    NSArray *descriptions = @[
        @"This masterpiece is considered one of the most influential works in the history of art. The vibrant colors and expressive brushwork create a sense of movement and emotion that captivates viewers to this day.",
        
        @"A stunning example of the artist's signature style, this work exemplifies the principles of balance, harmony, and perspective that defined the era. The careful attention to detail and symbolic elements reward repeated viewings.",
        
        @"Challenging conventional aesthetics, this revolutionary work caused controversy when first exhibited. Today, it's recognized as a pivotal moment in the development of modern art, influencing countless artists across generations.",
        
        @"The artist created this work during a period of personal turmoil, and the emotional intensity is evident in every brushstroke. The dynamic composition draws the viewer into a world where reality and imagination merge.",
        
        @"This iconic piece showcases the artist's mastery of light and shadow. The subtle gradations and precise technique create an almost photographic realism, yet the work transcends mere reproduction to capture something of the subject's inner life."
    ];
    
    NSInteger randomIndex = arc4random_uniform((u_int32_t)descriptions.count);
    NSString *baseDescription = descriptions[randomIndex];
    
    NSString *fullDescription = [NSString stringWithFormat:@"%@\n\nCreated in %ld by %@, this work represents a significant achievement in the artist's career. Art historians note the technical innovation and emotional depth that distinguishes it from contemporaneous works.\n\nThe piece is currently housed in a major museum collection, where it continues to inspire and captivate audiences from around the world.", baseDescription, (long)artwork.year, artwork.artist];
    
    return fullDescription;
}

- (void)addLoadingAnimation {
    UIView *loadingContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    loadingContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    loadingContainer.tag = 100;
    [self.view addSubview:loadingContainer];
    
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        CGFloat size = 15.0;
        CGFloat x = self.view.bounds.size.width / 2 - size / 2;
        CGFloat y = self.view.bounds.size.height / 2 - size / 2;
        CGRect circleRect = CGRectMake(x, y, size, size);
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
        circleLayer.path = circlePath.CGPath;
        circleLayer.fillColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0].CGColor;
        
        [loadingContainer.layer addSublayer:circleLayer];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath *animationPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - 20, y - 20, 40, 40)];
        positionAnimation.path = animationPath.CGPath;
        positionAnimation.duration = 1.5;
        positionAnimation.beginTime = CACurrentMediaTime() + i * 0.3;
        positionAnimation.repeatCount = HUGE_VALF;
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @1.0;
        opacityAnimation.toValue = @0.3;
        opacityAnimation.duration = 1.5;
        opacityAnimation.beginTime = CACurrentMediaTime() + i * 0.3;
        opacityAnimation.repeatCount = HUGE_VALF;
        opacityAnimation.autoreverses = YES;
        
        [circleLayer addAnimation:positionAnimation forKey:@"position"];
        [circleLayer addAnimation:opacityAnimation forKey:@"opacity"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *containerToRemove = [self.view viewWithTag:100];
        
        [UIView animateWithDuration:0.5 animations:^{
            containerToRemove.alpha = 0.0;
        } completion:^(BOOL finished) {
            [containerToRemove removeFromSuperview];
        }];
    });
}

#pragma mark - Runtime инспекция

- (void)inspectArtworkClassUsingRuntime {
    Class artworkClass = [Artwork class];

    NSMutableArray *methodNames = [NSMutableArray array];
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(artworkClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        const char *methodName = sel_getName(selector);
        [methodNames addObject:[NSString stringWithUTF8String:methodName]];
    }
    
    free(methods);
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(artworkClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        const char *attributes = property_getAttributes(property);
        
        NSString *name = [NSString stringWithUTF8String:propertyName];
        NSString *attrs = [NSString stringWithUTF8String:attributes];
        
        [propertyNames addObject:[NSString stringWithFormat:@"%@ (%@)", name, attrs]];
    }
    
    free(properties);
    
    objc_setAssociatedObject(self,
                             "ArtworkMethodNames",
                             methodNames,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self,
                             "ArtworkPropertyNames",
                             propertyNames,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showRuntimeInfo {
    NSArray *methodNames = objc_getAssociatedObject(self, "ArtworkMethodNames");
    NSArray *propertyNames = objc_getAssociatedObject(self, "ArtworkPropertyNames");
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Runtime Inspection"
                                          message:[NSString stringWithFormat:@"Artwork class has %lu methods and %lu properties.",
                                                   (unsigned long)methodNames.count,
                                                   (unsigned long)propertyNames.count]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *showMethodsAction = [UIAlertAction
                                        actionWithTitle:@"Show Methods"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * _Nonnull action) {
        [self showRuntimeDetails:methodNames title:@"Methods"];
    }];
    
    UIAlertAction *showPropertiesAction = [UIAlertAction
                                           actionWithTitle:@"Show Properties"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
        [self showRuntimeDetails:propertyNames title:@"Properties"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    [alertController addAction:showMethodsAction];
    [alertController addAction:showPropertiesAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showRuntimeDetails:(NSArray *)details title:(NSString *)title {
    UIViewController *detailsVC = [[UIViewController alloc] init];
    detailsVC.title = title;
    detailsVC.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:detailsVC.view.bounds];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    
    NSMutableString *detailsText = [NSMutableString string];
    [details enumerateObjectsUsingBlock:^(NSString *detail, NSUInteger idx, BOOL *stop) {
        [detailsText appendFormat:@"%lu. %@\n", (unsigned long)(idx + 1), detail];
    }];
    
    textView.text = detailsText;
    [detailsVC.view addSubview:textView];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:@selector(dismissDetails)];
    detailsVC.navigationItem.rightBarButtonItem = closeButton;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    objc_setAssociatedObject(self,
                             "PresentedDetailsController",
                             navController,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dismissDetails {
    UINavigationController *navController = objc_getAssociatedObject(self, "PresentedDetailsController");
    
    [navController dismissViewControllerAnimated:YES completion:nil];
}

@end

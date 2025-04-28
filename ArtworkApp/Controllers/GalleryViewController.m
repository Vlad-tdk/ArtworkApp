//
//  GalleryViewController.m
//  ArtworkApp
//
//  Created by Vladimir Martemianov on 24. 4. 2025..
//

#import "GalleryViewController.h"
#import "ArtworkCell.h"
#import "ArtworkDetailViewController.h"
#import "Artwork.h"
#import <objc/runtime.h>

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.title = @"Art Gallery";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    // Инициализация операционной очереди для загрузки изображений в фоновом режиме
    self.imageLoadQueue = [[NSOperationQueue alloc] init];
    self.imageLoadQueue.maxConcurrentOperationCount = 3; // Ограничиваем количество параллельных загрузок
    
    // Создаем коллекцию данных
    [self setupArtworksArray];
    
    // Настройка UICollectionView
    [self setupCollectionView];
    
    // Демонстрация работы с runtime - добавляем динамически метод к классу во время выполнения
    [self addDynamicMethodUsingRuntime];
    
    // Добавляем кнопку для демонстрации динамически созданного метода
    UIBarButtonItem *shuffleButton = [[UIBarButtonItem alloc] initWithTitle:
                                      @"Shuffle"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(dynamicShuffleArtworks)];
    self.navigationItem.rightBarButtonItem = shuffleButton;
}

- (void)setupArtworksArray {
    self.artworks = [NSMutableArray array];
    
    // Добавляем примеры художественных произведений
    // В реальном приложении здесь был бы API запрос к серверу
    NSArray *titles = @[@"Starry Night", @"Mona Lisa", @"The Persistence of Memory",
                        @"The Scream", @"Girl with a Pearl Earring", @"The Night Watch",
                        @"Water Lilies", @"The Last Supper", @"Guernica", @"The Birth of Venus"];
    
    NSArray *artists = @[@"Vincent van Gogh", @"Leonardo da Vinci", @"Salvador Dalí",
                         @"Edvard Munch", @"Johannes Vermeer", @"Rembrandt",
                         @"Claude Monet", @"Leonardo da Vinci", @"Pablo Picasso", @"Sandro Botticelli"];
    
    NSArray *colors = @[[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0],
                        [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0],
                        [UIColor colorWithRed:0.8 green:0.8 blue:0.2 alpha:1.0],
                        [UIColor colorWithRed:0.9 green:0.2 blue:0.2 alpha:1.0],
                        [UIColor colorWithRed:0.2 green:0.6 blue:0.6 alpha:1.0],
                        [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0],
                        [UIColor colorWithRed:0.4 green:0.7 blue:0.9 alpha:1.0],
                        [UIColor colorWithRed:0.6 green:0.5 blue:0.3 alpha:1.0],
                        [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],
                        [UIColor colorWithRed:0.8 green:0.7 blue:0.5 alpha:1.0]];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        Artwork *artwork = [[Artwork alloc] init];
        artwork.title = titles[i];
        artwork.artist = artists[i];
        artwork.year = 1800 + (arc4random_uniform(200));
        artwork.placeholderColor = colors[i];
        
        [self.artworks addObject:artwork];
    }
}

- (void)setupCollectionView {
    // Создаем layout для UICollectionView с красивым расположением ячеек
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // Рассчитываем размер ячейки для корректного отображения на разных экранах
    CGFloat padding = 10;
    CGFloat cellWidth = (CGRectGetWidth(self.view.frame) - padding * 3) / 2;
    layout.itemSize = CGSizeMake(cellWidth, cellWidth * 1.4);
    layout.minimumLineSpacing = padding;
    layout.minimumInteritemSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    
    // Создаем и настраиваем UICollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // Регистрируем ячейку
    [self.collectionView registerClass:[ArtworkCell class]
            forCellWithReuseIdentifier:@"ArtworkCell"];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionView DataSource & Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artworks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArtworkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtworkCell"
                                                                  forIndexPath:indexPath];
    NSLog(@"📦 Rendering cell at %@", indexPath);
    Artwork *artwork = self.artworks[indexPath.item];
    [cell configureWithArtwork:artwork];
    
    // Имитируем асинхронную загрузку изображения
    [self loadImageForCell:cell withArtwork:artwork atIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Создаём и показываем экран детальной информации
    Artwork *selectedArtwork = self.artworks[indexPath.item];
    ArtworkDetailViewController *detailVC = [[ArtworkDetailViewController alloc] initWithArtwork:selectedArtwork];
    
    // Получаем ячейку для создания плавной анимации перехода
    ArtworkCell *selectedCell = (ArtworkCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Анимированный переход с использованием снимка (snapshot) выбранной ячейки
    UIView *snapshotView = [selectedCell.imageView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [selectedCell.imageView convertRect:selectedCell.imageView.bounds toView:self.view];
    [self.view addSubview:snapshotView];
    
    // Скрываем оригинальную ячейку на время анимации
    selectedCell.imageView.hidden = YES;
    
    // Анимированный переход
    [UIView animateWithDuration:0.3 animations:^{
        // Анимация снимка к центру экрана детального просмотра
        snapshotView.center = self.view.center;
        snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
        // Затемняем фон
        self.view.alpha = 0.8;
    } completion:^(BOOL finished) {
        // Удаляем снимок и возвращаем видимость ячейке
        [snapshotView removeFromSuperview];
        selectedCell.imageView.hidden = NO;
        self.view.alpha = 1.0;
        
        // Показываем экран детальной информации
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}

#pragma mark - Асинхронная загрузка изображений

- (void)loadImageForCell:(ArtworkCell *)cell withArtwork:(Artwork *)artwork atIndexPath:(NSIndexPath *)indexPath {
    // Если изображение уже загружено, используем его
    if (artwork.image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = artwork.image;
            [self fadeInImageView:cell.imageView];
        });
        return;
    }
    
    // Добавляем операцию загрузки в очередь
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        // Имитируем задержку сети
        [NSThread sleepForTimeInterval:1.0 + (arc4random_uniform(20) / 10.0)];
        
        // Создаем "имитацию" загруженного изображения
        // В реальном приложении здесь был бы сетевой запрос
        UIImage *placeholderImage = [self generateImageWithColor:artwork.placeholderColor
                                                            size:CGSizeMake(400, 560)
                                                           title:artwork.title];
        
        // Сохраняем изображение в модели
        artwork.image = placeholderImage;
        
        // Обновляем UI в главном потоке
        dispatch_async(dispatch_get_main_queue(), ^{
            // Проверяем, что ячейка все еще отображается (scrollView мог прокрутиться)
            if ([self.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                ArtworkCell *visibleCell = (ArtworkCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                visibleCell.imageView.image = placeholderImage;
                [self fadeInImageView:visibleCell.imageView];
            }
        });
    }];
    
    [self.imageLoadQueue addOperation:operation];
}

- (UIImage *)generateImageWithColor:(UIColor *)color size:(CGSize)size title:(NSString *)title {
    // Создаем контекст для рисования
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    // Рисуем фон
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    // Добавляем текст заголовка
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:22],
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    [title drawInRect:CGRectMake(20, size.height/2 - 50, size.width - 40, 100)
       withAttributes:attributes];
    
    // Получаем изображение и завершаем контекст
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)fadeInImageView:(UIImageView *)imageView {
    imageView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.alpha = 1.0;
    }];
}

#pragma mark - Runtime динамические методы

- (void)addDynamicMethodUsingRuntime {
    // Динамически добавляем метод shuffleArtworks к классу GalleryViewController во время выполнения
    class_addMethod([self class],
                    @selector(dynamicShuffleArtworks),
                    (IMP)dynamicShuffleArtworksMethod,
                    "v@:");
}

// Реализация динамически добавляемого метода
void dynamicShuffleArtworksMethod(id self, SEL _cmd) {
    GalleryViewController *viewController = (GalleryViewController *)self;
    
    // Анимация начала перемешивания
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.3;
    [viewController.collectionView.layer addAnimation:transition forKey:@"shuffleAnimation"];
    
    // Перемешиваем массив произведений искусства
    NSUInteger count = viewController.artworks.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t)remainingCount);
        [viewController.artworks exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    // Обновляем коллекцию
    [viewController.collectionView reloadData];
    
    // Добавляем информационное сообщение с использованием созданного динамически свойства
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Runtime Magic"
                                                                   message:@"Artworks shuffled using a method dynamically added with Objective-C runtime!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end

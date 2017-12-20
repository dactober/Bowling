//
//  BWLMapViewController.m
//  Bowling
//
//  Created by admin on 12/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BWLRegistrationController.h"
#import "BWLWinnerOfGame.h"
#import "NotificationConstants.h"


@interface BWLMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<MKAnnotation>> *annotationMapping;
@property (nonatomic) NSInteger buttonTag;
@property (nonatomic, strong) NSArray <BWLWinnerOfGame *> *winners;
@property (nonatomic, strong) BWLFileManagerHelper *fileManegerHelper;
@end

@implementation BWLMapViewController

static const int kLastTwoPins = 3;
static const int kCountOfPin = 2;
static NSString * const kPinImage = @"myPinImage";
static NSString * const kWinnerPinImage = @"winnerPinImage";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotationMapping = [NSMutableDictionary new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.fileManegerHelper = [[BWLFileManagerHelper alloc] init];
        self.winners = self.fileManegerHelper.winners;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addWinnersAnnotations];
        });
    });
    self.mapView.delegate = self;
    [self setLocationManager];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [self createLongPressGestureRecognizer];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEndGameNotification:) name:kEndGameNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"winners"]) {
        self.winners = self.fileManegerHelper.winners;
        [object removeObserver:self forKeyPath:@"winners"];
    }
}

- (void)addWinnersAnnotations {
    for (BWLWinnerOfGame *winner in self.winners) {
        MKPointAnnotation *annotation = [self createAnnotationForWinner:winner];
        [self.mapView addAnnotation:annotation];
    }
}

-(void)setLocationManager {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (UILongPressGestureRecognizer *)createLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    return longPressGestureRecognizer;
}

- (void)didEndGameNotification:(NSNotification *)notification {
    NSDictionary *dictionary = [notification userInfo];
    BWLWinnerOfGame *winner = dictionary[kWinner];
    id<MKAnnotation> annotation = dictionary[kLocation];
    MKPointAnnotation *pointAnnotation = [self createAnnotationForWinner:winner];
    [self.fileManegerHelper addObserver:self forKeyPath:@"winners" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.fileManegerHelper addWinner:winner];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.mapView addAnnotation:pointAnnotation];
        });
    });
    [self.mapView removeAnnotation:annotation];
    [self removeAnnotationFromMapping:annotation];
}

- (void)removeAnnotationFromMapping:(id<MKAnnotation>)annotation {
    NSDictionary *annotationDictionary = [self.annotationMapping copy];
    for (NSNumber* key in annotationDictionary) {
        if ([annotationDictionary[key] isEqual:annotation]) {
            [self.annotationMapping removeObjectForKey:key];
        }
    }
    NSArray *keys = [self.annotationMapping allKeys];
    self.buttonTag = [[keys lastObject] integerValue] + 1;
}

- (MKPointAnnotation *)createAnnotationForWinner:(BWLWinnerOfGame *)winner {
    NSNumber *longitude = winner.longitude;
    NSNumber *latitude = winner.latitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    NSString *score = [NSString stringWithFormat:@"%@",winner.score];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.title = winner.name;
    annotation.subtitle = score;
    annotation.coordinate = coordinate;
    return annotation;
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annotation];
    [self geocodeLocationWithAnnotation:annotation];
}

- (void)geocodeLocationWithAnnotation:(MKPointAnnotation *)annotation {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    [geocoder reverseGeocodeLocation: location completionHandler: ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         annotation.title = placemark.locality;
         annotation.subtitle = placemark.name;
     }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"ReusableID";
    if(annotation != mapView.userLocation) {
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        [self configureAnnotationView:pinView withAnnotation:annotation];
    } else {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:mapView.userLocation reuseIdentifier:defaultPinID];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:kPinImage];
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)configureAnnotationView:(MKAnnotationView *)pinView withAnnotation:(id<MKAnnotation>)annotation {
    pinView.canShowCallout = YES;
    if (![self isWinner:annotation]) {
            pinView.image = [UIImage imageNamed:kPinImage];
            [self configureCallOutForAnnotationView:pinView withAnnotation:annotation];
    } else {
        pinView.image = [UIImage imageNamed:kWinnerPinImage];
    }
    [self removePinFromMap];
}

- (BOOL)isWinner:(id<MKAnnotation>)annotation {
    for (BWLWinnerOfGame *winner in self.winners) {
        CLLocationCoordinate2D coordinateOfWinner = CLLocationCoordinate2DMake([winner.latitude floatValue], [winner.longitude floatValue]);
        CLLocationCoordinate2D coordinateOfAnnotation = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
        if (coordinateOfWinner.latitude == coordinateOfAnnotation.latitude && coordinateOfWinner.longitude == coordinateOfAnnotation.longitude) {
            return YES;
        }
    }
    return NO;
}

- (void)removePinFromMap {
    if (self.annotationMapping.count > kCountOfPin) {
        id<MKAnnotation> annotationForRemove = self.annotationMapping[@(self.buttonTag - kLastTwoPins)];
        [self.mapView removeAnnotation:annotationForRemove];
        [self.annotationMapping removeObjectForKey:@(self.buttonTag - kLastTwoPins)];
    }
}

- (void)configureCallOutForAnnotationView:(MKAnnotationView *)pinView withAnnotation:(id<MKAnnotation>)annotation {
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [advertButton addTarget:self action:@selector(callOutButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = advertButton;
    advertButton.tag = self.buttonTag;
    self.annotationMapping[@(advertButton.tag)] = annotation;
    self.buttonTag++;
}

- (void)callOutButtonPress:(UIButton *)sender {
    id<MKAnnotation> annotation = self.annotationMapping[@(sender.tag)];
    NSString *nameOfPlace = [NSString stringWithFormat:@"%@ %@",annotation.title,annotation.subtitle];
    [self presentRegistrationControllerWithNameOfPlace:nameOfPlace withAnnotation:annotation];
}

- (void)presentRegistrationControllerWithNameOfPlace:(NSString *)nameOfPlace withAnnotation:(id<MKAnnotation>)annotation {
    BWLWinnerOfGame *winner = [[BWLWinnerOfGame alloc]initWithLocation:annotation.coordinate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BWLRegistrationController *registrationController = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
    registrationController.annotation = annotation;
    registrationController.winner = winner;
    [registrationController setTitle:nameOfPlace];
    [self.navigationController pushViewController:registrationController animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

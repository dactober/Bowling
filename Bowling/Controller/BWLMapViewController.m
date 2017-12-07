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
@interface BWLMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<MKAnnotation>> *annotationMapping;
@property (nonatomic) NSInteger buttonTag;
@property (nonatomic, strong) NSMutableArray <NSData *> *winners;
@end

@implementation BWLMapViewController
static const int kLastTwoPins = 3;
static const int kCountOfPin = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.winners = [NSMutableArray new];
    self.annotationMapping = [NSMutableDictionary new];
    self.mapView.delegate = self;
    [self setLocationManager];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [self createLongPressGestureRecognizer];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEndGameNotification:) name:kEndGame object:nil];
    [self loadObjects];
}

-(void)setLocationManager {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)didEndGameNotification:(NSNotification *)notification {
    NSDictionary *dictionary = [notification userInfo];
    BWLWinnerOfGame *winner = dictionary[kWinner];
    id<MKAnnotation> annotation = dictionary[kLocation];
    MKPointAnnotation *pointAnnotation = [self createAnnotationForWinner:winner];
    [self saveObject:winner];
    [self.mapView removeAnnotation:annotation];
    NSDictionary *annotationDictionary = [self.annotationMapping copy];
    for (NSNumber* key in annotationDictionary) {
        if ([annotationDictionary[key] isEqual:annotation]) {
            [self.annotationMapping removeObjectForKey:key];
        }
    }
    NSArray *keys = [self.annotationMapping allKeys];
    self.buttonTag = [[keys lastObject] integerValue] + 1;
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)saveObject:(BWLWinnerOfGame *)winner {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:winner];//another class
    [self.winners addObject:data];
    NSArray *array = [self.winners copy];
    [defaults setObject:array forKey:kWinner];
    [defaults synchronize];
}

- (void)loadObjects {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"winner"];
    NSArray *array = [defaults objectForKey:kWinner];
    self.winners = [array mutableCopy];
    for (NSData *data in array) {
        BWLWinnerOfGame *winner = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        MKPointAnnotation *annotation = [self createAnnotationForWinner:winner];
        [self.mapView addAnnotation:annotation];
    }
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

- (UILongPressGestureRecognizer *)createLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    return longPressGestureRecognizer;
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
    
    [geocoder reverseGeocodeLocation: location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
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
        pinView.image = [UIImage imageNamed:@"myPinImage"];
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)configureAnnotationView:(MKAnnotationView *)pinView withAnnotation:(id<MKAnnotation>)annotation {
    pinView.canShowCallout = YES;
    pinView.image = [UIImage imageNamed:@"myPinImage"];
    BOOL isWinner = NO;
    if (self.winners.count != 0) {
        for (NSData *data in self.winners) {
            if (data != nil) {
                BWLWinnerOfGame *winner = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([winner.longitude floatValue] == annotation.coordinate.longitude && [winner.latitude floatValue] == annotation.coordinate.latitude) {
                    isWinner = YES;
                    break;
                }
            }
        }
        if (!isWinner) {
            [self configureCallOutForAnnotationView:pinView withAnnotation:annotation];
        }
    } else {
        [self configureCallOutForAnnotationView:pinView withAnnotation:annotation];
    }
    [self removePinFromMap];
}

- (void)removePinFromMap {
    if (self.annotationMapping.count > kCountOfPin) {
        id<MKAnnotation> annotationForRemove = self.annotationMapping[@(self.buttonTag - kLastTwoPins)];
        [self.mapView removeAnnotation:annotationForRemove];
        [self.annotationMapping removeObjectForKey:@(self.buttonTag - kLastTwoPins)];
    }
}

- (void)configureCallOutForAnnotationView:(MKAnnotationView *)pinView withAnnotation:(id<MKAnnotation>)annotation{
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

- (void)presentRegistrationControllerWithNameOfPlace:(NSString *)nameOfPlace withAnnotation:(id<MKAnnotation>)annotation{
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

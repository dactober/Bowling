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
@interface BWLMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<MKAnnotation>> *annotationMapping;
@property (nonatomic) NSInteger buttonTag;
@end

@implementation BWLMapViewController
static const int kCountOfPin = 3;
static const int kLastTwoPins = 2;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotationMapping = [NSMutableDictionary new];
    self.mapView.delegate = self;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    UILongPressGestureRecognizer *longPressGestureRecognizer = [self createLongPressGestureRecognizer];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
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
    [self removePinFromMap];
    [self geocodeLocationWithAnnotation:annotation];
}

- (void)removePinFromMap {
    if (self.mapView.annotations.count > kCountOfPin) {
        id<MKAnnotation> annotationForRemove = self.annotationMapping[@(self.buttonTag - kLastTwoPins)];
        [self.mapView removeAnnotation:annotationForRemove];
        [self.annotationMapping removeObjectForKey:@(self.buttonTag - kLastTwoPins)];
    }
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
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [advertButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = advertButton;
    advertButton.tag = self.buttonTag;
    self.annotationMapping[@(advertButton.tag)] = annotation;
    self.buttonTag++;
}

- (void)buttonPress:(UIButton *)sender {
    id<MKAnnotation> annotation = self.annotationMapping[@(sender.tag)];
    NSString *nameOfPlace = [NSString stringWithFormat:@"%@ %@",annotation.title,annotation.subtitle];
    [self presentRegistrationControllerWithNameOfPlace:nameOfPlace];
    
}

- (void)presentRegistrationControllerWithNameOfPlace:(NSString *)nameOfPlace {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BWLRegistrationController *registrationController = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
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

@end

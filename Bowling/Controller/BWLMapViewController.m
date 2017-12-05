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
@property (nonatomic, strong) NSMutableDictionary *annotationMapping;
@property (nonatomic) NSInteger buttonTag;
@end

@implementation BWLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotationMapping = [NSMutableDictionary new];
    self.mapView.delegate = self;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 2.0;
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annotation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation: location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark.country);
         NSLog(@"placemark %@",placemark.locality);
         NSLog(@"location %@",placemark.name);
         annotation.title = placemark.locality;
         annotation.subtitle = placemark.name;
     }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"ReusableID";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) {
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"myPinImage"];
        UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [advertButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = advertButton;
        advertButton.tag = self.buttonTag;
        self.annotationMapping[@(advertButton.tag)] = annotation;
        self.buttonTag++;
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)buttonPress:(UIButton *)sender {
    id<MKAnnotation> annotation = self.annotationMapping[@(sender.tag)];
    NSString *nameOfPlace = [NSString stringWithFormat:@"%@ %@",annotation.title,annotation.subtitle];
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

//
//  NetworkManager.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/3/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

- (void) makeDummyPostRequest: (void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion;
- (void) makeDummyAfPostRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion;

- (void) makeDummyPutRequest: (void (^)(BOOL wasRequestSuccessful)) customCompletion;
- (void) makeDummyAfPutRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion;

- (void) makeDummyAfGetRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion;

@end

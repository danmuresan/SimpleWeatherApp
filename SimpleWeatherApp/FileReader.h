//
//  FileReader.h
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileReader : NSObject

-(NSString *) readFileContentsToString: (NSString *) filePath : (NSString *) fileType;
-(NSData *) readFileContentsToData: (NSString *) filePath : (NSString *) fileType;
-(BOOL) writeContentsToFile: (NSString *) filePath : (NSString *) contentsAsString;

@end

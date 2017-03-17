//
//  FileReader.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 3/9/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileReader.h"

@implementation FileReader : NSObject

-(NSString *) readFileContentsToString: (NSString *) filePath : (NSString *) fileType
{
    NSString* path = [[NSBundle mainBundle] pathForResource:filePath ofType:fileType];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    return content;
}

-(NSData *) readFileContentsToData: (NSString *) filePath : (NSString *) fileType
{
    NSString* path = [[NSBundle mainBundle] pathForResource:filePath ofType:fileType];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    return data;
}

-(BOOL) writeContentsToFile: (NSString *) filePath : (NSString *) contentsAsString;
{
    // TODO: not implemented yet
    return YES;
}

@end

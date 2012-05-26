//
//  PCBonjourClient.h
//  PCBonjourServerTests
//
//  Created by Patrick Perini on 5/24/12.
//  Licensing information available in README.md
//

#import <Foundation/Foundation.h>

@interface PCBonjourClient : NSObject
{
    NSNetServiceBrowser *netServiceBrowser;
    NSNetService *netService;
    NSFileHandle *socketHandle;
}

@property (getter = hasResolved) BOOL resolved;

- (id)initWithServiceNamed: (NSString *)serviceName;

- (NSData *)writeData: (NSData *)data;
- (void)writeData: (NSData *)data withResponseBlock: (void(^)(NSData *data))responseBlock;

@end

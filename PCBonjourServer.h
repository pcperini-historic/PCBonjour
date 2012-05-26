//
//  PCBonjourServer.h
//  PCBonjourServerTests
//
//  Created by Patrick Perini on 5/24/12.
//  Licensing information available in README.md
//

#import <Foundation/Foundation.h>
@class PCBonjourServer;

@protocol PCBonjourServerDelegate <NSObject>

@required
- (NSData *)bonjourServer: (PCBonjourServer *)server responseForData: (NSData *)data;

@end

@interface PCBonjourServer : NSObject
{
    NSNetService *netService;
    NSFileHandle *socketHandle;
    NSMutableSet *remoteHandles;
}

@property id<PCBonjourServerDelegate> delegate;
@property (readonly) NSString *serviceName;

- (id)initWithServiceNamed: (NSString *)serviceName delegate: (id<PCBonjourServerDelegate>)delegate;
- (void)start;
- (void)stop;

@end

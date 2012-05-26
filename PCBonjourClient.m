//
//  PCBonjourClient.m
//  PCBonjourServerTests
//
//  Created by Patrick Perini on 5/24/12.
//  Licensing information available in README.md
//

#import "PCBonjourClient.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface PCBonjourClient () <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@end

@implementation PCBonjourClient

#pragma mark - Accessors and Mutators
@synthesize resolved;

- (NSString *)description
{
    return [NSString stringWithFormat: @"Client: %@", [netService description]];
}

#pragma mark - Lifecycle Managers
- (id)initWithServiceNamed:(NSString *)serviceName
{
    self = [super init];
    if (!self)
        return nil;
    
    // Setup Net Service Browser
    NSString *type = [NSString stringWithFormat: @"_%@._tcp", [serviceName lowercaseString]];
    
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    [netServiceBrowser setDelegate: self];
    
    [netServiceBrowser searchForServicesOfType: type
                                      inDomain: @"local."];
    
    return self;
}

- (void)dealloc
{
    netService = nil;
    netServiceBrowser = nil;
    socketHandle = nil;
}

#pragma mark - Writers
- (NSData *)writeData:(NSData *)data
{
    [socketHandle writeData: data];
    return [socketHandle availableData];
}

- (void)writeData:(NSData *)data withResponseBlock:(void (^)(NSData *))responseBlock
{
    dispatch_queue_t current_queue = dispatch_get_current_queue();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
    {
        [socketHandle writeData: data];
        NSData *responseData = [socketHandle availableData];
        
        dispatch_async(current_queue, ^()
        {
            responseBlock(responseData);
        });
    });
}

#pragma mark - Net Service Browser Delegation
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    if (moreComing)
        return;
    
    netService = aNetService;
    [netService setDelegate: self];
    [netService resolveWithTimeout: 0];
}

#pragma mark - Net Service Delegation
- (void)netServiceDidResolveAddress:(NSNetService *)sender
{    
    for (NSData *address in [[netService addresses] reverseObjectEnumerator])
    {
        // Initialize Socket
        int socketDescriptor = socket(AF_INET, SOCK_STREAM, 0);
        if (socketDescriptor == -1)
        {
            close(socketDescriptor);
            return;
        }
        
        // Initialize Socket Handle
        struct sockaddr_in socketAddress = *(struct sockaddr_in *) [address bytes];
        
        int connected = connect(socketDescriptor, (struct sockaddr *) &socketAddress, sizeof(socketAddress));
        if (connected == -1)
        {
            close(socketDescriptor);
            continue;
        }
        
        socketHandle = [[NSFileHandle alloc] initWithFileDescriptor: socketDescriptor
                                                     closeOnDealloc: YES];
        
        resolved = YES;
        return;
    }
}

@end

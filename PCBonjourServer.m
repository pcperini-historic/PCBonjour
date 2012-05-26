//
//  PCBonjourServer.m
//  PCBonjourServerTests
//
//  Created by Patrick Perini on 5/24/12.
//  Licensing information available in README.md
//

#import "PCBonjourServer.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define randint(min, max) (arc4random() % ((max + 1) - min)) + min

@interface PCBonjourServer ()

- (void)fileHandleDidAcceptConnection: (NSNotification *)notification;
- (void)fileHandleDidCompleteReading: (NSNotification *)notification;

@end

@implementation PCBonjourServer

#pragma mark - Accessors and Mutators
@synthesize delegate;

- (NSString *)serviceName
{
    return [netService name];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"Server: %@", [netService description]];
}

#pragma mark - Licecycle Managers
- (id)initWithServiceNamed:(NSString *)serviceName delegate:(id<PCBonjourServerDelegate>)aDelegate
{
    self = [super init];
    if (!self)
        return nil;
    
    remoteHandles = [NSMutableSet set];
    delegate = aDelegate;
    
    // Initialize Net Service
    NSString *type = [NSString stringWithFormat: @"_%@._tcp", [serviceName lowercaseString]];
    
    do
    {
        netService = [[NSNetService alloc] initWithDomain: @"local."
                                                     type: type
                                                     name: serviceName
                                                     port: randint(10000, 40000)];
    } while ([netService port] == -1);
    
    // Initialize Socket
    int socketDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socketDescriptor == -1)
    {
        close(socketDescriptor);
        return nil;
    }
    
    struct sockaddr_in socketAddress;
    socketAddress.sin_family = AF_INET;
    socketAddress.sin_port = htons([netService port]);
    socketAddress.sin_addr.s_addr = htonl(INADDR_ANY);
    
    int bound = bind(socketDescriptor, (struct sockaddr *) &socketAddress, sizeof(socketAddress));
    if (bound == -1)
    {
        close(socketDescriptor);
        return nil;
    }
    
    int listening = listen(socketDescriptor, INT_MAX);
    if (listening == -1)
    {
        close(socketDescriptor);
        return nil;
    }
        
    socketHandle = [[NSFileHandle alloc] initWithFileDescriptor: socketDescriptor
                                                 closeOnDealloc: YES];
    
    // Add Responders
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(fileHandleDidAcceptConnection:)
                                                 name: NSFileHandleConnectionAcceptedNotification
                                               object: nil];
    
    return self;
}

- (void)dealloc
{
    [self stop];
    
    netService = nil;
    socketHandle = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Controllers
- (void)start
{
    [netService publish];
    [socketHandle acceptConnectionInBackgroundAndNotify];
}

- (void)stop
{
    [netService stop];
}

#pragma mark - Responders
- (void)fileHandleDidAcceptConnection:(NSNotification *)notification
{
    [socketHandle acceptConnectionInBackgroundAndNotify];
    
    // Setup Remote Handle
    NSFileHandle *remoteHandle = [[notification userInfo] objectForKey: NSFileHandleNotificationFileHandleItem];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(fileHandleDidCompleteReading:)
                                                 name: NSFileHandleReadCompletionNotification
                                               object: remoteHandle];
    
    [remoteHandle readInBackgroundAndNotify];
    [remoteHandles addObject: remoteHandle];
}

- (void)fileHandleDidCompleteReading:(NSNotification *)notification
{
    NSFileHandle *remoteHandle = [notification object];
    [remoteHandle readInBackgroundAndNotify];
    
    // Handle Incoming and Response Data
    NSData *incomingData = [[notification userInfo] objectForKey: NSFileHandleNotificationDataItem];
    
    if (delegate)
    {
        NSData *outgoingData = [delegate bonjourServer: self
                                       responseForData: incomingData];
        [remoteHandle writeData: outgoingData];
    }
}

@end

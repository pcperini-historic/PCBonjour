#PCBonjour#

Declared In:      PCBonjour.h


##Overview##

`PCBonjour` allows users to establish Bonjour services and clients to communicate between hosts in a zero-conf environment. 



#PCBonjourServer#

Inherits From:    NSObject

Declared In:      PCBonjourServer.h


##Overview##

The `PCBonjourServer` class allows users to setup a zero-conf service.

The delegate of this class is called during incoming connections and used to supply responses.

##Tasks##

###Creating Services###
    - initWithServiceNamed:delegate:

###Starting and Stopping Services###
    - start
    - stop
    
###Accessing Service Properties###
    delegate (property)
    serviceName (property)


##Properties##

**delegate**

>Delegate object called for incoming data that provides outgoing responses.

    id<PCBonjourServerDelegate> delegate
    
**serviceName**

>Name of this service.

    (readonly) NSString *serviceName

##Instance Methods##

**initWithServiceNamed:delegate:**

>Initializes a `PCBonjourServer` object.

    - (id)initWithServiceNamed:(NSString *)serviceName delegate:(id<PCBonjourServerDelegate>)delegate

>*Parameters:*

>`serviceName`

>>The name of the Bonjour service.

>`delegate`

>>The delegate for this server.

>*Returns:*

>An initialized `PCBonjourServer` object or `nil`.

**start**

>Starts the Bonjour service.

    - (void)start

**stop**

>Stops the Bonjour service.

    - (void)stop


#PCBonjourServerDelegate#

Inherits From:    NSObject

Declared In:      PCBonjourServer.h


##Overview##

The `PCBonjourServerDelegate` protocol allows objects to receive calls during incoming connects and supply responses.

##Tasks##

###Communicating With Clients###
    - bonjourServer:responseForData:

##Instance Methods##

**bonjourServer:responseForData:**

>Returns an appropriate `NSData` response for the incoming `NSData` request.

    - (NSData *)bonjourServer:(PCBonjourServer *)server responseForData:(NSData *)data;

>*Parameters:*

>`server`

>>The server being queried.

>`data`

>>The data for the request.

>*Returns:*

>The data for the response.


#PCBonjourClient#

Inherits From:    NSObject

Declared In:      PCBonjourClient.h


##Overview##

The `PCBonjourClient` class allows users to connect to zero-conf services.

The client can either query and receive response data synchronously and inline, or provide a response block and receive the response data asynchronously.

##Tasks##

###Creating Client###
    - initWithServiceNamed:

###Make Requests###
    - writeData:
    - writeData:withResponseBlock:
    
###Determining Client Connectivity###
    resolved (property)


##Properties##

**resolved**

>Whether or not the client has connected to the Bonjour service successfully.

    (getter = hasResolved) BOOL resolved

##Instance Methods##

**initWithServiceNamed:**

>Initializes a `PCBonjourClient` object.

    - (id)initWithServiceNamed:(NSString *)serviceName

>*Parameters:*

>`serviceName`

>>The name of the Bonjour service.

>*Returns:*

>An initialized `PCBonjourClient` object or `nil`.

**writeData:**

>Writes the given data to the server and returns the resposne data synchronously.

    - (NSData *)writeData:(NSData *)data;
    
>*Parameters:*

>`data`

>>The data to write to the server.

>*Returns:*

>The data returned from the server.

**writeData:withResponseBlock:**

>Asynchronously writes the given data to the server and returns the resposne data via the response block.

    - (void)writeData:(NSData *)data withResponseBlock:(void(^)(NSData *data))responseBlock;
    
>*Parameters:*

>`data`

>>The data to write to the server.

>`responseBlock`

>>A block to call back which takes the data returned from the server as a parameter.


#License#

License Agreement for Source Code provided by Patrick Perini

This software is supplied to you by Patrick Perini in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Patrick Perini grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Patrick Perini as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Patrick Perini may be used to endorse or promote products derived from the software without specific prior written permission from Patrick Perini. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Patrick Perini herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Patrick Perini on an "AS IS" basis. Patrick Perini MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR PCS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL Patrick Perini BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF Patrick Perini HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
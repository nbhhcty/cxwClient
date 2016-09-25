/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "TMultiplexedProtocol.h"

#import "TProtocol.h"
#import "TObjective-C.h"

NSString *const MULTIPLEXED_SERVICE_SEPERATOR = @":";

@implementation TMultiplexedProtocol

- (id) initWithProtocol: (id <TProtocol>) protocol
            serviceName: (NSString *) name
{
    self = [super initWithProtocol:protocol];

    if (self) {
        mServiceName = [name retain_stub];
    }
    return self;
}

- (void) writeMessageBeginWithName: (NSString *) name
                              type: (int) messageType
                        sequenceID: (int) sequenceID
{
    switch (messageType) {
        case TMessageType_CALL:
        case TMessageType_ONEWAY:
            {
                NSMutableString * serviceFunction = [[NSMutableString alloc] initWithString:mServiceName];
                [serviceFunction appendString:MULTIPLEXED_SERVICE_SEPERATOR];
                [serviceFunction appendString:name];
                [super writeMessageBeginWithName:serviceFunction type:messageType sequenceID:sequenceID];
                [serviceFunction release_stub];
            }
            break;
        default:
            [super writeMessageBeginWithName:name type:messageType sequenceID:sequenceID];
            break;
    }
}

- (void) dealloc
{
    [mServiceName release_stub];
    [super dealloc_stub];
}

@end

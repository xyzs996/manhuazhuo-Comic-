

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Additions.h"

// implementation for base64 comes from OmniFoundation. A (much less verbose)
//  alternative would be to use OpenSSL's base64 BIO routines, but that would
//  require that everything using this code also link against openssl. Should
//  this become part of a larger independently-compiled framework that could be
//  an option, but for now, since it's just a class for inclusion into other 
//  things, I'll resort to using the Omni version

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (Base64)

+ (NSData *) base64DataFromString: (NSString *)string {
    
    // Create a memory buffer containing Base64 encoded string data
    
    if (string == nil)
        return nil;
        //[NSException raise:NSInvalidArgumentException format:nil];
    
    if ([string length] == 0)
        
        return [NSData data];
    
    static char *decodingTable = NULL;
    
    if (decodingTable == NULL)
        
    {
        
        decodingTable = malloc(256);
        
        if (decodingTable == NULL)
            
            return nil;
        
        memset(decodingTable, CHAR_MAX, 256);
        
        NSUInteger i;
        
        for (i = 0; i < 64; i++)
            
            decodingTable[(short)encodingTable[i]] = i;
        
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (characters == NULL)     //  Not an ASCII string!
        
        return nil;
    
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    
    if (bytes == NULL)
        
        return nil;
    
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    
    while (YES)
        
    {
        
        char buffer[4];
        
        short bufferLength;
        
        for (bufferLength = 0; bufferLength < 4; i++)
            
        {
            
            if (characters[i] == '\0')
                
                break;
            
            if (isspace(characters[i]) || characters[i] == '=')
                
                continue;
            
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                
            {
                
                free(bytes);
                
                return nil;
                
            }
            
        }
        
        if (bufferLength == 0)
            
            break;
        
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            
        {
            
            free(bytes);
            
            return nil;
            
        }
        
        //  Decode the characters in the buffer to bytes.
        
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        
        if (bufferLength > 2)
            
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        
        if (bufferLength > 3)
            
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        
    }
    
    realloc(bytes, length);
    
    return [NSData dataWithBytesNoCopy:bytes length:length];
    
}


- (NSString *)base64Encoding

{
    
    if ([self length] == 0)
        
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    
    if (characters == NULL)
        
        return nil;
    
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    
    while (i < [self length])
        
    {
        
        char buffer[3] = {0,0,0};
        
        short bufferLength = 0;
        
        while (bufferLength < 3 && i < [self length])
            
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        
        if (bufferLength > 1)
            
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        
        else characters[length++] = '=';
        
        if (bufferLength > 2)
            
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        
        else characters[length++] = '=';
        
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

-(NSString*)md5{
	const char *cStr = [self bytes];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, [self length], digest );
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0], digest[1], 
				   digest[2], digest[3],
				   digest[4], digest[5],
				   digest[6], digest[7],
				   digest[8], digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return s;
	
}


@end

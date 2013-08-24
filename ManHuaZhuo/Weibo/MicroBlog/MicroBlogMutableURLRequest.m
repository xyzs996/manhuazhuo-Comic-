

#import "MicroBlogMutableURLRequest.h"
#import "NSURL+Additions.h"
//#import "ASIDataCompressor.h"

@implementation MicroBlogMutableURLRequest
#pragma mark -
#pragma mark calss methods

+ (NSMutableURLRequest *)requestGet:(NSString *)aUrl queryString:(NSString *)aQueryString {
	NSMutableString *url = [[NSMutableString alloc] initWithString:aUrl];
	if (aQueryString) {
		[url appendFormat:@"?%@", aQueryString];
	}
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:url]] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:20.0f];
	
	[url release];
	return request;
}

+ (NSMutableURLRequest *)phoenixRequestPost:(NSString *)aUrl queryString:(NSString *)aQueryString
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:aUrl]] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *newString = [aQueryString stringByReplacingOccurrencesOfString:@"&" withString:@","];
    NSString *authValue = [NSString stringWithFormat:@"OAuth %@", newString];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
	return request;    
}

+ (NSMutableURLRequest *)requestPost:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:aUrl]] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[aQueryString dataUsingEncoding:NSUTF8StringEncoding]];
	return request;
}

+ (NSMutableURLRequest *)requestPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:aUrl]] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	
	//generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    NSString *boundary = @"0xKhTmLbOuNdArY";//[NSString stringWithFormat:@"Boundary-%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
	
	NSData *boundaryBytes = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
        
	NSString *formDataTemplate = @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n";
	
	NSDictionary *listParams = [NSURL parseURLQueryString:aQueryString];
	for (NSString *key in listParams) {
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
    
	NSString *headerTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n";
	for (NSString *key in files) {
		
		NSString *filePath = [files objectForKey:key];
		NSData *fileData = [NSData dataWithContentsOfFile:filePath];
		NSString *header = [NSString stringWithFormat:headerTemplate, key, [[filePath componentsSeparatedByString:@"/"] lastObject]];
		[bodyData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
		[bodyData appendData:fileData];
        //NSString *newLine = [NSString stringWithFormat:@"\r\n--%@", boundary];
		//[bodyData appendData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
    NSString *endLien = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
    [bodyData appendData:[endLien dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:bodyData];
    
#ifdef DEBUG
    NSString *debugPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pic.txt"];
    [bodyData writeToFile:debugPath atomically:YES];
#endif
    
	return request;
}

+ (NSMutableURLRequest *)requestPostWithImageData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:aUrl]] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	
	//generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    //NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", @"F6498E90-F191-467C-8E0A-054D38F30478"];
    CFRelease(uuidStr);
    CFRelease(uuid);
	
	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
	NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	NSDictionary *listParams = [NSURL parseURLQueryString:aQueryString];
	for (NSString *key in listParams) {
		
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
    
    
	//NSString *headerTemplate = @"Content-Disposition: form-data; name=\"data\"; \r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
    NSString *headerTemplate = @"Content-Disposition: form-data; name=\"data\"; filename=header.jpg \r\nContent-Type:image/jpeg \r\n\r\n";
    
    NSData *fileData = data;
    [bodyData appendData:[headerTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:fileData];
    [bodyData appendData:boundaryBytes];
	
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:bodyData];
    
	return request;
}


+ (NSMutableURLRequest *)requestPostWithData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:aUrl]] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:20.0f];
	
	//generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    //NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", @"F6498E90-F191-467C-8E0A-054D38F30478"];
    CFRelease(uuidStr);
    CFRelease(uuid);
	
	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
	NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	NSDictionary *listParams = [NSURL parseURLQueryString:aQueryString];
	for (NSString *key in listParams) {
		
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
    
    
	NSString *headerTemplate = @"Content-Disposition: form-data; name=\"data\"; \r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
    //NSString *headerTemplate = @"Content-Disposition: form-data; name=\"data\"; filename=\"header.jpg\" \r\nContent-Type:\"image/jpeg\"\r\n\r\n";
    
    NSData *fileData = data;
    [bodyData appendData:[headerTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:fileData];
    [bodyData appendData:boundaryBytes];
	
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:bodyData];
    
    //NSLog(@"bodyData:%@", [[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding] autorelease]);
	return request;
}

@end

#import "TheosPlugin.h"
#import "CodaPlugInsController.h"

@interface TheosPlugin ()

- (id)initWithController:(CodaPlugInsController*)inController;

@end


@implementation TheosPlugin

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)aBundle
{
    return [self initWithController:aController];
}


//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}


- (id)initWithController:(CodaPlugInsController*)inController
{
	if ( (self = [super init]) != nil )
	{
		controller = inController;
    [controller registerActionWithTitle:@"Theos Build"
    underSubmenuWithTitle:nil
    target:self
    selector:@selector(build:)
    representedObject:nil
    keyEquivalent:@"^~@b"
    pluginName:self.name];

	
    [controller registerActionWithTitle:@"New Package"
                  underSubmenuWithTitle:nil
                                 target:self
                               selector:@selector(newpack:)
                      representedObject:nil
                          keyEquivalent:nil
                             pluginName:self.name];

}

    
	return self;
}


- (NSString*)name
{
	return @"Theos";
}

- (void)newpack:(id)sender
{
    NSString *script = @"~/theos/bin/nic.pl";
    NSString *s = [NSString stringWithFormat:@"tell application \"Terminal\"\n"
                   "if window 1 exists then\n"
                   "do script \"%@\" in window 1\n"
                   "else\n"
                   "do script \"%@\"\n"
                   "end if\n"
                   "activate\n"
                   "end tell",script,script];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource: s];
    [as executeAndReturnError:nil];

}
- (void)build:(id)sender
{
	CodaTextView* tv = [controller focusedTextView:self];
	if ( tv )
	{
        [tv save];
        NSString*folder=[[NSString alloc] init];
        folder=[NSString stringWithFormat:@"%@",[tv path]];
  
                int startPosition = (int)[folder rangeOfString:@"Users"].location-1;
                int endPosition   = (int)[folder length];
                
                NSRange range = NSMakeRange(startPosition, endPosition - startPosition);
                
        folder = [folder substringWithRange:range];
        
        folder=[folder stringByReplacingOccurrencesOfString:@" " withString:@"\\\\ "];
        folder=[folder stringByDeletingLastPathComponent];

        NSString *script=[NSString stringWithFormat:@"cd %@; clear; clear; rm -r *.deb; make package install;",folder];
        
        NSString *s = [NSString stringWithFormat:@"tell application \"Terminal\"\n"
                       "if window 1 exists then\n"
                       "do script \"%@\" in window 1\n"
                       "else\n"
                       "do script \"%@\"\n"
                       "end if\n"
                       "activate\n"
                       "end tell",script,script];
        
        NSAppleScript *as = [[NSAppleScript alloc] initWithSource: s];
        [as executeAndReturnError:nil];
        
        
    
	}
}


- (void)uncapitalize:(id)sender
{
	CodaTextView* tv = [controller focusedTextView:self];
	if ( tv )
	{
		NSString* selectedText = [tv selectedText];
		
		if ( selectedText )
		{
			NSRange savedRange = [tv selectedRange];
			[tv insertText:[selectedText lowercaseString]];
			[tv setSelectedRange:savedRange];
		}
	}
}



@end

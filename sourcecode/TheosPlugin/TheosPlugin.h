#import <Cocoa/Cocoa.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;

@interface TheosPlugin : NSObject <CodaPlugIn>
{
	CodaPlugInsController* controller;
}

@end

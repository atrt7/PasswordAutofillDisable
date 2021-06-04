#include "PasswordAutofillDisable.h"

NSString* safe_getBundleIdentifier()
{
	CFBundleRef mainBundle = CFBundleGetMainBundle();

	if(mainBundle != NULL)
	{
		CFStringRef bundleIdentifierCF = CFBundleGetIdentifier(mainBundle);

		return (__bridge NSString*)bundleIdentifierCF;
	}

	return nil;
}

static BOOL shouldEnableForBundleIdentifier(NSString *bundleIdentifier) {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PADlistPath];
	NSArray <NSString *> *value = preferences[@"padappswitches"];
	return [value containsObject:bundleIdentifier];
}

%group AutofillDisable
%hook UIKeyboardPreferencesController
    -(BOOL)isPasswordAutoFillAllowed {
		return NO;
    }
%end
%end

%ctor {

	//NSDictionary* settings;
	NSDictionary *tempPreferences = [NSDictionary dictionaryWithContentsOfFile:PADlistPath];
	if(!((NSNumber *) [tempPreferences objectForKey:@"isEnabled"]).boolValue) return;

    if (![NSProcessInfo processInfo]) return;
    NSString* processName = [NSProcessInfo processInfo].processName;
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString* executablePath = args[0];
        if (executablePath) {
            NSString* processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip && !isSpringboard)) {
					if(shouldEnableForBundleIdentifier(safe_getBundleIdentifier())) {
						shouldLoad = YES;
					}
            }
        }
    }

    if (!shouldLoad) return;
    %init(AutofillDisable);
    }
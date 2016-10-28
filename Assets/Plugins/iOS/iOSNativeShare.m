#import "iOSNativeShare.h"

@implementation iOSNativeShare{
}

#ifdef UNITY_4_0 || UNITY_5_0

#import "iPhone_View.h"

#else

extern UIViewController* UnityGetGLViewController();

#endif

+(id) withTitle:(char*)title withMessage:(char*)message{
	
	return [[iOSNativeShare alloc] initWithTitle:title withMessage:message];
}

-(id) initWithTitle:(char*)title withMessage:(char*)message{
	
	self = [super init];
	
	if( !self ) return self;
	
	ShowAlertMessage([[NSString alloc] initWithUTF8String:title], [[NSString alloc] initWithUTF8String:message]);
	
	return self;
	
}

void ShowAlertMessage (NSString *title, NSString *message){
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
	                      
	                      message:message
	                      
	                      delegate:nil
	                      
	                      cancelButtonTitle:@"OK"
	                      
	                      otherButtonTitles: nil];
	
	[alert show];
	
}

+(id) withText:(char*)text withURL:(char*)url withImage:(char*)image withSubject:(char*)subject{
	
	return [[iOSNativeShare alloc] initWithText:text withURL:url withImage:image withSubject:subject];
}

-(id) initWithText:(char*)text withURL:(char*)url withImage:(char*)image withSubject:(char*)subject{
	
	self = [super init];
	
	if( !self ) return self;
	
	
	
    NSString *mText = text ? [[NSString alloc] initWithUTF8String:text] : nil;
	
    NSString *mUrl = url ? [[NSString alloc] initWithUTF8String:url] : nil;
	
    NSString *mImage = image ? [[NSString alloc] initWithUTF8String:image] : nil;
	
    NSString *mSubject = subject ? [[NSString alloc] initWithUTF8String:subject] : nil;
	
	
	NSMutableArray *items = [NSMutableArray new];
	
	if(mText != NULL && mText.length > 0){
		
		[items addObject:mText];
		
	}
	
	if(mUrl != NULL && mUrl.length > 0){
		
		NSURL *formattedURL = [NSURL URLWithString:mUrl];
		
		[items addObject:formattedURL];
		
	}
	if(mImage != NULL && mImage.length > 0){
		
		if([mImage hasPrefix:@"http"])
		{
			NSURL *urlImage = [NSURL URLWithString:mImage];
			
            NSError *error = nil;
            NSData *dataImage = [NSData dataWithContentsOfURL:urlImage options:0 error:&error];
            
            if (!error) {
                UIImage *imageFromUrl = [UIImage imageWithData:dataImage];
                [items addObject:imageFromUrl];
            } else {
                ShowAlertMessage(@"Error", @"Cannot load image");
            }
		}else{
			NSFileManager *fileMgr = [NSFileManager defaultManager];
			if([fileMgr fileExistsAtPath:mImage]){
				
				NSData *dataImage = [NSData dataWithContentsOfFile:mImage];
				
				UIImage *imageFromUrl = [UIImage imageWithData:dataImage];
				
				[items addObject:imageFromUrl];
			}else{
				ShowAlertMessage(@"Error", @"Cannot find image");
			}
		}
	}
	
	UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:Nil];
	
    if(mSubject != NULL) {
        [activity setValue:mSubject forKey:@"subject"];
    } else {
        [activity setValue:@"" forKey:@"subject"];
    }
	
	UIViewController *rootViewController = UnityGetGLViewController();
	[rootViewController presentViewController:activity animated:YES completion:Nil];
    UIPopoverPresentationController * popContronller=[activity popoverPresentationController];
    popContronller.permittedArrowDirections=0;
    popContronller.sourceView=rootViewController.view;
    
    //change location of popover view if you like
    popContronller.sourceRect=CGRectMake(1024/2,768/2,1,1);
	
	return self;
}

# pragma mark - C API
iOSNativeShare* instance;

void showAlertMessage(struct ConfigStruct *confStruct) {
	instance = [iOSNativeShare withTitle:confStruct->title withMessage:confStruct->message];
}

void showSocialSharing(struct SocialSharingStruct *confStruct) {
	instance = [iOSNativeShare withText:confStruct->text withURL:confStruct->url withImage:confStruct->image withSubject:confStruct->subject];
}

@end
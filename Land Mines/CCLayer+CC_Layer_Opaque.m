
#import "CCLayer+CC_Layer_Opaque.h"

@implementation CCLayer (CCLayer_Opaque)
// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

- (GLubyte)opacity {
	for (CCNode *node in [self children]) {
		if ([node conformsToProtocol:@protocol(CCRGBAProtocol)]) {
			return [(id<CCRGBAProtocol>)node opacity];
		}
	}
	return 255;
}

@end
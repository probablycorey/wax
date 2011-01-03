-- UIViewContentMode
UIViewContentModeScaleToFill = 0
UIViewContentModeScaleAspectFit = 1
UIViewContentModeScaleAspectFill = 2
UIViewContentModeRedraw = 3
UIViewContentModeCenter = 4
UIViewContentModeTop = 5
UIViewContentModeBottom = 6
UIViewContentModeLeft = 7
UIViewContentModeRight = 8
UIViewContentModeTopLeft = 9
UIViewContentModeTopRight = 10
UIViewContentModeBottomLeft = 11
UIViewContentModeBottomRight = 12

-- UIBarButtonItemStyle
UIBarButtonItemStylePlain = 0
UIBarButtonItemStyleBordered = 1
UIBarButtonItemStyleDone = 2

-- UIButtonType
UIButtonTypeCustom = 0
UIButtonTypeRoundedRect = 1
UIButtonTypeDetailDisclosure = 2
UIButtonTypeInfoLight = 3
UIButtonTypeInfoDark = 4
UIButtonTypeContactAdd = 5

UILineBreakModeWordWrap = 0
UILineBreakModeCharacterWrap = 1
UILineBreakModeClip = 2
UILineBreakModeHeadTruncation = 3
UILineBreakModeTailTruncation = 4
UILineBreakModeMiddleTruncation = 5

-- UITableViewCellSelectionStyle
UITableViewCellSelectionStyleNone = 0
UITableViewCellSelectionStyleBlue = 1
UITableViewCellSelectionStyleGray = 2

-- UITableViewCellStyle
UITableViewCellStyleDefault = 0
UITableViewCellStyleValue1 = 1
UITableViewCellStyleValue2 = 2
UITableViewCellStyleSubtitle = 3

-- UITableViewCellAccessoryType
UITableViewCellAccessoryNone = 0
UITableViewCellAccessoryDisclosureIndicator = 1
UITableViewCellAccessoryDetailDisclosureButton = 2
UITableViewCellAccessoryCheckmark = 3

-- UIActivityIndicatorViewStyle
UIActivityIndicatorViewStyleWhiteLarge = 0
UIActivityIndicatorViewStyleWhite = 1
UIActivityIndicatorViewStyleGray = 2

-- UITableViewStyle
UITableViewStylePlain = 0
UITableViewStyleGrouped = 1

-- UIControlStateNormal
UIControlStateNormal = 0
UIControlStateHighlighted = 1
UIControlStateDisabled = 2
UIControlStateSelected = 4
UIControlStateApplication = 0x00FF0000
UIControlStateReserved = 0xFF000000

-- String Encoding
NSASCIIStringEncoding = 1
NSNEXTSTEPStringEncoding = 2
NSJapaneseEUCStringEncoding = 3
NSUTF8StringEncoding = 4
NSISOLatin1StringEncoding = 5
NSSymbolStringEncoding = 6
NSNonLossyASCIIStringEncoding = 7
NSShiftJISStringEncoding = 8
NSISOLatin2StringEncoding = 9
NSUnicodeStringEncoding = 10
NSWindowsCP1251StringEncoding = 11
NSWindowsCP1252StringEncoding = 12
NSWindowsCP1253StringEncoding = 13
NSWindowsCP1254StringEncoding = 14
NSWindowsCP1250StringEncoding = 15
NSISO2022JPStringEncoding = 21
NSMacOSRomanStringEncoding = 30
NSUTF16BigEndianStringEncoding = 0x90000100
NSUTF16LittleEndianStringEncoding = 0x94000100
NSUTF32StringEncoding = 0x8c000100
NSUTF32BigEndianStringEncoding = 0x98000100
NSUTF32LittleEndianStringEncoding = 0x9c000100
NSProprietaryStringEncoding = 65536

-- UITextAlignment
UITextAlignmentLeft = 0
UITextAlignmentCenter = 1
UITextAlignmentRight = 2

-- UILineBreakMode
UILineBreakModeWordWrap = 0
UILineBreakModeCharacterWrap = 1
UILineBreakModeClip = 2
UILineBreakModeHeadTruncation = 3
UILineBreakModeTailTruncation = 4
UILineBreakModeMiddleTruncation = 5

-- UIModalTransitionStyle
UIModalTransitionStyleCoverVertical = 0
UIModalTransitionStyleFlipHorizontal = 1
UIModalTransitionStyleCrossDissolve = 2

-- UIKeyboardType
UIKeyboardTypeDefault = 0
UIKeyboardTypeASCIICapable = 1
UIKeyboardTypeNumbersAndPunctuation = 2
UIKeyboardTypeURL = 3
UIKeyboardTypeNumberPad = 4
UIKeyboardTypePhonePad = 5
UIKeyboardTypeNamePhonePad = 6
UIKeyboardTypeEmailAddress = 7
UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable

-- UIReturnKeyType
UIReturnKeyDefault = 0
UIReturnKeyGo = 1
UIReturnKeyGoogle = 2
UIReturnKeyJoin = 3
UIReturnKeyNext = 4
UIReturnKeyRoute = 5
UIReturnKeySearch = 6
UIReturnKeySend = 7
UIReturnKeyYahoo = 8
UIReturnKeyDone = 9
UIReturnKeyEmergencyCall = 10

-- UIControlEvents
UIControlEventTouchDown           = math.pow(2, 0)
UIControlEventTouchDownRepeat     = math.pow(2, 1)
UIControlEventTouchDragInside     = math.pow(2, 2)
UIControlEventTouchDragOutside    = math.pow(2, 3)
UIControlEventTouchDragEnter      = math.pow(2, 4)
UIControlEventTouchDragExit       = math.pow(2, 5)
UIControlEventTouchUpInside       = math.pow(2, 6)
UIControlEventTouchUpOutside      = math.pow(2, 7)
UIControlEventTouchCancel         = math.pow(2, 8)
UIControlEventValueChanged        = math.pow(2, 12)
UIControlEventEditingDidBegin     = math.pow(2, 16)
UIControlEventEditingChanged      = math.pow(2, 17)
UIControlEventEditingDidEnd       = math.pow(2, 18)
UIControlEventEditingDidEndOnExit = math.pow(2, 19)
UIControlEventAllTouchEvents      = 0x00000FFF
UIControlEventAllEditingEvents    = 0x000F0000
UIControlEventApplicationReserved = 0x0F000000
UIControlEventSystemReserved      = 0xF0000000
UIControlEventAllEvents           = 0xFFFFFFFF

-- UITableViewCellEditingStyle;
UITableViewCellEditingStyleNone = 0
UITableViewCellEditingStyleDelete = 1
UITableViewCellEditingStyleInsert = 2

-- MFMailComposeResult
MFMailComposeResultCancelled = 0
MFMailComposeResultSaved = 1
MFMailComposeResultSent = 2
MFMailComposeResultFailed = 3

-- UIBarButtonSystemItem
UIBarButtonSystemItemDone = 0
UIBarButtonSystemItemCancel = 1
UIBarButtonSystemItemEdit = 2
UIBarButtonSystemItemSave = 3
UIBarButtonSystemItemAdd = 4
UIBarButtonSystemItemFlexibleSpace = 5
UIBarButtonSystemItemFixedSpace = 6
UIBarButtonSystemItemCompose = 7
UIBarButtonSystemItemReply = 8
UIBarButtonSystemItemAction = 9
UIBarButtonSystemItemOrganize = 10
UIBarButtonSystemItemBookmarks = 11
UIBarButtonSystemItemSearch = 12
UIBarButtonSystemItemRefresh = 13
UIBarButtonSystemItemStop = 14
UIBarButtonSystemItemCamera = 15
UIBarButtonSystemItemTrash = 16
UIBarButtonSystemItemPlay = 17
UIBarButtonSystemItemPause = 18
UIBarButtonSystemItemRewind = 19
UIBarButtonSystemItemFastForward = 20
UIBarButtonSystemItemUndo = 21
UIBarButtonSystemItemRedo = 22

-- UITextBorderStyle
UITextBorderStyleNone = 0
UITextBorderStyleLine = 1
UITextBorderStyleBezel = 2
UITextBorderStyleRoundedRect = 3


-- UITableViewScrollPosition
UITableViewScrollPositionNone = 0
UITableViewScrollPositionTop = 1
UITableViewScrollPositionMiddle = 2
UITableViewScrollPositionBottom = 3

-- UIKeyboardAppearance
UIKeyboardAppearanceDefault = 0
UIKeyboardAppearanceAlert = 1

-- UITextFieldViewMode
UITextFieldViewModeNever = 0
UITextFieldViewModeWhileEditing = 1
UITextFieldViewModeUnlessEditing = 2
UITextFieldViewModeAlways = 3

-- UITextAutocorrectionType
UITextAutocorrectionTypeDefault = 0
UITextAutocorrectionTypeNo = 1
UITextAutocorrectionTypeYes = 2

-- UIBarStyle
UIBarStyleDefault          = 0
UIBarStyleBlack            = 1
UIBarStyleBlackOpaque      = 1 -- Deprecated. Use UIBarStyleBlack
UIBarStyleBlackTranslucent = 2 -- Deprecated. Use UIBarStyleBlack and set the translucent property to YES


-- NSURLRequestCachePolicy
NSURLRequestUseProtocolCachePolicy = 0
NSURLRequestReloadIgnoringLocalCacheData = 1
NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4 -- Unimplemented
NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
NSURLRequestReturnCacheDataElseLoad = 2
NSURLRequestReturnCacheDataDontLoad = 3
NSURLRequestReloadRevalidatingCacheData = 5 -- Unimplemented

-- UISegmentedControlStyle
UISegmentedControlStylePlain = 0
UISegmentedControlStyleBordered = 1
UISegmentedControlStyleBar = 2

-- UIRemoteNotificationType
UIRemoteNotificationTypeNone = 0
UIRemoteNotificationTypeBadge = math.pow(2, 0)
UIRemoteNotificationTypeSound = math.pow(2, 1)
UIRemoteNotificationTypeAlert = math.pow(2, 2)

-- NSURLCredentialPersistence;
NSURLCredentialPersistenceNone = 0
NSURLCredentialPersistenceForSession = 1
NSURLCredentialPersistencePermanent = 2

-- UIDeviceOrientation
UIDeviceOrientationUnknown = 0
UIDeviceOrientationPortrait = 1
UIDeviceOrientationPortraitUpsideDown = 2
UIDeviceOrientationLandscapeLeft = 3
UIDeviceOrientationLandscapeRight = 4
UIDeviceOrientationFaceUp = 5
UIDeviceOrientationFaceDown = 6

-- UIInterfaceOrientation
UIInterfaceOrientationPortrait = UIDeviceOrientationPortrait
UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown
UIInterfaceOrientationLandscapeLeft = UIDeviceOrientationLandscapeRight
UIInterfaceOrientationLandscapeRight = UIDeviceOrientationLandscapeLeft

-- UIViewAnimationCurve
UIViewAnimationCurveEaseInOut = 0
UIViewAnimationCurveEaseIn = 1
UIViewAnimationCurveEaseOut = 2
UIViewAnimationCurveLinear = 3

-- UITableViewRowAnimation
UITableViewRowAnimationFade = 0
UITableViewRowAnimationRight = 1 -- slide in from right (or out to right)
UITableViewRowAnimationLeft = 2
UITableViewRowAnimationTop = 3
UITableViewRowAnimationBottom = 4
UITableViewRowAnimationNone = 5 -- available in iPhone 3.0

-- UIViewAnimationTransition
UIViewAnimationTransitionNone = 0
UIViewAnimationTransitionFlipFromLeft = 1
UIViewAnimationTransitionFlipFromRight = 2
UIViewAnimationTransitionCurlUp = 3
UIViewAnimationTransitionCurlDown = 4

-- UIViewAutoresizing
UIViewAutoresizingNone                 = 0
UIViewAutoresizingFlexibleLeftMargin   = math.pow(2, 0)
UIViewAutoresizingFlexibleWidth        = math.pow(2, 1)
UIViewAutoresizingFlexibleRightMargin  = math.pow(2, 2)
UIViewAutoresizingFlexibleTopMargin    = math.pow(2, 3)
UIViewAutoresizingFlexibleHeight       = math.pow(2, 4)
UIViewAutoresizingFlexibleBottomMargin = math.pow(2, 5)

-- UIWebViewNavigationType
UIWebViewNavigationTypeLinkClicked = 0
UIWebViewNavigationTypeFormSubmitted = 1
UIWebViewNavigationTypeBackForward = 2
UIWebViewNavigationTypeReload = 3
UIWebViewNavigationTypeFormResubmitted = 4
UIWebViewNavigationTypeOther = 5

-- NSHTTPCookieAcceptPolicy
NSHTTPCookieAcceptPolicyAlways = 0
NSHTTPCookieAcceptPolicyNever = 1
NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain = 2


-- SKPaymentTransactionState
SKPaymentTransactionStatePurchasing = 0
SKPaymentTransactionStatePurchased = 1
SKPaymentTransactionStateFailed = 2
SKPaymentTransactionStateRestored = 3

-- SKError
SKErrorUnknown = 0
SKErrorClientInvalid = 1
SKErrorPaymentCancelled = 2
SKErrorPaymentInvalid = 3
SKErrorPaymentNotAllowed = 4

-- UIStatusBarStyle
UIStatusBarStyleDefault = 0
UIStatusBarStyleBlackTranslucent = 1
UIStatusBarStyleBlackOpaque = 2

-- UIControlContentHorizontalAlignment
UIControlContentHorizontalAlignmentCenter = 0
UIControlContentHorizontalAlignmentLeft = 1
UIControlContentHorizontalAlignmentRight = 2
UIControlContentHorizontalAlignmentFill = 3
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

-- UITableViewCellStyle
UITableViewCellStyleDefault = 0
UITableViewCellStyleValue1 = 1
UITableViewCellStyleValue2 = 2
UITableViewCellStyleSubtitle = 3

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
UIControlEventTouchDown           = math.pow(1, 0)
UIControlEventTouchDownRepeat     = math.pow(1, 1)
UIControlEventTouchDragInside     = math.pow(1, 2)
UIControlEventTouchDragOutside    = math.pow(1, 3)
UIControlEventTouchDragEnter      = math.pow(1, 4)
UIControlEventTouchDragExit       = math.pow(1, 5)
UIControlEventTouchUpInside       = math.pow(1, 6)
UIControlEventTouchUpOutside      = math.pow(1, 7)
UIControlEventTouchCancel         = math.pow(1, 8)
UIControlEventValueChanged        = math.pow(1, 12)
UIControlEventEditingDidBegin     = math.pow(1, 16)
UIControlEventEditingChanged      = math.pow(1, 17)
UIControlEventEditingDidEnd       = math.pow(1, 18)
UIControlEventEditingDidEndOnExit = math.pow(1, 19)
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

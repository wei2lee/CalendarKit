import UIKit

open class Event: EventDescriptor {
    
    public var iconImage: UIImage = UIImage()
    public var typeText: String = ""
    public var typeIsHidden: Bool = false
    public var mainTitleText: String = ""
    public var mainTitleTextIsHidden: Bool = false
    public var mainAttributedText: NSAttributedString?
    
    public var subTitleText: String = ""
    public var subTitleIsHidden: Bool = true
    public var timeText: String = ""
    public var timeIsHidden: Bool = true
    public var locationText: String = ""
    
    public var locationIsHidden: Bool = false
    public var backgroundColor = UIColor.blue.withAlphaComponent(0.3)
    public var textColor = UIColor.black
    public var otherEventAttrText: NSAttributedString?
    
    public var iconLocation: UIImage = UIImage()
    
    // State
    public var startDate = Date()
    public var endDate = Date()
    public var eventTypeRawValue: Int = -1
    public var calendarEventPurposeRawValue: String = ""
    public var name: String = ""
    public var policy: String = ""
    public var otherEventText: String = ""
    public var otherEventType: EnumOtherEventTypePod = EnumOtherEventTypePod.birthday

    // Custom
    public var font = UIFont.boldSystemFont(ofSize: 12)
    public var fontOtherEventBold = UIFont.boldSystemFont(ofSize: 14)
    public var fontOtherEventNormal = UIFont.systemFont(ofSize: 14)
    public var isAllDay = false
    public var color = UIColor.blue {
        didSet {
            backgroundColor = color.withAlphaComponent(0.3)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
//            textColor = UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
        }
    }
    public var minimumDuration: Int = 60
    
    public var userInfo: Any?
    public init() {}
}

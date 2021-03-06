
import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        if(text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0) {
            let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            let linesRoundedUp = Int(ceil(textSize.height/charSize))
            return linesRoundedUp
        }
         return 0
    }
}

public class AllDayView: UIView {
  
  internal weak var eventViewDelegate: EventViewDelegate?
  
  var style = AllDayStyle()
  
  let allDayLabelWidth: CGFloat = 53.0
  let allDayEventHeight: CGFloat = 50.0
  
  public var events: [EventDescriptor] = [] {
    didSet {
      self.reloadData()
    }
  }
  
  private lazy var textLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: allDayLabelWidth, height: 24.0))
    label.text = "all-day"
    label.autoresizingMask = [.flexibleWidth]
    return label
  }()

  /**
   vertical scroll view that contains the all day events in rows with only 2
   columns at most
   */
  private(set) lazy var scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    addSubview(sv)
    
    sv.isScrollEnabled = true
    sv.alwaysBounceVertical = true
    sv.clipsToBounds = false
    
  //  let svLeftConstraint = sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: allDayLabelWidth)
    
   // svLeftConstraint.priority = UILayoutPriority(rawValue: 999)
  //  svLeftConstraint.isActive = true
    //sv.leadingAnchor.constraint(equalTo: topAnchor, constant: allDayLabelWidth).isActive = true
    sv.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
    sv.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: sv.bottomAnchor, constant: 2).isActive = true
    
    //let maxAllDayViewHeight = allDayEventHeight * 2 + allDayEventHeight * 0.5
    //heightAnchor.constraint(lessThanOrEqualToConstant: maxAllDayViewHeight).isActive = true
    
    return sv
  }()
  
  // MARK: - RETURN VALUES
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    configure()
  }
  
  // MARK: - METHODS
  
  /**
   scrolls the contentOffset of the scroll view containg the event views to the
   bottom
   */
  public func scrollToBottom(animated: Bool = false) {
    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
    scrollView.setContentOffset(bottomOffset, animated: animated)
  }
  
  public func updateStyle(_ newStyle: AllDayStyle) {
    style = newStyle.copy() as! AllDayStyle
    
    backgroundColor = UIColor.hexStringToUIColor(hex: "#FFF5E3")
    textLabel.font = style.allDayFont
    textLabel.textColor = style.allDayColor
  }
  
  private func configure() {
    clipsToBounds = true
    
    //add All-Day UILabel
    addSubview(textLabel)
    updateStyle(self.style)
  }
  
  public func reloadData() {
    defer {
      layoutIfNeeded()
    }
    
    // clear event views from scroll view
    scrollView.subviews.forEach { $0.removeFromSuperview() }
    
    if self.events.count == 0 { return }
    
    // create vertical stack view
    
    let verticalStackView = UIStackView(
        distribution: .fill,
        spacing: 4.0
    )
    for (index, anEventDescriptor) in self.events.enumerated() {
      
      // create event
      let eventView = CustomEventView()
      eventView.updateWithDescriptor(event: anEventDescriptor)
      eventView.delegate = self.eventViewDelegate
      eventView.widthConstraint.constant = UIScreen.main.bounds.width - allDayLabelWidth
      // add eventView to horz. stack view
      verticalStackView.addArrangedSubview(eventView)
    }
    
    // add vert. stack view inside, pin vert. stack view, update content view by the number of horz. stack views
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(verticalStackView)
    
    verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
    verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
    verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
    verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    verticalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
    let verticalStackViewHeightConstraint = verticalStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1)
    verticalStackViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
    verticalStackViewHeightConstraint.isActive = true
  }
  // MARK: - LIFE CYCLE
}


//
//  LinearPageController.swift
//  EUNLINEAR
//
//  Created by EunYeongKim on 2021/08/20.
//

import UIKit

public enum CornerStyle {
	case round
	case square
}

@objcMembers
@IBDesignable
public class LinearPageController: UIView {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		setup()
	}
	
	fileprivate let defaultIndicatorColor: UIColor = .systemBlue
	fileprivate let defaultIndicatorBackgroundColor: UIColor = .systemGray5
	
	fileprivate lazy var indicatorView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		view.backgroundColor = defaultIndicatorColor
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	@IBInspectable public dynamic var indicatorBackgroundColor: UIColor {
		get {
			if let backgroundColor = self.backgroundColor {
				return backgroundColor
			} else {
				return defaultIndicatorBackgroundColor
			}
		}
		set {
			self.backgroundColor = newValue
		}
	}
	
	@IBInspectable public dynamic var indicatorColor: UIColor {
		get {
			if let backgroundColor = indicatorView.backgroundColor {
				return backgroundColor
			} else {
				return defaultIndicatorColor
			}
		}
		set {
			indicatorView.backgroundColor = newValue
		}
	}
	
	@IBInspectable public dynamic var indicatorHeight: CGFloat {
		get {
			return self.frame.size.height
		}
		set {
			self.translatesAutoresizingMaskIntoConstraints = false
			let heightConstraint = self.constraints.first(where: {
				$0.firstAttribute == .height && $0.relation == .equal
			})
			
			if let hConstraint = heightConstraint {
				hConstraint.constant = newValue
			} else {
				self.heightAnchor.constraint(equalToConstant: newValue).isActive = true
			}
		}
	}
	
	@IBInspectable public dynamic var numberOfPages: Int = 10 {
		didSet {
			createIndicatorViewConstraints()
		}
	}
	
	public var currentPage: Int = 0 {
		didSet {
			move(to: currentPage)
		}
	}
	
	public func move(to index: Int) {
		UIView.animate(withDuration: 0.3, animations: {
			let moveAction = CGAffineTransform(translationX: self.indicatorView.bounds.width * CGFloat(index), y: 0.0)
			self.indicatorView.transform = moveAction
		})
	}
	
	public var cornerRadius: CGFloat = 5.0
	
	public var corner: CornerStyle = .square {
		didSet {
			setUpIndicatorCorner()
		}
	}
}

fileprivate extension LinearPageController {
	func setup() {
		self.addSubview(indicatorView)
		setUpIndicatorBackgroundUI()
		createIndicatorViewConstraints()
	}
	
	func setUpIndicatorBackgroundUI() {
		self.backgroundColor = defaultIndicatorBackgroundColor
	}
	
	func setUpIndicatorCorner() {
		switch self.corner {
		case .round:
			self.layer.cornerRadius = cornerRadius
			self.indicatorView.layer.cornerRadius = cornerRadius
		case .square:
			self.layer.cornerRadius = 0.0
			self.indicatorView.layer.cornerRadius = 0.0
		}
		self.layer.masksToBounds = true
	}
	
	func createIndicatorViewConstraints() {
		let indicatorBackgroundViewWidth = self.frame.size.width
		let indicatorViewWidth = indicatorBackgroundViewWidth / CGFloat(numberOfPages)

		indicatorView.frame.size.width = indicatorViewWidth

		NSLayoutConstraint.deactivate(indicatorView.constraints)
		self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			indicatorView.widthAnchor.constraint(equalToConstant: indicatorViewWidth),
			indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			indicatorView.topAnchor.constraint(equalTo: self.topAnchor),
			indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		NSLayoutConstraint.activate(constraints)

		self.layoutIfNeeded()
	}
}


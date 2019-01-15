//
//  SLGridCell.swift
//  SeqAl
//
//  Created by Indrajit on 19/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public class SLGridCell : UICollectionViewCell {

  struct Constants {
    static let LabelTextColor = UIColor(red: 102/255.0, green: 210/255.0, blue: 230/255.0, alpha: 1)
    static let BorderWidth = 1.0
  }

  private var label : UILabel!
  private var viewModel: SLGridCellViewModel!
  private var horizontalArrow : UIImageView!
  private var verticleArrow : UIImageView!
  private var diagonalArrow : UIImageView!

  private func constraintsForLabel(_ label: UILabel) -> [NSLayoutConstraint] {
    return [
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }

  private func labelFont() -> UIFont {
    let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
    return font
  }

  public func setup(withViewModel viewModel: SLGridCellViewModel) {
    self.viewModel = viewModel
    label.text = viewModel.value
    backgroundColor = viewModel.backgroundColor
    if (viewModel.highlight) {
      label.textColor = viewModel.highlightedTextColor
    }
    else {
      label.textColor = viewModel.textColor
    }
//    verticleArrow.alpha = 0
//    horizontalArrow.alpha = 0
//    diagonalArrow.alpha = 0
//    if (viewModel.arrow == .Diagonal) {
//      diagonalArrow.alpha = 1
//    }
//    else if (viewModel.arrow == .Horizontal) {
//      horizontalArrow.alpha = 1
//    }
//    else if (viewModel.arrow == .Vertcle) {
//      verticleArrow.alpha = 1
//    }
  }

//  public override var isHighlighted: Bool {
//    didSet {
//      if (isHighlighted) {
//        backgroundColor = .red
//      }
//      else {
//        backgroundColor = viewModel.backgroundColor
//      }
//    }
//  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    label.textColor = Constants.LabelTextColor
  }

  private func createLabel() -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = labelFont()
    label.textColor = Constants.LabelTextColor
    return label
  }

  public override var reuseIdentifier: String? {
    return SLGridCell.cell_reuseIdentifier()
  }

  public class func cell_reuseIdentifier() -> String {
    return "SLGridCell"
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    // Cell customizations
    backgroundColor = .white

    // Subviews
    label = createLabel()
    contentView.addSubview(label)
    let constraints = constraintsForLabel(label)
    NSLayoutConstraint.activate(constraints)

//    horizontalArrow = UIImageView(frame: CGRect.zero)
//    horizontalArrow.translatesAutoresizingMaskIntoConstraints = false
//    horizontalArrow.image = UIImage(named: "black_arrow_right")
//    horizontalArrow.contentMode = .scaleAspectFit
//    horizontalArrow.alpha = 0
//    contentView.addSubview(horizontalArrow)
//    NSLayoutConstraint.activate(constrainsForHorizontalArrow(horizontalArrow))
//
//
//    diagonalArrow = UIImageView(frame: CGRect.zero)
//    diagonalArrow.translatesAutoresizingMaskIntoConstraints = false
//    diagonalArrow.image = UIImage(named: "black_arrow_down_right")
//    diagonalArrow.contentMode = .scaleAspectFit
//    diagonalArrow.alpha = 0
//    contentView.addSubview(diagonalArrow)
//    NSLayoutConstraint.activate(constrainsForDiagonalArrow(diagonalArrow))
//
//    verticleArrow = UIImageView(frame: CGRect.zero)
//    verticleArrow.translatesAutoresizingMaskIntoConstraints = false
//    verticleArrow.image = UIImage(named: "black_arrow_down")
//    verticleArrow.contentMode = .scaleAspectFit
//    verticleArrow.alpha = 0
//    contentView.addSubview(verticleArrow)
//    NSLayoutConstraint.activate(constrainsForVerticleArrow(verticleArrow))
  }

  private func constrainsForDiagonalArrow(_ arrow: UIView) -> [NSLayoutConstraint]  {
    return [
      arrow.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
      arrow.topAnchor.constraint(equalTo: topAnchor),
      arrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
      arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor)
    ]
  }

  private func constrainsForVerticleArrow(_ arrow: UIView) -> [NSLayoutConstraint]  {
    return [
      arrow.topAnchor.constraint(equalTo: topAnchor),
      arrow.centerXAnchor.constraint(equalTo: centerXAnchor),
      arrow.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
      arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor)
    ]
  }

  private func constrainsForHorizontalArrow(_ arrow: UIView) -> [NSLayoutConstraint]  {
    return [
      arrow.leftAnchor.constraint(equalTo: leftAnchor),
      arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
      arrow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
      arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor)
    ]
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

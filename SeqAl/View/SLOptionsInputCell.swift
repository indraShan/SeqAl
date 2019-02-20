//
//  SLOptionsInputCell.swift
//  SeqAl
//
//  Created by Indrajit on 28/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public enum AlignmentType: Int {
  case GlobaAlignment = 0
  case LocalAlignment = 1
  case DoveTail = 2
  case PatternSearch = 3
}


public protocol SLOptionsInputCellDelegate: AnyObject {
  func didSelectAlignment(_ type: AlignmentType)
}

public class SLOptionsInputCell: UICollectionViewCell {

  private var button1: UIButton!
  private var button2: UIButton!
  private var button3: UIButton!
  private var button4: UIButton!

  public weak var deleate: SLOptionsInputCellDelegate?
  
  public override var reuseIdentifier: String? {
    return SLOptionsInputCell.cell_reuseIdentifier()
  }

  public class func cell_reuseIdentifier() -> String {
    return "SLOptionsInputCell"
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    button2 = UIButton(frame: CGRect.zero)
    button2.translatesAutoresizingMaskIntoConstraints = false
    button2.setTitleColor(.black, for: .normal)
    button2.setTitle("Local", for: .normal)
    contentView.addSubview(button2)
    button2.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
    NSLayoutConstraint.activate(constraintsForButton2(button2))

    button1 = UIButton(frame: CGRect.zero)
    button1.translatesAutoresizingMaskIntoConstraints = false
    button1.setTitleColor(.black, for: .normal)
    button1.setTitle("Global", for: .normal)
    contentView.addSubview(button1)
    button1.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
    NSLayoutConstraint.activate(constraintsForButton1(button1, alignedWith: button2))

    button3 = UIButton(frame: CGRect.zero)
    button3.translatesAutoresizingMaskIntoConstraints = false
    button3.setTitleColor(.black, for: .normal)
    button3.setTitle("Dovetail", for: .normal)
    button3.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
    contentView.addSubview(button3)
    NSLayoutConstraint.activate(constraintsForButton3(button3, alignedWith: button2))

    button4 = UIButton(frame: CGRect.zero)
    button4.translatesAutoresizingMaskIntoConstraints = false
    button4.setTitleColor(.black, for: .normal)
    button4.setTitle("Pattern Search", for: .normal)
    button4.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
    contentView.addSubview(button4)
    NSLayoutConstraint.activate(constraintsForButton4(button4, alignedWith: button3))
  }

  @objc func didTapButton(button: UIButton) {
    deleate?.didSelectAlignment(AlignmentType(rawValue: button.tag) ?? .GlobaAlignment)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public func setup() {
    button1.tag = AlignmentType.GlobaAlignment.rawValue
    button2.tag = AlignmentType.LocalAlignment.rawValue
    button3.tag = AlignmentType.DoveTail.rawValue
    button4.tag = AlignmentType.PatternSearch.rawValue
  }

  private func constraintsForButton4(_ button4: UIView, alignedWith button: UIButton) -> [NSLayoutConstraint] {
    return [
      button4.centerXAnchor.constraint(equalTo: centerXAnchor),
      button4.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10)
    ]
  }

  private func constraintsForButton3(_ button3: UIView, alignedWith button: UIButton) -> [NSLayoutConstraint] {
    return [
      button3.centerXAnchor.constraint(equalTo: centerXAnchor),
      button3.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10)
    ]
  }

  private func constraintsForButton1(_ button1: UIView, alignedWith button: UIButton) -> [NSLayoutConstraint] {
    return [
      button1.centerXAnchor.constraint(equalTo: centerXAnchor),
      button1.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10)
    ]
  }

  private func constraintsForButton2(_ button: UIView) -> [NSLayoutConstraint] {
    return [
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }

}

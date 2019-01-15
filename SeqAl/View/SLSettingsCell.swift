//
//  SLSettingsCell.swift
//  SeqAl
//
//  Created by Indrajit on 29/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit


public class SLSettingsCell: UICollectionViewCell {

  public weak var delegate: SLGridViewDelgate?
  private var button1: UIButton!
  private var button2: UIButton!

  public override init(frame: CGRect) {
    super.init(frame: frame)

    button1 = UIButton(frame: CGRect.zero)
    button1.contentMode = .scaleAspectFit
    button1.translatesAutoresizingMaskIntoConstraints = false
    button1.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    contentView.addSubview(button1)
    NSLayoutConstraint.activate(constraintsForButton1(button1))

    button2 = UIButton(frame: CGRect.zero)
    button2.contentMode = .scaleAspectFit
    button2.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(button2)
    button2.addTarget(self, action: #selector(didTapRemoteButton), for: .touchUpInside)
    NSLayoutConstraint.activate(constraintsForButton2(button2, alignedWith: button1))
  }

  @objc func didTapEditButton() {
    delegate?.didTapOnEditButton()
  }

  @objc func didTapRemoteButton() {
    delegate?.didTapOnRemoteButton()
  }


  private func constraintsForButton2(_ button: UIButton, alignedWith button1: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: button1.widthAnchor),
      button.heightAnchor.constraint(equalTo: button1.heightAnchor),
      button.leftAnchor.constraint(equalTo: button1.rightAnchor, constant: 2),
      button.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 2)
    ]
  }

  private func constraintsForButton1(_ button: UIButton) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalToConstant: 30),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -10),
      button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10)
    ]
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override var reuseIdentifier: String? {
    return SLTextInputCell.cell_reuseIdentifier()
  }

  public class func cell_reuseIdentifier() -> String {
    return "SLSettingsCell"
  }

  public func setup(viewModel: SLSettingsCellViewModel) {
    backgroundColor = viewModel.backgroundColor
    button1.setImage(viewModel.image1, for: .normal)
    button2.setImage(viewModel.image2, for: .normal)
  }

}

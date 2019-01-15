//
//  SLTextInputCell.swift
//  SeqAl
//
//  Created by Indrajit on 28/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public protocol SLTextInputCellDelegate: AnyObject {
  func didTapReturnButton(_ cell: SLTextInputCell)
}

public class SLTextInputCell : UICollectionViewCell {

  private let textField: UITextField
  private let headerLabel: UILabel

  private var viewModel: SLTextInputCellViewModel?
  public weak var deleate: SLTextInputCellDelegate?

  public override var reuseIdentifier: String? {
    return SLTextInputCell.cell_reuseIdentifier()
  }

  public class func cell_reuseIdentifier() -> String {
    return "SLInputCell"
  }

  public override init(frame: CGRect) {
    textField = UITextField(frame: CGRect.zero)
    headerLabel = UILabel(frame: CGRect.zero)

    super.init(frame: frame)
    backgroundColor = .clear
    textField.text = "Whats up?"
    textField.delegate = self;
    textField.backgroundColor = UIColor(red: 134.0/255, green: 144.0/255, blue: 252.0/255, alpha: 1)
    textField.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(textField)
    NSLayoutConstraint.activate(constraintsForTextField(textField))
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    textField.leftView = paddingView
    textField.leftViewMode = .always


    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    headerLabel.text = "Test label"
    headerLabel.font = UIFont.boldSystemFont(ofSize: 42)
    headerLabel.textColor = .red
    contentView.addSubview(headerLabel)
    NSLayoutConstraint.activate(constraintsForHeaderLabel(headerLabel, alignedTo: textField))
  }

  private func constraintsForHeaderLabel(_ label: UILabel, alignedTo textField: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20)
    ]
  }

  private func constraintsForTextField(_ textField: UITextField) -> [NSLayoutConstraint] {
    return [
      textField.widthAnchor.constraint(equalTo: widthAnchor, constant: -120),
      textField.heightAnchor.constraint(equalToConstant: 40),
      textField.centerXAnchor.constraint(equalTo: centerXAnchor),
      textField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
    ]
  }

  public func setup(withViewModel viewModel: SLTextInputCellViewModel) {
    self.viewModel = viewModel
    headerLabel.text = viewModel.headerText
    textField.text = viewModel.inputValue
    textField.returnKeyType = viewModel.returnKeyType
  }

  public required init?(coder aDecoder: NSCoder) {
    textField = UITextField(frame: CGRect.zero)
    headerLabel = UILabel(frame: CGRect.zero)
    super.init(coder: aDecoder)
  }
}

extension SLTextInputCell : UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    viewModel?.inputValue = textField.text ?? ""
    textField.resignFirstResponder()
    deleate?.didTapReturnButton(self)
    return false
  }
}

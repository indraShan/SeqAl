//
//  SLInputView.swift
//  SeqAl
//
//  Created by Indrajit on 27/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public protocol SLInputViewDelegate: AnyObject {
  func didFinishInputFlowWith(x: String, y: String, type: AlignmentType)
}

class SLInputView: UIView {

  public var viewModel: SLInputViewModel!
  private var collectionView: UICollectionView!
  public weak var delegate: SLInputViewDelegate?

  public class func createInputView(withModel inputViewModel: SLInputViewModel, delegate: SLInputViewDelegate) -> UIView {
    let inputView = SLInputView()
    inputView.translatesAutoresizingMaskIntoConstraints = false
    inputView.backgroundColor = .clear
    inputView.delegate = delegate
    inputView.viewModel = inputViewModel
//    return inputView

    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false

//    let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//    let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
//    vibrancyView.translatesAutoresizingMaskIntoConstraints = false
//    vibrancyView.contentView.addSubview(inputView)

//    NSLayoutConstraint.activate(
//      [
//        inputView.leftAnchor.constraint(equalTo: vibrancyView.leftAnchor),
//        inputView.rightAnchor.constraint(equalTo: vibrancyView.rightAnchor),
//        inputView.topAnchor.constraint(equalTo: vibrancyView.topAnchor),
//        inputView.bottomAnchor.constraint(equalTo: vibrancyView.bottomAnchor)
//      ]
//    )

    blurView.contentView.addSubview(inputView)
    NSLayoutConstraint.activate(
      [
        inputView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
        inputView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
        inputView.topAnchor.constraint(equalTo: blurView.topAnchor),
        inputView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
      ]
    )

    return blurView
  }

  private func constraintsForCollectioView(_ collectionView: UIView) -> [NSLayoutConstraint] {
    return [
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor)
    ]
  }
  public override init(frame: CGRect) {
    super.init(frame: frame)

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    collectionView.isScrollEnabled = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = backgroundColor
    addSubview(collectionView)
    NSLayoutConstraint.activate(constraintsForCollectioView(collectionView))

    collectionView.register(SLTextInputCell.self, forCellWithReuseIdentifier: SLTextInputCell.cell_reuseIdentifier())
    collectionView.register(SLOptionsInputCell.self, forCellWithReuseIdentifier: SLOptionsInputCell.cell_reuseIdentifier())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SLInputView : UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(width: frame.size.width, height: frame.size.height)
  }
}

extension SLInputView: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (indexPath.row < 2) {
      let cellModel = viewModel.inputViewModels[indexPath.row] as! SLTextInputCellViewModel
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SLTextInputCell.cell_reuseIdentifier(), for: indexPath) as! SLTextInputCell
      cell.deleate = self;
      cell.setup(withViewModel: cellModel)
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SLOptionsInputCell.cell_reuseIdentifier(), for: indexPath) as! SLOptionsInputCell
    cell.deleate = self;
    cell.setup()
    return cell
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
}

extension SLInputView : SLTextInputCellDelegate {
  func didTapReturnButton(_ cell: SLTextInputCell) {
    let indexPath = collectionView.indexPath(for: cell)
    if (indexPath?.row == 3) {

    }
    else {
      collectionView.scrollToItem(at: IndexPath(row: (indexPath?.row ?? 0) + 1, section: 0), at:.centeredHorizontally, animated: true)
    }
  }
}

extension SLInputView : SLOptionsInputCellDelegate {
  func didSelectAlignment(_ type: AlignmentType) {
    let xModel = viewModel.inputViewModels[0] as! SLTextInputCellViewModel
    let yModel = viewModel.inputViewModels[1] as! SLTextInputCellViewModel
    delegate?.didFinishInputFlowWith(x: xModel.inputValue, y: yModel.inputValue, type: type)
  }
}


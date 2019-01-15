//
//  SLQuizDetailView.swift
//  SeqAl
//
//  Created by Indrajit on 29/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public class SLQuizDetailView : UIView {

  public weak var delegate: SLGridViewDelgate?
  private var verticleCell: SLGridCell!
  private var infocusCellViewModel: SLGridCellViewModel!
  private var infocusCell: SLGridCell!
  private var diagonalCell: SLGridCell!
  private var resultLabel: UILabel!
  private var horizontalCell: SLGridCell!
  private var answerValue: String!
  private var quizMode: Bool  = false
  private var hintLabel: UILabel!
  private var resultDirectionLabel: UILabel!


  public class func detailViewFor(infocusGridModel: SLGridCellViewModel,
                                  affectingModels: [SLGridCellViewModel],
                                  size: CGFloat,
                                  delegate: SLGridViewDelgate?,
                                  match: Int,
                                  mismatch: Int,
                                  indel: Int) -> UIView {
    let detailView =  SLQuizDetailView(infocusGridModel, affectingModels, size, match, mismatch, indel)
    detailView.translatesAutoresizingMaskIntoConstraints = false
    detailView.backgroundColor = .clear
    detailView.delegate = delegate;
    return blurrEffect(detailView)
  }


  public class func detailViewFor(infocusGridModel: SLGridCellViewModel,
                                  affectingModels: [SLGridCellViewModel],
                                  size: CGFloat,
                                  delegate: SLGridViewDelgate?,
                                  quizMode: Bool,
                                  match: Int,
                                  mismatch: Int,
                                  indel: Int,
                                  possibleAnswers: [Int]) -> UIView {

    let detailView =  SLQuizDetailView(infocusGridModel, affectingModels, size, quizMode, match, mismatch, indel, possibleAnswers)
    detailView.translatesAutoresizingMaskIntoConstraints = false
    detailView.backgroundColor = .clear
    detailView.delegate = delegate;
    return blurrEffect(detailView)
  }

  public convenience init(_ infocusGridModel: SLGridCellViewModel,
              _ affectingModels: [SLGridCellViewModel],
              _ size: CGFloat,
              _ quizMode: Bool,
              _ match: Int,
              _ mismatch: Int,
              _ indel: Int,
              _ possibleAnswers: [Int]) {

    self.init(infocusGridModel, affectingModels, size, match, mismatch, indel)
    self.quizMode = quizMode
    // Add views for match, mismatch and indel

    resultLabel = UILabel(frame: CGRect.zero)
    resultLabel.translatesAutoresizingMaskIntoConstraints = false
    resultLabel.textColor = .white
    resultLabel.font = UIFont.boldSystemFont(ofSize: 25)
    resultLabel.text = "Test"
    resultLabel.alpha = 0
    addSubview(resultLabel)
    NSLayoutConstraint.activate(constraintsForResultLabel(label: resultLabel, alignedWith: diagonalCell))
    
    let chooseLabel = UILabel(frame: CGRect.zero)
    chooseLabel.translatesAutoresizingMaskIntoConstraints = false
    chooseLabel.textColor = .white
    chooseLabel.font = UIFont.boldSystemFont(ofSize: 15)
    chooseLabel.text = "Choose answer: "
    addSubview(chooseLabel)
    NSLayoutConstraint.activate(constraintsForChooseLabel(label: chooseLabel, alignedWith: horizontalCell))

    var lastView: UIView = chooseLabel
    for ans in possibleAnswers {
      let button = UIButton(frame: CGRect.zero)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitleColor(.white, for: .normal)
      button.setTitle(String(ans), for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
      button.backgroundColor = UIColor(red: 160.0/255, green: 168.0/255, blue: 251.0/255, alpha: 0.7)
      button.tag = ans
      addSubview(button)
      button.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
      NSLayoutConstraint.activate(constraintsForButton(button, alignedWith: lastView, widthFrom: infocusCell))
      lastView = button
    }
    answerValue = infocusGridModel.value
    infocusGridModel.value = "?"
    infocusCell.setup(withViewModel: infocusGridModel)


    hintLabel = UILabel(frame: CGRect.zero)
    hintLabel.translatesAutoresizingMaskIntoConstraints = false
    hintLabel.textColor = .white
    hintLabel.font = UIFont.boldSystemFont(ofSize: 15)
    hintLabel.alpha = 0
    addSubview(hintLabel)
    NSLayoutConstraint.activate(constraintsForHintLabel(hintLabel, alignedWith: resultLabel))

    // Hide that for now
    resultDirectionLabel.alpha = 0
  }


  private func constraintsForHintLabel(_ label: UIView, alignedWith otherView: UIView) -> [NSLayoutConstraint] {
    return [
      label.rightAnchor.constraint(equalTo: otherView.rightAnchor),
      label.topAnchor.constraint(equalTo: otherView.bottomAnchor, constant: 40)
    ]
  }

  private func constraintsForButton(_ button: UIView, alignedWith lastView: UIView, widthFrom cell: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.8),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.centerYAnchor.constraint(equalTo: lastView.centerYAnchor),
      button.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: 20)
    ]
  }

  @objc func didTapButton(button:UIButton) {
    resultLabel.alpha = 0
    if (String(button.tag) == answerValue) {
      hintLabel.text = ""
      UIView.animate(withDuration: 0.3) {
        self.resultLabel.alpha = 1
//        self.hintLabel.alpha = 0
        self.resultLabel.textColor = .green
        self.resultLabel.text = "Correct";
        self.infocusCellViewModel.value = self.answerValue
        self.resultDirectionLabel.alpha = 1
        self.infocusCell.setup(withViewModel: self.infocusCellViewModel)
      }
    }
    else {
//      if (infocusCellViewModel.sequenceXValue == infocusCellViewModel.sequenceYValue) {
////        hintLabel.text = "Hint: max(dia)"
//      }
//      else {
//
//      }

      UIView.animate(withDuration: 0.3) {
        self.resultLabel.alpha = 1
        self.resultDirectionLabel.alpha = 0
//        self.hintLabel.alpha = 1
        self.resultLabel.textColor = .red
        self.resultLabel.text = "Incorrect";
        self.infocusCellViewModel.value = "?"
        self.infocusCell.setup(withViewModel: self.infocusCellViewModel)
      }

    }
  }

  private func constraintsForChooseLabel(label: UILabel, alignedWith view: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -170),
      label.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 60)
    ]
  }


  private func constraintsForResultLabel(label: UILabel, alignedWith view: UIView) -> [NSLayoutConstraint] {
    return [
      label.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -65),
      label.topAnchor.constraint(equalTo: view.topAnchor)
    ]
  }

  private func constraintsForIndelLabel(label: UILabel, alignedWith view: UIView) -> [NSLayoutConstraint] {
    return [
      label.leftAnchor.constraint(equalTo: view.leftAnchor),
      label.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
    ]
  }

  private func constraintsForMismatchLabel(label: UILabel, alignedWith view: UIView) -> [NSLayoutConstraint] {
    return [
      label.leftAnchor.constraint(equalTo: view.leftAnchor),
      label.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
    ]
  }

  private func constraintsForMatchLabel(label: UILabel, alignedWith view: UIView) -> [NSLayoutConstraint] {
    return [
      label.leftAnchor.constraint(equalTo: view.rightAnchor, constant: 65),
      label.topAnchor.constraint(equalTo: view.topAnchor)
    ]
  }

  public init(_ infocusGridModel: SLGridCellViewModel,
              _ affectingModels: [SLGridCellViewModel],
              _ size: CGFloat,
              _ match: Int,
              _ mismatch: Int,
              _ indel: Int) {
    self.infocusCellViewModel = infocusGridModel

    super.init(frame: CGRect.zero)
    quizMode = false
    
    // affectingModels[0] - horizontal
    // affectingModels[1] - verticle
    // affectingModels[2] - diagonal

    let closeButton = UIButton(frame: CGRect.zero)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.setImage(UIImage(named: "close"), for: .normal)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    addSubview(closeButton)
    NSLayoutConstraint.activate(constraintsForCloseButton(closeButton))

    infocusCell = SLGridCell(frame: CGRect.zero)
    infocusCell.translatesAutoresizingMaskIntoConstraints = false
    infocusCell.setup(withViewModel: infocusGridModel)
    addSubview(infocusCell)
    NSLayoutConstraint.activate(constraintsForInfocusCell(infocusCell, size))


    horizontalCell = SLGridCell(frame: CGRect.zero)
    horizontalCell.translatesAutoresizingMaskIntoConstraints = false
    horizontalCell.setup(withViewModel: affectingModels[0])
    addSubview(horizontalCell)
    NSLayoutConstraint.activate(constraintsForHorizontalCell(horizontalCell, alingedWith:infocusCell))

    if let xValue = infocusGridModel.sequenceXValue {
      let horizontalLetter = UILabel(frame: CGRect.zero)
      horizontalLetter.text = xValue
      horizontalLetter.font =  UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
      horizontalLetter.textColor = .white
      horizontalLetter.translatesAutoresizingMaskIntoConstraints = false
      addSubview(horizontalLetter)
      NSLayoutConstraint.activate(constraintsForHorizontalLetter(horizontalLetter, alignedWith: horizontalCell))
    }


    let rightArrow = UIImageView(frame: CGRect.zero)
    rightArrow.contentMode = .scaleAspectFit
    rightArrow.image = UIImage(named: "right_arrow")
    rightArrow.translatesAutoresizingMaskIntoConstraints = false
    addSubview(rightArrow)
    NSLayoutConstraint.activate(constraintsForRightArrow(rightArrow, alignedWith: horizontalCell, infocusCell))

    verticleCell = SLGridCell(frame: CGRect.zero)
    verticleCell.translatesAutoresizingMaskIntoConstraints = false
    verticleCell.setup(withViewModel: affectingModels[1])
    addSubview(verticleCell)
    NSLayoutConstraint.activate(constraintsForVerticleCell(verticleCell, alingedWith:infocusCell))

    if let yValue = infocusGridModel.sequenceYValue {
      let verticleLetter = UILabel(frame: CGRect.zero)
      verticleLetter.text = yValue
      verticleLetter.font =  UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
      verticleLetter.textColor = .white
      verticleLetter.translatesAutoresizingMaskIntoConstraints = false
      addSubview(verticleLetter)
      NSLayoutConstraint.activate(constraintsForVerticleLetter(verticleLetter, alignedWith: verticleCell))
    }

    let downArrow = UIImageView(frame: CGRect.zero)
    downArrow.contentMode = .scaleAspectFit
    downArrow.image = UIImage(named: "down_arrow")
    downArrow.translatesAutoresizingMaskIntoConstraints = false
    addSubview(downArrow)
    NSLayoutConstraint.activate(constraintsForDownArrow(downArrow, alignedWith: verticleCell, infocusCell))

    diagonalCell = SLGridCell(frame: CGRect.zero)
    diagonalCell.translatesAutoresizingMaskIntoConstraints = false
    diagonalCell.setup(withViewModel: affectingModels[2])
    addSubview(diagonalCell)
    NSLayoutConstraint.activate(constraintsForDiagonalCell(diagonalCell, alingedWith:horizontalCell, verticleCell))

    let downRightArrow = UIImageView(frame: CGRect.zero)
    downRightArrow.contentMode = .scaleAspectFit
    downRightArrow.image = UIImage(named: "down_right_arrow")
    downRightArrow.translatesAutoresizingMaskIntoConstraints = false
    addSubview(downRightArrow)
    NSLayoutConstraint.activate(constraintsForDownRightArrow(downRightArrow, alignedWith: diagonalCell, infocusCell))

    if (affectingModels.count > 3) {
      let zeroCell = SLGridCell(frame: CGRect.zero)
      zeroCell.translatesAutoresizingMaskIntoConstraints = false
      zeroCell.setup(withViewModel: affectingModels[3])
      addSubview(zeroCell)
      NSLayoutConstraint.activate(constraintsForZeroCell(zeroCell, alingedWith:infocusCell))

      let leftArrow = UIImageView(frame: CGRect.zero)
      leftArrow.contentMode = .scaleAspectFit
      leftArrow.image = UIImage(named: "left_arrow")
      leftArrow.translatesAutoresizingMaskIntoConstraints = false
      addSubview(leftArrow)
      NSLayoutConstraint.activate(constraintsForLeftArrow(leftArrow, alignedWith: zeroCell, infocusCell))
    }

    let matchLabel = UILabel(frame: CGRect.zero)
    matchLabel.translatesAutoresizingMaskIntoConstraints = false
    matchLabel.textColor = .white
    matchLabel.font = UIFont.boldSystemFont(ofSize: 25)
    matchLabel.text = "Match: \(match)"
    addSubview(matchLabel)
    NSLayoutConstraint.activate(constraintsForMatchLabel(label: matchLabel, alignedWith: verticleCell))

    let misMatchLabel = UILabel(frame: CGRect.zero)
    misMatchLabel.translatesAutoresizingMaskIntoConstraints = false
    misMatchLabel.textColor = .white
    misMatchLabel.font = UIFont.boldSystemFont(ofSize: 25)
    misMatchLabel.text = "Mismatch: \(mismatch)"
    addSubview(misMatchLabel)
    NSLayoutConstraint.activate(constraintsForMismatchLabel(label: misMatchLabel, alignedWith: matchLabel))

    let indelLabel = UILabel(frame: CGRect.zero)
    indelLabel.translatesAutoresizingMaskIntoConstraints = false
    indelLabel.textColor = .white
    indelLabel.font = UIFont.boldSystemFont(ofSize: 25)
    indelLabel.text = "Indel: \(indel)"
    addSubview(indelLabel)
    NSLayoutConstraint.activate(constraintsForIndelLabel(label: indelLabel, alignedWith: misMatchLabel))

    resultDirectionLabel = UILabel(frame: CGRect.zero)
    resultDirectionLabel.translatesAutoresizingMaskIntoConstraints = false
    resultDirectionLabel.textColor = .white
    resultDirectionLabel.font = UIFont.boldSystemFont(ofSize: 25)
    addSubview(resultDirectionLabel)


    // Where to position resultDirectionLabel?
    let horizontal = Int(affectingModels[0].value)! + indel
    let verticle = Int(affectingModels[1].value)! + indel
    var diagonal = Int(affectingModels[2].value)!
    if (infocusCellViewModel.sequenceYValue == infocusCellViewModel.sequenceXValue) {
      diagonal = diagonal + match
    }
    else {
      diagonal = diagonal + mismatch
    }
    let ans = max(diagonal, max(horizontal, verticle))

    if (ans == diagonal) {
      resultDirectionLabel.text = String(mismatch)
      if (infocusCellViewModel.sequenceYValue == infocusCellViewModel.sequenceXValue) {
        resultDirectionLabel.text = "+"+String(match)
      }
      NSLayoutConstraint.activate(constraintsForResultDirectionLabel(resultDirectionLabel, alignedWithDiagonalCell: verticleCell))
    }
    else if (ans == verticle) {
      resultDirectionLabel.text = String(indel)
      NSLayoutConstraint.activate(constraintsForResultDirectionLabel(resultDirectionLabel, alignedWithVerticleCell: downArrow))
    }
    else {
      // Horizontal
      resultDirectionLabel.text = String(indel)
      NSLayoutConstraint.activate(constraintsForResultDirectionLabel(resultDirectionLabel, alignedWithHorizontalCell: rightArrow))
    }

  }

  private func constraintsForResultDirectionLabel(_ label: UIView, alignedWithVerticleCell cell: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 18),
      label.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
    ]
  }

  private func constraintsForResultDirectionLabel(_ label: UIView, alignedWithHorizontalCell cell: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 16),
      label.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -5)
    ]
  }

  private func constraintsForResultDirectionLabel(_ label: UIView, alignedWithDiagonalCell cell: UIView) -> [NSLayoutConstraint] {
    return [
      label.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: 5),
      label.rightAnchor.constraint(equalTo: cell.leftAnchor, constant: -5)
    ]
  }

  private func constraintsForHorizontalLetter(_ label: UIView, alignedWith horizontalCell: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerYAnchor.constraint(equalTo: horizontalCell.centerYAnchor),
      label.rightAnchor.constraint(equalTo: horizontalCell.leftAnchor, constant: -5)
    ]
  }

  private func constraintsForVerticleLetter(_ label: UIView, alignedWith infocusCell: UIView) -> [NSLayoutConstraint] {
    return [
      label.centerXAnchor.constraint(equalTo: infocusCell.centerXAnchor),
      label.bottomAnchor.constraint(equalTo: infocusCell.topAnchor, constant: 5)
    ]
  }

  private func constraintsForLeftArrow(_ view: UIView, alignedWith right: UIView, _ left:UIView) -> [NSLayoutConstraint] {
    return [
      view.centerYAnchor.constraint(equalTo: left.centerYAnchor),
      view.leftAnchor.constraint(equalTo: left.rightAnchor),
      view.rightAnchor.constraint(equalTo: right.leftAnchor)
    ]
  }

  private func constraintsForZeroCell(_ cell: UIView, alingedWith infocusCell: UIView) -> [NSLayoutConstraint] {
    return [
      cell.leftAnchor.constraint(equalTo: infocusCell.rightAnchor, constant: 70),
      cell.centerYAnchor.constraint(equalTo: infocusCell.centerYAnchor),
      cell.widthAnchor.constraint(equalTo: infocusCell.widthAnchor),
      cell.heightAnchor.constraint(equalTo: infocusCell.heightAnchor)
    ]
  }

  private func constraintsForDownRightArrow(_ view: UIView, alignedWith top: UIView, _ bottom:UIView) -> [NSLayoutConstraint] {
    return [
      view.leftAnchor.constraint(equalTo: top.rightAnchor, constant: -15),
      view.rightAnchor.constraint(equalTo: bottom.leftAnchor, constant: 15),
      view.topAnchor.constraint(equalTo: top.bottomAnchor, constant: -20),
      view.bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: 20),
    ]
  }

  private func constraintsForDiagonalCell(_ view: UIView, alingedWith horizontal: UIView, _ verticle: UIView) -> [NSLayoutConstraint] {
    return [
      view.leftAnchor.constraint(equalTo: horizontal.leftAnchor),
      view.rightAnchor.constraint(equalTo: horizontal.rightAnchor),
      view.topAnchor.constraint(equalTo: verticle.topAnchor),
      view.bottomAnchor.constraint(equalTo: verticle.bottomAnchor),
    ]
  }

  private func constraintsForDownArrow(_ view: UIView, alignedWith top: UIView, _ bottom:UIView) -> [NSLayoutConstraint] {
    return [
      view.centerXAnchor.constraint(equalTo: top.centerXAnchor),
      view.topAnchor.constraint(equalTo: top.bottomAnchor),
      view.bottomAnchor.constraint(equalTo: bottom.topAnchor)
    ]
  }

  private func constraintsForRightArrow(_ view: UIView, alignedWith left: UIView, _ right:UIView) -> [NSLayoutConstraint] {
    return [
      view.centerYAnchor.constraint(equalTo: left.centerYAnchor),
      view.leftAnchor.constraint(equalTo: left.rightAnchor),
      view.rightAnchor.constraint(equalTo: right.leftAnchor)
    ]
  }

  func constraintsForVerticleCell(_ cell: UIView, alingedWith focusedCell: UIView) -> [NSLayoutConstraint] {
    return [
      cell.leftAnchor.constraint(equalTo: focusedCell.leftAnchor),
      cell.rightAnchor.constraint(equalTo: focusedCell.rightAnchor),
      cell.heightAnchor.constraint(equalTo: focusedCell.heightAnchor),
      cell.bottomAnchor.constraint(equalTo: focusedCell.topAnchor, constant: -70),
    ]
  }

  func constraintsForHorizontalCell(_ cell: UIView, alingedWith focusedCell: UIView) -> [NSLayoutConstraint] {
    return [
      cell.rightAnchor.constraint(equalTo: focusedCell.leftAnchor, constant: -70),
      cell.centerYAnchor.constraint(equalTo: focusedCell.centerYAnchor),
      cell.widthAnchor.constraint(equalTo: focusedCell.widthAnchor),
      cell.heightAnchor.constraint(equalTo: focusedCell.heightAnchor)
    ]
  }

  @objc func closeButtonTapped() {
    if quizMode == false {
      delegate?.hidePresentedQuizDetailView(moveNext: false)
    }
    else {
      delegate?.hidePresentedQuizDetailView(moveNext: self.infocusCellViewModel.value == answerValue)
    }
  }

  private func constraintsForInfocusCell(_ cell: UIView,_ size: CGFloat) -> [NSLayoutConstraint] {
    return [
      cell.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50),
      cell.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60),
      cell.widthAnchor.constraint(equalToConstant: size),
      cell.heightAnchor.constraint(equalTo: cell.widthAnchor)
    ]
  }

  private func constraintsForCloseButton(_ button: UIButton) -> [NSLayoutConstraint] {
    return [
      button.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      button.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
      button.widthAnchor.constraint(equalToConstant: 40),
      button.heightAnchor.constraint(equalTo: button.widthAnchor)
    ]
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}


public extension UIView {
  public class func vibrancyEffect(_ detailView: UIView, style: UIBlurEffect.Style = .dark) -> UIView {
    let blurEffect = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(detailView)

        NSLayoutConstraint.activate(
          [
            detailView.leftAnchor.constraint(equalTo: vibrancyView.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: vibrancyView.rightAnchor),
            detailView.topAnchor.constraint(equalTo: vibrancyView.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: vibrancyView.bottomAnchor)
          ]
        )

    blurView.contentView.addSubview(vibrancyView)
    NSLayoutConstraint.activate(
      [
        vibrancyView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
        vibrancyView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
        vibrancyView.topAnchor.constraint(equalTo: blurView.topAnchor),
        vibrancyView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
      ]
    )

    return blurView
  }

  public class func blurrEffect(_ detailView: UIView, style: UIBlurEffect.Style = .dark) -> UIView {
    let blurEffect = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    blurView.translatesAutoresizingMaskIntoConstraints = false

    //    let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
    //    let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
    //    vibrancyView.translatesAutoresizingMaskIntoConstraints = false
    //    vibrancyView.contentView.addSubview(detailView)

    //    NSLayoutConstraint.activate(
    //      [
    //        detailView.leftAnchor.constraint(equalTo: vibrancyView.leftAnchor),
    //        detailView.rightAnchor.constraint(equalTo: vibrancyView.rightAnchor),
    //        detailView.topAnchor.constraint(equalTo: vibrancyView.topAnchor),
    //        detailView.bottomAnchor.constraint(equalTo: vibrancyView.bottomAnchor)
    //      ]
    //    )

    blurView.contentView.addSubview(detailView)
    NSLayoutConstraint.activate(
      [
        detailView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
        detailView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
        detailView.topAnchor.constraint(equalTo: blurView.topAnchor),
        detailView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
      ]
    )

    return blurView
  }
}

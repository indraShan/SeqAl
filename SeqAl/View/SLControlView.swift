//
//  SLControlView.swift
//  SeqAl
//
//  Created by Indrajit on 28/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public protocol SLControlViewDelegate: AnyObject {
  func didTapNextButton()
  func didTapPreviousButton()
  func didTapFastForwardButton()
  func didTapFastBackButton()
  func didTapQuizButton()
  func didTapResultButton()
  func didTapPlusButton()
  func didTapMinusButton()
}

public class SLControlView: UIView {
  static let PlaybackTimerInterval:TimeInterval = 0.4
  public weak var delegate: SLControlViewDelegate?
  private var backButton: UIButton!
  private var nextButton: UIButton!
  private var playButton: UIButton!
  private var currentTimerInterval = SLControlView.PlaybackTimerInterval
  public var isPlaying: Bool = false {
    didSet {
      setupPlayButton()
    }
  }


//  public override func layoutSubviews() {
//    super.layoutSubviews()
//    layer.cornerRadius = self.frame.size.width / 2;
//    clipsToBounds = true
//    self.layer.borderWidth = 2.0
//    self.layer.borderColor = UIColor.white.cgColor;
//  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
//    backgroundColor = .red

    playButton = UIButton(frame: CGRect.zero)
    setupPlayButton()
    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    addSubview(playButton)
    NSLayoutConstraint.activate(constraintsForPlayButton(playButton))

    backButton = UIButton(frame: CGRect.zero)
    backButton.setImage(UIImage(named: "left"), for: .normal)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    addSubview(backButton)
    NSLayoutConstraint.activate(constraintsForBackButton(backButton, alignedWithPlayButton: playButton))

    nextButton = UIButton(frame: CGRect.zero)
    nextButton.setImage(UIImage(named: "right"), for: .normal)
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    addSubview(nextButton)
    NSLayoutConstraint.activate(constraintsForNextButton(nextButton, alignedWithPlayButton: playButton))

    backButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPress(gesture:))))
    nextButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPress(gesture:))))

    let quizButton = UIButton(frame: CGRect.zero)
    quizButton.setImage(UIImage(named: "question"), for: .normal)
    quizButton.translatesAutoresizingMaskIntoConstraints = false
    quizButton.addTarget(self, action: #selector(quizButtonTapped), for: .touchUpInside)
    addSubview(quizButton)
    NSLayoutConstraint.activate(constraintsForQuizButton(quizButton, alignedWithPlayButton: playButton))

    let resultButton = UIButton(frame: CGRect.zero)
    resultButton.setImage(UIImage(named: "info"), for: .normal)
    resultButton.translatesAutoresizingMaskIntoConstraints = false
    resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    addSubview(resultButton)
    NSLayoutConstraint.activate(constraintsForResultButton(resultButton, alignedWithPlayButton: playButton))

    let plusButton = UIButton(frame: CGRect.zero)
    plusButton.setImage(UIImage(named: "plus"), for: .normal)
    plusButton.translatesAutoresizingMaskIntoConstraints = false
    plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    addSubview(plusButton)
    NSLayoutConstraint.activate(constraintsForPlusButton(plusButton, alignedWithPlayButton: playButton))

    let minusButton = UIButton(frame: CGRect.zero)
    minusButton.setImage(UIImage(named: "minus"), for: .normal)
    minusButton.translatesAutoresizingMaskIntoConstraints = false
    minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    addSubview(minusButton)
    NSLayoutConstraint.activate(constraintsForMinusButton(minusButton, alignedWithPlayButton: playButton))
  }

  @objc func plusButtonTapped() {
    currentTimerInterval = currentTimerInterval - 0.1
  }

  @objc func minusButtonTapped() {
    currentTimerInterval = currentTimerInterval + 0.1
  }

  func constraintsForPlusButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.6),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 0),
      button.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: 25)
    ]
  }

  func constraintsForMinusButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.6),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 0),
      button.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: -25)
    ]
  }

  func constraintsForResultButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.6),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: 0),
      button.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: -25)
    ]
  }

  func constraintsForQuizButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.6),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: 0),
      button.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: 25)
    ]
  }

  func setupPlayButton()  {
    if (isPlaying == false) {
      playButton.setImage(UIImage(named: "play"), for: .normal)
    }
    else {
      playButton.setImage(UIImage(named: "pause"), for: .normal)
    }
  }

  @objc func buttonLongPress(gesture: UILongPressGestureRecognizer) {
    if (gesture.state != .ended) {
      return
    }
    isPlaying = false
    if (gesture.view == backButton) {
      delegate?.didTapFastBackButton()
    }
    else {
      // Next button
      delegate?.didTapFastForwardButton()
    }
  }

  @objc func resultButtonTapped() {
    delegate?.didTapResultButton()
  }

  @objc func quizButtonTapped() {
    isPlaying = false
    delegate?.didTapQuizButton()
  }

  @objc func nextButtonTapped() {
    isPlaying = false
    delegate?.didTapNextButton()
  }

  @objc func backButtonTapped() {
    isPlaying = false
    delegate?.didTapPreviousButton()
  }

  @objc func playButtonTapped() {
    isPlaying = !isPlaying
    if (isPlaying) {
      DispatchQueue.global(qos: .userInitiated).async {
        while(self.isPlaying) {
          DispatchQueue.main.async {
            self.delegate?.didTapNextButton()
          }
          Thread.sleep(forTimeInterval: self.currentTimerInterval)
        }
      }
    }
//    if (playbackTimer == nil) {
//      playbackTimer = Timer(timeInterval: currentTimerInterval, repeats: true, block: { (timer) in
//        self.delegate?.didTapNextButton()
//      })
//      RunLoop.main.add(playbackTimer!, forMode: RunLoop.Mode.common)
//    }
//    else {
//      playbackTimer?.invalidate()
//      playbackTimer = nil
//    }
  }



  func constraintsForNextButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.7),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: 4),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }

  func constraintsForBackButton(_ button: UIView, alignedWithPlayButton playButton: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 0.7),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -4),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }

  func constraintsForPlayButton(_ button: UIView) -> [NSLayoutConstraint] {
    return [
      button.widthAnchor.constraint(equalToConstant: 50),
      button.heightAnchor.constraint(equalTo: button.widthAnchor),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func decoratorCellViewModelForValue(_ value: String) -> SLGridCellViewModel {
    let cellViewModel = SLGridCellViewModel()
    cellViewModel.value = value
    cellViewModel.backgroundColor = UIColor(red: 134.0/255, green: 144.0/255, blue: 252.0/255, alpha: 1)
    cellViewModel.textColor = UIColor.white
    cellViewModel.highlightedTextColor = .red
    return cellViewModel
  }
  
}

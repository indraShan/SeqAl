//
//  SLViewController.swift
//  SeqAl
//
//  Created by Indrajit on 15/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class SLViewController: UIViewController {

  struct Constants {
    static let CollectionViewLeftPadding: CGFloat = 5.0
    static let CollectionViewRightPadding: CGFloat = 10.0
    static let BackGroundColor = UIColor(red: 134.0/255, green: 144.0/255, blue: 252.0/255, alpha: 1)
  }

  private var gridViewModel: SLGridViewModel!
  private var inputViewModel: SLInputViewModel!
  private var inputOverlayView: UIView!
  private var gridView: SLGridView!
  private var detailView: UIView?
  private var controlView: SLControlView!
  private var resultView: SLAlignmentResultView?
  private var blurredViewResults: UIView?
  private var resultsLeftAnchor: NSLayoutConstraint!
  private var resultsBottonAnchor: NSLayoutConstraint!

  private var x = "ACATCG"
  private var y = "AATTCG"

  @objc func handleNextTap() {
    gridViewModel.next()
  }

  @objc func handlePrevTap() {
    gridViewModel.previous()
  }

  @objc func fullForward() {
    gridViewModel.solveAlignment()
  }

  @objc func resetToSolve() {
    // Test
    gridViewModel.resetToSolve()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Constants.BackGroundColor


    gridView = SLGridView(frame: CGRect.zero)
    gridView.delegate = self;
    let viewModel = SLGridViewModel(x, y, .GlobaAlignment)
    gridViewModel = viewModel
    // Ask the view-model to be ready for updates from the view using it.
    viewModel.prepare();
    gridViewModel.solveAlignment();
    gridView.viewModel = viewModel
    gridView.translatesAutoresizingMaskIntoConstraints = false;
    gridView.backgroundColor = view.backgroundColor
    let constraints = contraintsForGridView(gridView)
    view.addSubview(gridView)
    NSLayoutConstraint.activate(constraints)


    controlView = SLControlView()
    controlView.translatesAutoresizingMaskIntoConstraints = true
    controlView.delegate = self
    view.addSubview(controlView)
    controlView.frame = CGRect(x: 500, y: 220, width: 130, height: 130)
//    NSLayoutConstraint.activate(constraintsForControlView(controlView))
    controlView.isHidden = true
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanResultsView(gesture:)))
    panGesture.minimumNumberOfTouches = 1
    controlView.addGestureRecognizer(panGesture)
  }

  func constraintsForResultView(_ resultView: UIView) -> [NSLayoutConstraint] {
    resultsLeftAnchor = resultView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
    resultsBottonAnchor = resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
    return [
      resultsLeftAnchor,
      resultView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
      resultView.heightAnchor.constraint(equalToConstant: 100),
      resultsBottonAnchor
    ]
  }

  func constraintsForControlView(_ controlView: UIView) -> [NSLayoutConstraint] {
    return [
      controlView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
      controlView.rightAnchor.constraint(equalTo: view.rightAnchor),
      controlView.heightAnchor.constraint(equalToConstant: 130),
      controlView.widthAnchor.constraint(equalToConstant: 130)
    ]
  }

  func contraintsForInputView(_ inputView: UIView) -> [NSLayoutConstraint] {
    return [
      view.leftAnchor.constraint(equalTo: inputView.leftAnchor),
      view.rightAnchor.constraint(equalTo: inputView.rightAnchor),
      view.topAnchor.constraint(equalTo: inputView.topAnchor),
      view.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
    ]
  }

  func contraintsForPreviousButton(_ button: UIButton, nextButton: UIButton) -> [NSLayoutConstraint] {
    return [
      view.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -5),
      button.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 5)
    ]
  }

  func contraintsForNextButton(_ button: UIButton) -> [NSLayoutConstraint] {
    return [
      view.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -5),
      view.topAnchor.constraint(equalTo: button.topAnchor, constant: -15)
    ]
  }

  func contraintsForGridView(_ gridView: UIView) -> [NSLayoutConstraint] {
    return [
      gridView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      gridView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ]
  }

  private func constraintsForDetailView(_ detailView: UIView) -> [NSLayoutConstraint] {
    return [
      detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
      detailView.rightAnchor.constraint(equalTo: view.rightAnchor),
      detailView.topAnchor.constraint(equalTo: view.topAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
  }

  @objc func didPanResultsView(gesture: UIPanGestureRecognizer) {
    if (gesture.state == .changed) {
      let point = gesture.location(in: gesture.view?.superview)
      gesture.view?.center = point
    }
  }

}

extension SLViewController: SLInputViewDelegate {
  func didFinishInputFlowWith(x: String, y: String, type: AlignmentType) {
    let viewModel = SLGridViewModel(x, y, type)
    gridViewModel = viewModel
    // Ask the view-model to be ready for updates from the view using it.
    viewModel.prepare();
    gridView.viewModel = viewModel

    // Remove overlay
    inputOverlayView.removeFromSuperview()
    inputOverlayView = nil
  }
}

extension SLViewController: SLControlViewDelegate {
  func didTapPlusButton() {

  }

  func didTapMinusButton() {
    
  }

  func didTapNextButton() {
    gridViewModel.next()
  }
  func didTapPreviousButton() {
    gridViewModel.previous()
  }
  func didTapFastForwardButton() {
    gridViewModel.solveAlignment()
  }
  func didTapFastBackButton() {
    gridViewModel.resetToSolve()
  }

  func didTapQuizButton() {
    gridView.startQuiz()
  }

  func didTapResultButton() {
    if (blurredViewResults != nil) {
      blurredViewResults?.removeFromSuperview()
      blurredViewResults = nil
      resultView = nil
    }
    else {
      resultView = SLAlignmentResultView.resultsView(xAlignment: gridViewModel.xAlignment,
                                                     yAlignment: gridViewModel.yAlignment,
                                                     alignedIndex: gridViewModel.getAlignmentIndex(),
                                                     showAlignment: gridViewModel.showAlignment)
      resultView?.translatesAutoresizingMaskIntoConstraints = false
      blurredViewResults = UIView.blurrEffect(resultView!, style: .light)
      blurredViewResults?.translatesAutoresizingMaskIntoConstraints = true
      view.addSubview(blurredViewResults!)
      blurredViewResults?.frame = CGRect.init(x: 50, y: 290, width: self.view.frame.size.width - 200, height: 100)
      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanResultsView(gesture:)))
      panGesture.minimumNumberOfTouches = 1
      blurredViewResults?.addGestureRecognizer(panGesture)
    }
  }
}


extension SLViewController: SLGridViewDelgate {
  func alignmentDidChange(index: Int) {
    if (resultView == nil) {
      return
    }
    resultView?.currentAlignmentIndex = index
  }



  func showQuizDetailView(detailView: UIView) {
    self.detailView = detailView
    detailView.translatesAutoresizingMaskIntoConstraints = false
    detailView.alpha = 0
    self.view.addSubview(detailView)
    NSLayoutConstraint.activate(self.constraintsForDetailView(detailView))
    UIView.animate(withDuration: 0.4) {
      self.detailView?.alpha = 1
    }
  }

  func hidePresentedQuizDetailView(moveNext: Bool) {
    self.detailView?.removeFromSuperview()
    if (moveNext) {
      gridViewModel.next()
    }
  }

  func didTapOnRemoteButton() {
    controlView.isHidden = !controlView.isHidden
  }

  func didTapOnEditButton() {
    // Get rid of results view, as the input is going to change.
    if (blurredViewResults != nil) {
      blurredViewResults?.removeFromSuperview()
      blurredViewResults = nil
      resultView = nil
    }
    inputViewModel = SLInputViewModel(x, y)
    inputOverlayView = SLInputView.createInputView(withModel: inputViewModel, delegate: self)
    inputOverlayView.translatesAutoresizingMaskIntoConstraints = false
    inputOverlayView.alpha = 0
    view.addSubview(inputOverlayView)
    NSLayoutConstraint.activate(contraintsForInputView(inputOverlayView))
    UIView.animate(withDuration: 0.4) {
      self.inputOverlayView.alpha = 1
    }
  }
}

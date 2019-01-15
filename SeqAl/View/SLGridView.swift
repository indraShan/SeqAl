//
//  SLGridView.swift
//  SeqAl
//
//  Created by Indrajit on 15/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public protocol SLGridViewDelgate: AnyObject {
  func showQuizDetailView(detailView: UIView)
  func hidePresentedQuizDetailView(moveNext: Bool)
  func didTapOnRemoteButton()
  func didTapOnEditButton()
  func alignmentDidChange(index: Int)
}

// Get the alignment to work.
// Make sure its easy to extend/modify.
// Work on UI.
// Play/Pause.
// Info Mode
// Quize mode
public class SLGridView : UIView {

  var viewModel: SLGridViewModel! {
    didSet {
      viewModel.deleate = self
      collectionView.reloadData()
    }
  }

  struct Constants {
    static let GridCellRegularSize = CGSize.init(width: 70, height: 70)
  }

  public func startQuiz() {
    guard let infocusGridModel = viewModel.nextCellGridViewModel() else {
      return
    }
    let indexPath = IndexPath(row: infocusGridModel.row, section: infocusGridModel.section)
    infocusGridModel.sequenceXValue = viewModel.sequenceXValueFor(indexPath)
    infocusGridModel.sequenceYValue = viewModel.sequenceYValueFor(indexPath)
    let affectingModels = viewModel.cellModelsAffectingGridAtIndexPath(indexPath)
    let possibleAnswers = viewModel.possibleAnswersForGridAtIndexPath(indexPath)
    let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let detailView = SLQuizDetailView.detailViewFor(infocusGridModel: infocusGridModel,
                                                    affectingModels: affectingModels,
                                                    size: flowLayout.itemSize.width,
                                                    delegate: delegate,
                                                    quizMode: true,
                                                    match: viewModel.match,
                                                    mismatch: viewModel.mismatch,
                                                    indel: viewModel.indel,
                                                    possibleAnswers: possibleAnswers)
    delegate?.showQuizDetailView(detailView: detailView)
  }

  public weak var delegate: SLGridViewDelgate?

  private var collectionView: UICollectionView!

  public override init(frame: CGRect) {
    super.init(frame: frame)


    collectionView = createCollectionView()
    addSubview(collectionView)
    let constraints = constraintsForCollectionView(collectionView)
    NSLayoutConstraint.activate(constraints)


    if #available(iOS 11.0, *) {
      collectionView?.contentInsetAdjustmentBehavior = .always
    }
  }

  func constraintsForCollectionView(_ collectionView: UICollectionView) -> [NSLayoutConstraint] {
    return [
      leftAnchor.constraint(equalTo: collectionView.leftAnchor),
      rightAnchor.constraint(equalTo: collectionView.rightAnchor),
      topAnchor.constraint(equalTo: collectionView.topAnchor),
      bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
    ]
  }

  public override var backgroundColor: UIColor? {
    didSet {
      collectionView.backgroundColor = self.backgroundColor
    }
  }

  func createCollectionView() -> UICollectionView {
    let flowLayout = UICollectionViewFlowLayout()

    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    flowLayout.minimumInteritemSpacing = 0
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    flowLayout.minimumLineSpacing = 0
    flowLayout.sectionInset = UIEdgeInsets.zero
    collectionView.delaysContentTouches = false
    collectionView.register(SLGridCell.self, forCellWithReuseIdentifier: SLGridCell.cell_reuseIdentifier())
    collectionView.register(SLSettingsCell.self, forCellWithReuseIdentifier: SLSettingsCell.cell_reuseIdentifier())
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func showDetailForGridAtIndexPath(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
    if (indexPath.section <= 1 || indexPath.row <= 1) {
      return
    }
    let infocusGridModel = viewModel.cellViewModeForIndexPath(indexPath).copy() as! SLGridCellViewModel
    infocusGridModel.highlight = false
    infocusGridModel.sequenceXValue = viewModel.sequenceXValueFor(indexPath)
    infocusGridModel.sequenceYValue = viewModel.sequenceYValueFor(indexPath)
    let affectingModels = viewModel.cellModelsAffectingGridAtIndexPath(indexPath)
    let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let detailView = SLQuizDetailView.detailViewFor(infocusGridModel: infocusGridModel,
                                                    affectingModels: affectingModels,
                                                    size: flowLayout.itemSize.width,
                                                    delegate: delegate,
                                                    match: viewModel.match,
                                                    mismatch: viewModel.mismatch,
                                                    indel: viewModel.indel)
    delegate?.showQuizDetailView(detailView: detailView)
  }
}

extension SLGridView : UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    showDetailForGridAtIndexPath(indexPath, collectionView)
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItemsInSection(section)
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if (indexPath.section == 0 && indexPath.row == 0) {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SLSettingsCell.cell_reuseIdentifier(), for: indexPath) as! SLSettingsCell
      cell.delegate = self.delegate
      cell.setup(viewModel: viewModel.cellViewModeForIndexPath(indexPath) as! SLSettingsCellViewModel)
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SLGridCell.cell_reuseIdentifier(), for: indexPath) as! SLGridCell
      cell.setup(withViewModel: viewModel.cellViewModeForIndexPath(indexPath) as! SLGridCellViewModel)
      return cell
    }
  }
  
}

extension SLGridView : UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width
    let numberOfitems = viewModel.numberOfItemsInSection(0)
    let itemWidth = floor(width/CGFloat(numberOfitems))
    return CGSize.init(width: itemWidth, height: itemWidth)
  }
}

extension SLGridView : UICollectionViewDelegate {

}

extension SLGridView : SLGridViewModelDelegate {


  //  Work on cell updates next.
  //   fill everything with -
  //  Then foward playback.
  //  Once that works, work on showing the path.
  //  After that figure out the init part.
  //  With the flowlayout, add in init animations.
  //  Add update animation.
  //  Write custom layout
  //  Rest
  public func insert(gridCell cell: SLGridCellViewModel) {
    collectionView.reloadData()
//    collectionView.scrollToItem(at: IndexPath(row: cell.row, section: cell.section), at: .centeredHorizontally, animated: true)
  }

  public func update(gridCell cell: SLGridCellViewModel, alignmentIndex: Int) {
    delegate?.alignmentDidChange(index: alignmentIndex)
    collectionView.reloadData()
  }

  public func remove(gridCell cell: SLGridCellViewModel) {
    collectionView.reloadData()
  }
  public func refresh() {
    collectionView.reloadData()
  }
}

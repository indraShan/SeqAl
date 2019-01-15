//
//  SLAlignmentResultView.swift
//  SeqAl
//
//  Created by Indrajit on 30/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public class SLAlignmentResultView: UIView {

  public class func resultsView(xAlignment: [String],
                                yAlignment: [String],
                                alignedIndex: Int,
                                showAlignment: Bool = false) -> SLAlignmentResultView {
    return SLAlignmentResultView(xAlignment, yAlignment, alignedIndex, showAlignment)
  }

  private var showAlignment = false
  private var xLabel: UILabel!
  private var yLabel: UILabel!
  private var xAlignment: [String]!
  private var yAlignment: [String]!

  public var currentAlignmentIndex: Int {
    didSet {
      setupLabels()
    }
  }

  private func setupLabels() {
    if (currentAlignmentIndex < 0) {
      xLabel.text = "X: "+xAlignment.reduce("", { x, _ in x + "-" })
      yLabel.text = "Y: "+yAlignment.reduce("", { x, _ in x + "-" })
    }
    else {
      // Need to refresh
      var xString = ""
      var wall = xAlignment.count - currentAlignmentIndex - 1
      var index = 0
      for char in xAlignment {
        if (index >= wall) {
          xString = xString + char
        }
        else {
          xString = xString + "-"
        }
        index = index + 1
      }
      xLabel.text = "X :"+xString

      var yString = ""
      wall = yAlignment.count - currentAlignmentIndex - 1
      index = 0
      for char in yAlignment {
        if (index >= wall) {
          yString = yString + char
        }
        else {
          yString = yString + "-"
        }
        index = index + 1
      }
      yLabel.text = "Y :"+yString

    }
  }

  public convenience init(_ xAlignment: [String],
                          _ yAlignment: [String],
                          _ alignedIndex: Int,
                          _ showAlignment: Bool = false) {
    self.init(frame: CGRect.zero)
    backgroundColor = UIColor.clear
//    alpha = 0.5
    self.xAlignment = xAlignment
    self.yAlignment = yAlignment

    xLabel  = UILabel(frame: CGRect.zero)
    xLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(xLabel)
    xLabel.textColor = .black
    xLabel.font = UIFont.boldSystemFont(ofSize: 30)
    NSLayoutConstraint.activate(contraintsForXLabel(xLabel))

    yLabel  = UILabel(frame: CGRect.zero)
    yLabel.translatesAutoresizingMaskIntoConstraints = false
    yLabel.textColor = xLabel.textColor
    addSubview(yLabel)
    yLabel.font = UIFont.boldSystemFont(ofSize: 30)
    NSLayoutConstraint.activate(contraintsForYLabel(yLabel, alignedWith:xLabel))
    self.currentAlignmentIndex = alignedIndex
    setupLabels()
  }


  private func contraintsForYLabel(_ yLabel: UIView, alignedWith xLabel: UILabel) -> [NSLayoutConstraint] {
    return [
      yLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      yLabel.topAnchor.constraint(equalTo: xLabel.bottomAnchor, constant: 10)
    ]
  }

  private func contraintsForXLabel(_ xLabel: UIView) -> [NSLayoutConstraint] {
    return [
      xLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      xLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
    ]
  }

  public override init(frame: CGRect) {
    self.currentAlignmentIndex = 0
    super.init(frame: frame)
    backgroundColor = UIColor.clear
    alpha = 0.2
  }

  public required init?(coder aDecoder: NSCoder) {
    self.currentAlignmentIndex = 0
    super.init(coder: aDecoder)
  }
}

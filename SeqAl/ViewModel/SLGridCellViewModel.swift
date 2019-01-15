//
//  SLGridCellViewModel.swift
//  SeqAl
//
//  Created by Indrajit on 28/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation
import UIKit

public enum ArrowDirectin: Int {
  case Horizontal = 0
  case Vertcle = 1
  case Diagonal = 2
  case None = 3
}

public class SLGridCellViewModel : NSObject {
  var value: String!
  var section: Int!
  var row: Int!
  var highlight = false
  var backgroundColor: UIColor!
  var textColor: UIColor!
  var highlightedTextColor: UIColor!
  var sequenceXValue: String?
  var sequenceYValue: String?
  var arrow = ArrowDirectin.None

  public override func copy() -> Any {
    let copied = SLGridCellViewModel()
    copied.value = value
    copied.section = section
    copied.row = row
    copied.highlight = highlight
    copied.backgroundColor = backgroundColor
    copied.textColor = textColor
    copied.highlightedTextColor = highlightedTextColor
    copied.sequenceXValue = sequenceXValue
    copied.sequenceYValue = sequenceYValue
    return copied
  }

}


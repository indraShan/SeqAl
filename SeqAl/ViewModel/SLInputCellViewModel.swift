//
//  SLTextInputCellViewModel.swift
//  SeqAl
//
//  Created by Indrajit on 28/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation
import UIKit

public class SLTextInputCellViewModel: NSObject {

  public var headerText: String!
  public var inputValue: String
  public var returnKeyType: UIReturnKeyType

  public init(_ inputValue: String, _ headerText: String,_ returnKeyType: UIReturnKeyType) {
    self.inputValue = inputValue
    self.headerText = headerText
    self.returnKeyType = returnKeyType
    super.init()
  }

}

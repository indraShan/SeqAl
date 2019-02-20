//
//  SLInputViewModel.swift
//  SeqAl
//
//  Created by Indrajit on 27/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation
import UIKit

public class SLInputViewModel: NSObject {

  public var type: AlignmentType = .GlobaAlignment

  public var inputViewModels: [AnyObject]

  public init(_ x: String, _ y: String) {
    inputViewModels = [AnyObject]()
    inputViewModels.append(SLTextInputCellViewModel(x, "X", UIReturnKeyType.next))
    inputViewModels.append(SLTextInputCellViewModel(y, "Y", UIReturnKeyType.next))
    super.init()
  }

}

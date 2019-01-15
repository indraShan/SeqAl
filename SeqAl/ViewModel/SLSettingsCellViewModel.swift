//
//  SLSettingsCellViewModel.swift
//  SeqAl
//
//  Created by Indrajit on 29/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit

public class SLSettingsCellViewModel: NSObject {
  public var image1: UIImage
  public var image2: UIImage
  public var backgroundColor: UIColor
  public init(_ image1: UIImage, _ image2: UIImage, _ bgColor: UIColor) {
    self.image1 = image1
    self.image2 = image2
    self.backgroundColor = bgColor
    super.init()
  }
}

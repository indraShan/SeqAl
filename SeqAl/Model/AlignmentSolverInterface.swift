//
//  AlignmentSolverInterface.swift
//  SeqAl
//
//  Created by Indrajit on 29/11/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation

public class AlignmentSolverInterface: NSObject {
  var grid: [[Int]]!
  public var xAlignment = [String] ()
  public var yAlignment = [String] ()
  func solve(match: Int, mismatch: Int, indel: Int) {
    
  }
  func findAlignment(match: Int, mismatch: Int, indel: Int) -> [[Int]] {
    return  [[Int]]()
  }
}

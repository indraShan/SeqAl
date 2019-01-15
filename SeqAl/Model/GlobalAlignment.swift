//
//  GlobalAlignment.swift
//  SeqAl
//
//  Created by Indrajit on 28/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation


public class GlobalAlignment: AlignmentSolverInterface {
  private var x: String
  private var y: String

  // Contains the full grid

  public var xArray = Array<Character> ()
  public var yArray = Array<Character> ()

  public override func solve(match: Int, mismatch: Int, indel: Int) {
      for r in 0...x.count {
          grid[r][0] = r * indel
      }

      for c in 0...y.count {
          grid[0][c] = c * indel
      }


      for rowIndex in 1...x.count {
          for colIndex in 1...y.count {
              let rowChar = xArray[rowIndex - 1]
              let colChar = yArray[colIndex - 1]

              var maxValue = max(grid[rowIndex - 1][colIndex] + indel, grid[rowIndex][colIndex-1] + indel)

              if (rowChar == colChar) {
                  maxValue = max(maxValue, grid[rowIndex - 1][colIndex - 1] + match)
              } else {
                      maxValue = max(maxValue, grid[rowIndex - 1][colIndex - 1] + mismatch)
              }

              grid[rowIndex][colIndex] = maxValue
          }
      }
  }

  public override func findAlignment(match: Int, mismatch: Int, indel: Int) -> [[Int]] {
      var alignmentValues: [[Int]] = [[Int]] ()
      var currentRow = grid.count - 1
      var currentCol = grid[0].count - 1

      while (true) {
          var alignedValues = [Int] ()

          if (currentRow == 0) {
              while (currentCol != 0) {
                  alignedValues.append(currentRow)
                  alignedValues.append(currentCol)
                  alignmentValues.append(alignedValues)
                  alignedValues.removeAll()
                  xAlignment.insert("-", at:0)
                  yAlignment.insert(String(yArray[currentCol - 1]), at: 0)
                  currentCol -= 1
              }
              break
          } else if (currentCol == 0) {
              while (currentRow != 0) {
                  alignedValues.append(currentRow)
                  alignedValues.append(currentCol)
                  alignmentValues.append(alignedValues)
                  alignedValues.removeAll()
                  xAlignment.insert(String(xArray[currentRow - 1]), at: 0)
                  yAlignment.insert("-", at: 0)
                  currentRow -= 1
              }
              break
          }

          alignedValues.append(currentRow)
          alignedValues.append(currentCol)
          alignmentValues.append(alignedValues)
          let rowChar = xArray[currentRow - 1]
          let colChar = yArray[currentCol - 1]

          var diagonal: Int

          if (rowChar == colChar) {
              diagonal = grid[currentRow][currentCol] - match
          } else {
              diagonal = grid[currentRow][currentCol] - mismatch
          }

          let left = grid[currentRow][currentCol] - indel
          let top = grid[currentRow][currentCol] - indel

          if (diagonal == grid[currentRow - 1][currentCol - 1]) {
              xAlignment.insert(String(xArray[currentRow - 1]), at: 0)
              yAlignment.insert(String(yArray[currentCol - 1]), at: 0)
              currentRow -= 1
              currentCol -= 1
          } else if (top == grid[currentRow - 1][currentCol]) {
              xAlignment.insert(String(xArray[currentRow - 1]), at: 0)
              yAlignment.insert("-", at: 0)
              currentRow -= 1
          } else if (left == grid[currentRow][currentCol - 1]){
              xAlignment.insert("-", at:0)
              yAlignment.insert(String(yArray[currentCol - 1]), at: 0)
              currentCol -= 1
          }
      }

      return alignmentValues
  }

  public override var description: String {
    var printableString = ""
    for row in grid {
      for item in row {
        printableString += (", " + String(item))
      }
      printableString += "\n"
    }
    return printableString
  }

  // x defines the number of rows.
  // y defines the number of columns for each row.
  public init(_ x: String, _ y: String) {
    self.x  = x
    self.y = y
    super.init()
    grid = [[Int]](repeating: [Int](repeating: 0, count: y.count + 1), count: x.count + 1)
    xArray = Array(self.x)
    yArray = Array(self.y)
  }

}

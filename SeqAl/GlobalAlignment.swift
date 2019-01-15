//
//  GlobalAlignment.swift
//  BioProject2
//
//  Created by Indrajit on 28/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation


public class GlobalAlignment: NSObject {
  private var x: String
  private var y: String
  // Contains the full grid
  public var grid: [[Int]] = [[Int]]()

  public func findAligntment() -> [[Int]] {
    var alignmentValues: [[Int]] = [[Int]]()

    // Starting from the bottom right value in the grid,
    // trace it back to top left corner.
    var currentRow = grid.count - 1
    var currentColumn = grid[currentRow].count-1
    while (currentRow >= 0 && currentColumn >= 0) {
      var alignedValues = [Int]()
      alignedValues.append(currentRow)
      alignedValues.append(currentColumn)
      alignmentValues.append(alignedValues)

      // Of the three possible values, which path did we take?
      let diagonal = (currentRow - 1 < 0 || currentColumn - 1 < 0) ? Int.max : grid[currentRow - 1][currentColumn - 1]
      let verticle = (currentRow - 1 < 0) ? Int.max : grid[currentRow - 1][currentColumn]
      let horizontal = (currentColumn - 1 < 0) ? Int.max : grid[currentRow][currentColumn - 1]
      var minValue = min(diagonal, verticle)
      minValue = min(minValue, horizontal)
      if (minValue == diagonal) {
        currentColumn -= 1
        currentRow -= 1
      }
      else if (minValue == horizontal) {
        currentColumn -= 1
      }
      else {
        currentRow -= 1
      }
    }

    return alignmentValues
  }

  public func solve() {
    // Create rows
    for _ in 0...x.count {
      grid.append([Int]())
    }

    // Fill fist row
    grid[0].append(0)
    for index in 0..<y.count {
      grid[0].append(index+1)
    }

    // Fill first column
    for index in 0..<x.count {
      grid[index+1].append(index+1)
    }

    // Start solving start from 1st row 1st column
    let xArray = Array(x)
    let yArray = Array(y)
    for rowIndex in 1...x.count {
      for columnIndex in 1...y.count {
        let rowChar = xArray[rowIndex - 1]
        let columnChar = yArray[columnIndex - 1]
        if (rowChar == columnChar) {
          grid[rowIndex].append(grid[rowIndex-1][columnIndex-1])
        }
        else {
          var minValue = min(grid[rowIndex-1][columnIndex], grid[rowIndex][columnIndex-1])
          minValue = min(minValue, grid[rowIndex-1][columnIndex-1])
          grid[rowIndex].append(minValue+1)
        }
      }
    }
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
  }

}

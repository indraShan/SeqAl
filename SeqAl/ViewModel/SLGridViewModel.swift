//
//  SLGridViewModel.swift
//  SeqAl
//
//  Created by Indrajit on 31/10/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import Foundation
import UIKit

public protocol SLGridViewModelDelegate: AnyObject {
  func insert(gridCell cell: SLGridCellViewModel)
  func remove(gridCell cell: SLGridCellViewModel)
  func update(gridCell cell: SLGridCellViewModel, alignmentIndex: Int)
  func refresh()
}

public class SLGridViewModel: NSObject {
  //  Takes x and y.
  //  Creates the initial view model.
  //  Has methods that alter the array it holds.
  //  Has a protcol that the view implements.
  //  View updates the collection view and cells when the view model makes changes to its state.

  //  Maintains the index of where it is currently in the calculation. Everything derived from that.

  enum PlaybackState {
    case setup
    case solve
    case align
  }

  private var currentState = PlaybackState.setup
  public weak var deleate: SLGridViewModelDelegate?
  public var alignmentSolver: AlignmentSolverInterface!
  private var grid: [[SLGridCellViewModel]] = [[SLGridCellViewModel]]()
  private var sequenceGrid: [[AnyObject]] = [[AnyObject]]()
  private var lastGridViewModel: SLGridCellViewModel?

  public var xAlignment: [String] {
    get {
      return self.alignmentSolver.xAlignment
    }
  }

  public var yAlignment: [String] {
    get {
      return self.alignmentSolver.yAlignment
    }
  }

  public var showAlignment: Bool {
    get {
      if (alignmentType == .GlobaAlignment) {
        return false
      }
      return true
    }
  }

  private var alignmentIndex = 0
  private var alignmentGrid: [[Int]] = [[Int]]()
  public let rowSequence: String
  public let columnSequence: String
  public let match = 1
  public let mismatch = -1
  public let indel = -2
  public let alignmentType: AlignmentType

  public var numberOfSections : Int {
    get {
      return sequenceGrid.count
    }
  }

  public func getAlignmentIndex() -> Int {
    if (currentState != .align) {
      return -1
    }
    return alignmentIndex
  }

  private var infocusIndexPath: IndexPath

  init(_ x: String, _ y: String, _ type: AlignmentType) {
    infocusIndexPath = IndexPath(row: 0, section: 0)
    var inputX = x
    var inputY = y
    alignmentType = type
    if (type == .PatternSearch && x.count > y.count) {
      rowSequence = x
      columnSequence = y
      let temp = inputX
      inputX = inputY
      inputY = temp
    }
    else {
      rowSequence = y
      columnSequence = x
    }

    if (type == .GlobaAlignment) {
      alignmentSolver = GlobalAlignment(x, y)
    }
    else if (type == .LocalAlignment) {
      alignmentSolver = LocalAlignment(x, y)
    }
    else if (type == .DoveTail) {
      alignmentSolver = DovetailAlignment(x, y)
    }
    else {
      alignmentSolver = PatternSearch(inputX, inputY)
    }


    super.init()
  }

  public func cellModelsAffectingGridAtIndexPath(_ indexPath: IndexPath) -> [SLGridCellViewModel] {
    var cells =  [
      grid[indexPath.section - 1][indexPath.row - 2],// horizontal
      grid[indexPath.section - 2][indexPath.row - 1],// verticle
      grid[indexPath.section - 2][indexPath.row - 2],  // diagonal
    ]
    if (alignmentType == .LocalAlignment) {
      cells.append(gridCellViewModelForValue("0")) // Zero cell
    }
    return cells
  }
  
  public func possibleAnswersForGridAtIndexPath(_ indexPath: IndexPath) -> [Int] {
    var cells =  Set<Int>()
    if (alignmentType == .LocalAlignment) {
      cells.insert(0)
    }
    // Actual answer
    let ans = alignmentSolver.grid[indexPath.section-1][indexPath.row-1]
    cells.insert(ans)
    let affecting = cellModelsAffectingGridAtIndexPath(indexPath)
    cells.insert(Int(affecting[0].value)!+indel)
    cells.insert(Int(affecting[1].value)!+indel)
    cells.insert(Int(affecting[2].value)!+match)
    cells.insert(Int(affecting[2].value)!+mismatch)
    // Add random numbers if the we couldnt find unique values.
    var answers = Array(cells)
    while (answers.count < 3) {
      answers.append(Int.random(in: ans-3..<ans+5))
    }
    return answers.shuffled()
  }

  public func numberOfItemsInSection(_ section: Int) -> Int {
    if (section == 0) {
      return sequenceGrid[0].count
    }
    return 1 + grid[section - 1].count
  }

  // IndexPath.section is matched with the 'row' of grid
  public func cellViewModeForIndexPath(_ indexPath: IndexPath) -> AnyObject {
    if (indexPath.section == 0 || indexPath.row == 0) {
      return sequenceGrid[indexPath.section][indexPath.row];
    }
    return grid[indexPath.section - 1][indexPath.row - 1]
  }

  // Y is drawn on first row
  public func sequenceYValueFor(_ indexPath: IndexPath) -> String {
    var index = 0
    for character in self.rowSequence {
      if (index == indexPath.row - 2) {
        return String(character)
      }
      index = index + 1
    }
    return ""
  }

  public func sequenceXValueFor(_ indexPath: IndexPath) -> String {
    var index = 0
    for character in self.columnSequence {
      if (index == indexPath.section - 2) {
        return String(character)
      }
      index = index + 1
    }
    return ""
  }

  public func nextCellGridViewModel() -> SLGridCellViewModel? {
    // If the grid is already full
    if grid[grid.count-1].count == alignmentSolver.grid[alignmentSolver.grid.count-1].count {
      return nil
    }
    if currentState == .align || (currentState == .setup && grid[grid.count-1].count != 1) {
      return nil
    }
    var section = infocusIndexPath.section
    var row = infocusIndexPath.row
    if (currentState == .setup) {
      section = 1
      row = 1
    }
    else if (grid[section].count == alignmentSolver.grid[section].count) {
      section = section + 1
      row = 1
    }
    else {
      row  = row + 1
    }
    return gridCellViewModelForIndexPath(IndexPath(row: row, section: section))
  }

  public func prepare() {
    alignmentSolver.solve(match: match, mismatch: mismatch, indel: indel)
    alignmentGrid = alignmentSolver.findAlignment(match: match, mismatch: mismatch, indel: indel)
    alignmentIndex = 0

    for _ in 0...columnSequence.count+1 {
      sequenceGrid.append([SLGridCellViewModel]())
    }

    sequenceGrid[0].append(settingsCellViewModel())
    sequenceGrid[0].append(decoratorCellViewModelForValue("x", indexPath: IndexPath(row: 1, section: 0)))
    sequenceGrid[1].append(decoratorCellViewModelForValue("y", indexPath: IndexPath(row: 0, section: 1)))

    var row = 2
    for character in rowSequence {
      sequenceGrid[0].append(decoratorCellViewModelForValue(String(character), indexPath: IndexPath(row: row, section: 0)))
      row = row + 1
    }
    var section = 2
    for character in columnSequence {
      sequenceGrid[section].append(decoratorCellViewModelForValue(String(character), indexPath: IndexPath(row: 0, section: section)))
      section = section + 1
    }

    for _ in 0..<alignmentSolver.grid.count {
      grid.append([SLGridCellViewModel]())
    }

  }

  private func settingsCellViewModel() -> SLSettingsCellViewModel {
    let editImage = UIImage(named: "edit")!
    let removeImage = UIImage(named: "remote_control")!
    let cellViewModel = SLSettingsCellViewModel(editImage, removeImage, UIColor(red: 134.0/255, green: 144.0/255, blue: 252.0/255, alpha: 1))
    return cellViewModel
  }

  private func decoratorCellViewModelForValue(_ value: String, indexPath: IndexPath) -> SLGridCellViewModel {
    let cellViewModel = SLGridCellViewModel()
    cellViewModel.section = indexPath.section + 1
    cellViewModel.row = indexPath.row + 1
    cellViewModel.value = value
    cellViewModel.backgroundColor = UIColor(red: 134.0/255, green: 144.0/255, blue: 252.0/255, alpha: 1)
    cellViewModel.textColor = UIColor.white
    cellViewModel.highlightedTextColor = .red
    return cellViewModel
  }

  private func gridCellViewModelForIndexPath(_ indexPath: IndexPath) -> SLGridCellViewModel {
    let cellViewModel = SLGridCellViewModel()
    cellViewModel.section = indexPath.section + 1
    cellViewModel.row = indexPath.row + 1
    cellViewModel.value = String(alignmentSolver.grid[indexPath.section][indexPath.row])
    cellViewModel.backgroundColor = UIColor(red: 160.0/255, green: 168.0/255, blue: 251.0/255, alpha: 0.7)
    cellViewModel.textColor = .white
    cellViewModel.highlightedTextColor = .red
    return cellViewModel
  }

  private func gridCellViewModelForValue(_ value: String) -> SLGridCellViewModel {
    let cellViewModel = SLGridCellViewModel()
    cellViewModel.value = value
    cellViewModel.backgroundColor = UIColor(red: 160.0/255, green: 168.0/255, blue: 251.0/255, alpha: 0.7)
    cellViewModel.textColor = .white
    cellViewModel.highlightedTextColor = .red
    return cellViewModel
  }

  private func nextState() {
    var section = infocusIndexPath.section
    var row = infocusIndexPath.row
    if (currentState == .setup) {
      if (section == 0) {
        if (grid[0].count == 0) {
          row = 0
        }
          // If we are in first row and its not full yet
        else if (grid[0].count != alignmentSolver.grid[0].count) {
          row = row + 1
        }
        else {
          // First row just got full. Move to next row.
          section = section + 1
          row = 0
        }
      }
      else {
        // We just filled the last row. Switch the state to .solve
        if (section == grid.count-1) {
          currentState = .solve
          section = 1
          row = 1
        }
        else {
          // Move to the next row.
          section = section + 1
          row = 0
        }
      }
    }
    else if (currentState == .solve) {
      if (section == grid.count-1 && grid[section].count == alignmentSolver.grid[section].count) {
        // We just filled the last column of last row.
        // Switch state.
        currentState = .align
        alignmentIndex = 0
      }
      else {
        // We filled out a row. Move to next row.
        if (grid[section].count == alignmentSolver.grid[section].count) {
          section = section + 1
          row = 1
        }
        else {
          row  = row + 1
        }
      }
    }
    else {
      // We are in alignment mode.
      // If are not done showing the entire alignment
      if (alignmentIndex < alignmentGrid.count-1) {
        alignmentIndex = alignmentIndex + 1;
      }
    }
    infocusIndexPath = IndexPath(row: row, section: section)
  }

  private func arrowDirectionForCellAtIndexPath(_ indexPath: IndexPath) -> ArrowDirectin {
    let affectingModels = cellModelsAffectingGridAtIndexPath(indexPath)

    let horizontal = Int(affectingModels[0].value)! + indel
    let verticle = Int(affectingModels[1].value)! + indel
    var diagonal = Int(affectingModels[2].value)!
    if (sequenceYValueFor(indexPath) == sequenceXValueFor(indexPath)) {
      diagonal = diagonal + match
    }
    else {
      diagonal = diagonal + mismatch
    }
    let ans = max(diagonal, max(horizontal, verticle))

    if (ans == diagonal) {
      return .Diagonal
    }
    else if (ans == verticle) {
      return .Vertcle
    }
    else {
      // Horizontal
      return .Horizontal
    }
  }

  public func next(_ callback: Bool = true) {
    nextState()
    if (currentState == .solve &&
      infocusIndexPath.section == grid.count-1 &&
      infocusIndexPath.row == grid[grid.count-1].count - 1) {
      currentState = .align;
    }
    if (currentState == .solve || currentState == .setup) {
      let cellViewModel = gridCellViewModelForIndexPath(infocusIndexPath)
      if (currentState == .solve) {
        if let previous = lastGridViewModel {
          previous.arrow = .None
        }
        cellViewModel.arrow = arrowDirectionForCellAtIndexPath(IndexPath(row: infocusIndexPath.row+1, section: infocusIndexPath.section+1))
        lastGridViewModel = cellViewModel
      }
      grid[infocusIndexPath.section].append(cellViewModel)
      if (callback == true) {
        deleate?.insert(gridCell: cellViewModel)
      }
    }
    else {
      if let previous = lastGridViewModel {
        previous.arrow = .None
      }
      let cellViewModel = grid[alignmentGrid[alignmentIndex][0]][alignmentGrid[alignmentIndex][1]]
      cellViewModel.highlight = true
      if (callback == true) {
        deleate?.update(gridCell: cellViewModel, alignmentIndex: alignmentIndex)
      }
    }
  }

  public func previous() {
    if (currentState == .align) {
      let cellViewModel = grid[alignmentGrid[alignmentIndex][0]][alignmentGrid[alignmentIndex][1]]
      cellViewModel.highlight = false
      deleate?.update(gridCell: cellViewModel, alignmentIndex: alignmentIndex-1)
    }
    else if (currentState == .solve || currentState == .setup) {
      if (grid[0].count == 0) {return}
      let cellViewModel = grid[infocusIndexPath.section][grid[infocusIndexPath.section].count - 1];
      grid[infocusIndexPath.section].remove(at: grid[infocusIndexPath.section].count - 1)
      deleate?.remove(gridCell: cellViewModel)
    }
    previousState();
  }

  public func solveAlignment() {
    while(currentState != .align) {
      next(false)
    }
    while(alignmentIndex < alignmentGrid.count-1) {
      next(true)
    }
    self.deleate?.refresh()
  }

  public func resetToSolve() {
    while(currentState != .setup) {
      previous()
    }
    self.deleate?.refresh()
  }

  private func previousState() {
    if (currentState == .align) {
      if (alignmentIndex == 0) {
        // We have removed the last highlighted cell.
        // State changes to solve.
        currentState = .solve
        infocusIndexPath = IndexPath(row: grid[grid.count-1].count - 1, section: grid.count-1)
      }
      else {
        alignmentIndex = alignmentIndex - 1;
      }
    }
    else if (currentState == .solve) {
      if (grid[infocusIndexPath.section].count == 1) {
        if (infocusIndexPath.section == 1) {
          currentState = .setup
          infocusIndexPath = IndexPath(item: 0, section: grid.count - 1)
        }
        else {
          infocusIndexPath = IndexPath(item: grid[infocusIndexPath.section - 1].count-1, section: infocusIndexPath.section - 1)
        }
      }
      else {
        infocusIndexPath = IndexPath(item: infocusIndexPath.row - 1, section: infocusIndexPath.section)
      }
    }
    else if (currentState == .setup) {
      if (infocusIndexPath.section == 0 && infocusIndexPath.row == 0) {
        return
      }
      else if (infocusIndexPath.section == 1) {
        infocusIndexPath = IndexPath(item: grid[0].count - 1, section: 0)
      }
      else if (infocusIndexPath.section == 0) {
        infocusIndexPath = IndexPath(item: infocusIndexPath.row - 1, section: 0)
      }
      else {
        infocusIndexPath = IndexPath(item: 0, section: infocusIndexPath.section - 1)
      }
    }
  }

}

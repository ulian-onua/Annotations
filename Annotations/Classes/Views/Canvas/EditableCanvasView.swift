//
//  EditableCanvasView.swift
//  Zappy Arrow Annotation
//
//  Created by Mirko on 1/6/19.
//  Copyright © 2019 Blackbelt Labs. All rights reserved.
//

import Foundation
import TextAnnotation

public protocol EditableCanvasView: CanvasView {
  var isUserInteractionEnabled: Bool { get set }
  var createMode: CanvasItemType { get set }
  var isChanged: Bool { get set }
  var selectedKnob: KnobView? { get set }
  var lastDraggedPoint: PointModel? { get set }
  var selectedItem: CanvasDrawable? { get set }
  var createColor: ModelColor { get set }
  
  var selectedTextAnnotation: TextAnnotation? { get set }
  var isSelectedTextAnnotation: Bool { get }
  func deselectTextAnnotation()
  
  func delete(item: CanvasDrawable) -> CanvasModel
  func createItem(mouseDown: PointModel, color: ModelColor) -> CanvasDrawable?
  func createItem(dragFrom: PointModel, to: PointModel, color: ModelColor) -> (CanvasDrawable?, KnobView?)
  func updateSelectedItemColor(_ color: ModelColor)
}

extension EditableCanvasView {
  func didUpdate(selectedItem: CanvasDrawable?, oldValue: CanvasDrawable?) {
    oldValue?.isSelected = false
  }
  
  public func deleteSelectedItem() {
    if let selectedItem = selectedItem {
      let newModel = delete(item: selectedItem)
      update(model: newModel)
      delegate?.canvasView(self, didUpdateModel: newModel)
      return
    }
    
    if let selectedTextAnnotation = selectedTextAnnotation {
      selectedTextAnnotation.delete()
      self.selectedTextAnnotation = nil
    }
  }
  
  public func deselectSelectedItem() {
    selectedItem = nil
    selectedTextAnnotation?.deselect()
    selectedTextAnnotation = nil
  }
  
  func itemAt(point: PointModel) -> CanvasDrawable? {
    return items.first(where: { (item) -> Bool in
      return item.contains(point: point)
    })
  }
  
  func mouseDown(_ location: PointModel) -> Bool {
    guard isUserInteractionEnabled else {
      return false
    }
    
    lastDraggedPoint = location
    
    if let knob = selectedItem?.knobAt(point: location) {
      selectedKnob = knob
      return true
    }
    
    if let item = itemAt(point: location) {
      selectedItem = item
      item.isSelected = true
      
      return true
    }
    
    if selectedItem == nil, selectedTextAnnotation == nil, let newItem = createItem(mouseDown: location, color: createColor) {
      
      add(newItem)
      newItem.doInitialSetupOnCanvas()
      
      return true
    }
    
    selectedItem = nil

    return false
  }
  
  func mouseDragged(_ location: PointModel) {

    guard isUserInteractionEnabled else {
      return
    }
    
    // should check if not nil here otherwise crash can occur
    guard let lastDragPoint = self.lastDraggedPoint else { return }
    
    let lastDraggedPoint = lastDragPoint
    
    // create new item
    if selectedItem == nil {
      let (newItem, newKnob) = createItem(dragFrom: lastDraggedPoint, to: location, color: createColor)
      
      if let item = newItem {
        add(item)
        selectedItem = item
        selectedKnob = newKnob
        isChanged = true
        self.lastDraggedPoint = location
      }
      
      return
    }
    
    guard let selectedItem = selectedItem else {
      return
    }
    
    if let selectedKnob = self.selectedKnob {
      selectedItem.draggedKnob(selectedKnob, from: lastDraggedPoint, to: location)
    } else {
      selectedItem.dragged(from: lastDraggedPoint, to: location)
    }
    
    isChanged = true
    self.lastDraggedPoint = location
  }
  
  func mouseUp(_ location: PointModel) {

    guard isUserInteractionEnabled else {
      return
    }
    
    selectedKnob = nil
    
    if let selectedItem = selectedItem {
      selectedItem.isSelected = true
    }
    
    if isChanged {
      delegate?.canvasView(self, didUpdateModel: model)
      isChanged = false
    }
    
    lastDraggedPoint = nil
  }
}

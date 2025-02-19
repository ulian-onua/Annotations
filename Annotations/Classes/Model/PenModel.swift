//
//  PenModel.swift
//  Zappy Arrow Annotation
//
//  Created by Mirko on 1/6/19.
//  Copyright © 2019 Blackbelt Labs. All rights reserved.
//

import Foundation

public struct PenModel: Model {
  public var points: [PointModel]
  public let color: ModelColor
  
  func copyWithColor(color: ModelColor) -> PenModel {
    return PenModel(points: points, color: color)
  }
}

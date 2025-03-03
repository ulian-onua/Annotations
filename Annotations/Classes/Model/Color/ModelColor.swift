
import Foundation

// convenient data type to not bind to NSColor or UIColor so the lib will be ready for both Mac OS and iOS (if need to be used on iOS in the future)

public struct ModelColor: Codable, Equatable {
  public let red: CGFloat
  public let green: CGFloat
  public let blue: CGFloat
  public let alpha: CGFloat
  
  // MARK: - Convenient properties to get common used colors
  
  public static let orange: ModelColor = {
    return ModelColor.colorFromRelative(red: 255.0, green: 74.0, blue: 1.0)
  }()
  
  public static let yellow: ModelColor = {
    return ModelColor.colorFromRelative(red: 255.0, green: 196.0, blue: 62.0)
  }()
  
  public static let green: ModelColor = {
    return ModelColor.colorFromRelative(red: 19.0, green: 208.0, blue: 171.0)
  }()
  
  public static let fuschia: ModelColor = {
    return ModelColor.colorFromRelative(red: 252.0, green: 28.0, blue: 116.0)
  }()
  
  public static let violet: ModelColor = {
    return ModelColor.colorFromRelative(red: 96.0, green: 97.0, blue: 237.0)
  }()
  
  // MARK: - Default colors
  
  public static func defaultColor() -> ModelColor {
    return orange
  }
  
  public static func defaultColors() -> [ModelColor] {
    return [orange, yellow, green, fuschia, violet]
  }
  
  // MARK: - Helpers

  public static func colorFromRelative(red: CGFloat,
                                       green: CGFloat,
                                       blue: CGFloat,
                                       alpha: CGFloat = 1.0) -> ModelColor {
    return ModelColor(red: red / 255.0,
                      green: green / 255.0,
                      blue: blue / 255.0,
                      alpha: alpha)
  }
  
}

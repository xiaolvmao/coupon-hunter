import SwiftUI

// MARK: - 优惠券分类
enum CouponCategory: String, CaseIterable, Codable, Identifiable {
    case foodDelivery = "外卖"
    case shopping = "购物"
    case dining = "美食"
    case ride = "打车"
    case coffee = "咖啡茶饮"
    case entertainment = "娱乐"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .foodDelivery: return "🛵"
        case .shopping: return "🛍️"
        case .dining: return "🍜"
        case .ride: return "🚗"
        case .coffee: return "☕️"
        case .entertainment: return "🎬"
        }
    }
}

// MARK: - 平台
struct Platform: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: CouponCategory
    let emoji: String
    let colorHex: String
    let schemes: [String]       // 用于尝试拉起官方 App 的 URL Scheme
    let webCouponURL: String    // 官方领券/活动页（未安装 App 时的兜底）
    let slogan: String
}

// MARK: - 优惠券
struct Coupon: Identifiable, Codable, Hashable {
    let id: String
    let platformID: String
    let title: String
    let detail: String
    let amount: String          // 例如 "¥20"
    let condition: String       // 例如 "满45可用"
    let tag: String             // 例如 "新用户专享"
    let validText: String       // 例如 "领取后7天内有效"
    let code: String?           // 口令/兑换码（可为空）
    let linkURL: String         // 领券落地页
}

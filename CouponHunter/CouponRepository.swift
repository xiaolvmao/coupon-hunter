import SwiftUI
import Combine

/// 本地数据仓库：加载内置 JSON 数据 + 管理收藏
final class CouponRepository: ObservableObject {
    @Published var platforms: [Platform] = []
    @Published var coupons: [Coupon] = []
    @Published var favoriteIDs: Set<String> = [] {
        didSet { persistFavorites() }
    }

    private let favoritesKey = "favorite.coupons.v1"

    init() {
        load()
        loadFavorites()
    }

    // MARK: 数据加载
    private func load() {
        platforms = Self.decode([Platform].self, from: "platforms") ?? []
        coupons = Self.decode([Coupon].self, from: "coupons") ?? []
    }

    private static func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // MARK: 查询
    func coupons(for platform: Platform) -> [Coupon] {
        coupons.filter { $0.platformID == platform.id }
    }

    func platform(of coupon: Coupon) -> Platform? {
        platforms.first { $0.id == coupon.platformID }
    }

    func search(_ text: String) -> [Coupon] {
        let q = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return [] }
        return coupons.filter { coupon in
            let hitCoupon = coupon.title.localizedCaseInsensitiveContains(q)
                || coupon.detail.localizedCaseInsensitiveContains(q)
                || coupon.tag.localizedCaseInsensitiveContains(q)
            let hitPlatform = platform(of: coupon)?.name.localizedCaseInsensitiveContains(q) ?? false
            return hitCoupon || hitPlatform
        }
    }

    /// 热门推荐：优先展示爆款/限时/新用户券
    var hotCoupons: [Coupon] {
        let priority = ["爆款", "限时", "新用户专享", "每日", "会员专享"]
        return coupons
            .sorted { a, b in
                let ia = priority.firstIndex(where: { a.tag.contains($0) }) ?? Int.max
                let ib = priority.firstIndex(where: { b.tag.contains($0) }) ?? Int.max
                return ia < ib
            }
            .prefix(10)
            .map { $0 }
    }

    // MARK: 收藏
    var favorites: [Coupon] {
        coupons.filter { favoriteIDs.contains($0.id) }
    }

    func isFavorite(_ coupon: Coupon) -> Bool {
        favoriteIDs.contains(coupon.id)
    }

    func toggleFavorite(_ coupon: Coupon) {
        if favoriteIDs.contains(coupon.id) {
            favoriteIDs.remove(coupon.id)
        } else {
            favoriteIDs.insert(coupon.id)
        }
    }

    // MARK: 收藏持久化
    private func persistFavorites() {
        if let data = try? JSONEncoder().encode(favoriteIDs) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let set = try? JSONDecoder().decode(Set<String>.self, from: data) else { return }
        favoriteIDs = set
    }
}

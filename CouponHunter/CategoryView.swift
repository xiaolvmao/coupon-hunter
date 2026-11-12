import SwiftUI

/// 分类 Tab：按分类分组的全部平台
struct CategoryView: View {
    @EnvironmentObject var store: CouponRepository

    var body: some View {
        NavigationStack {
            List {
                ForEach(CouponCategory.allCases) { cat in
                    Section("\(cat.rawValue) \(cat.icon)") {
                        ForEach(store.platforms.filter { $0.category == cat }) { platform in
                            NavigationLink {
                                CouponListView(platform: platform)
                            } label: {
                                HStack(spacing: 12) {
                                    PlatformIconView(platform: platform, size: 38)
                                    Text(platform.name)
                                    Spacer()
                                    Text(platform.slogan)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("分类")
        }
    }
}

/// 单个分类的平台列表（首页分类入口跳转）
struct CategoryDetailView: View {
    let category: CouponCategory
    @EnvironmentObject var store: CouponRepository

    var body: some View {
        List {
            ForEach(store.platforms.filter { $0.category == category }) { platform in
                NavigationLink {
                    CouponListView(platform: platform)
                } label: {
                    HStack(spacing: 12) {
                        PlatformIconView(platform: platform, size: 38)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(platform.name)
                                .font(.subheadline.bold())
                            Text(platform.slogan)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.rawValue)
    }
}

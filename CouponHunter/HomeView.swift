import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: CouponRepository
    @State private var query = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    banner
                    searchField

                    if query.isEmpty {
                        categoryRow
                        hotSection
                        platformSection
                    } else {
                        searchResults
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("领券助手")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: 顶部横幅
    private var banner: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [Color.couponRedLight, Color.couponRed, Color(hex: "#B7110A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 6) {
                Text("天天领券 · 立省真金白银 💰")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text("外卖 / 购物 / 美食 / 打车 / 咖啡 优惠一站聚合")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.couponRed.opacity(0.3), radius: 8, y: 4)
    }

    // MARK: 搜索框
    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("搜索平台或优惠券，如：京东 / 打车券", text: $query)
                .autocorrectionDisabled()
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(11)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(Capsule())
    }

    // MARK: 分类入口
    private var categoryRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(CouponCategory.allCases) { cat in
                    NavigationLink {
                        CategoryDetailView(category: cat)
                    } label: {
                        VStack(spacing: 6) {
                            Text(cat.icon)
                                .font(.title2)
                            Text(cat.rawValue)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .frame(width: 68, height: 68)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: 热门推荐
    private var hotSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🔥 热门推荐")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.hotCoupons) { coupon in
                        CouponCardView(coupon: coupon)
                    }
                }
            }
        }
    }

    // MARK: 全部平台
    private var platformSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("全部平台")
                .font(.headline)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 78), spacing: 12)],
                spacing: 12
            ) {
                ForEach(store.platforms) { platform in
                    NavigationLink {
                        CouponListView(platform: platform)
                    } label: {
                        VStack(spacing: 6) {
                            PlatformIconView(platform: platform)
                            Text(platform.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: 搜索结果
    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 10) {
            let results = store.search(query)
            Text(results.isEmpty ? "没有找到相关优惠券" : "找到 \(results.count) 张相关优惠券")
                .font(.headline)
            ForEach(results) { coupon in
                NavigationLink {
                    CouponDetailView(coupon: coupon)
                } label: {
                    CouponRowView(coupon: coupon)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

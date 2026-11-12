import SwiftUI

/// 收藏 Tab
struct FavoritesView: View {
    @EnvironmentObject var store: CouponRepository

    var body: some View {
        NavigationStack {
            Group {
                if store.favorites.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(store.favorites) { coupon in
                                NavigationLink {
                                    CouponDetailView(coupon: coupon)
                                } label: {
                                    CouponRowView(coupon: coupon)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("我的收藏")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("🧾")
                .font(.system(size: 56))
            Text("还没有收藏的优惠券")
                .font(.headline)
            Text("在首页或平台页点击 ❤️ 即可收藏常用券")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

/// 我的 Tab
struct ProfileView: View {
    @EnvironmentObject var store: CouponRepository

    var body: some View {
        NavigationStack {
            Form {
                Section("概览") {
                    LabeledContent("已收藏优惠券", value: "\(store.favorites.count) 张")
                    LabeledContent("接入平台", value: "\(store.platforms.count) 个")
                    LabeledContent("版本", value: "1.0.0")
                }
                Section("使用说明") {
                    Text("点击「领取」会优先尝试跳转对应官方 App；未安装时自动打开官方领券网页。")
                    Text("在「分类」页可按外卖 / 购物 / 美食 / 打车等分类查找平台。")
                    Text("优惠券可在详情页或列表页点击 ❤️ 收藏。")
                }
                Section("免责声明") {
                    Text("本应用仅为优惠券信息聚合与跳转工具，不代销、不代购、不参与任何资金交易。所有优惠活动均以各官方平台实际页面为准，请在官方渠道完成领取和使用。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Section {
                    Button("清空收藏", role: .destructive) {
                        store.favoriteIDs = []
                    }
                }
            }
            .navigationTitle("我的")
        }
    }
}

import SwiftUI

/// 平台优惠券列表页
struct CouponListView: View {
    let platform: Platform
    @EnvironmentObject var store: CouponRepository

    private var coupons: [Coupon] { store.coupons(for: platform) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header
                ForEach(coupons) { coupon in
                    NavigationLink {
                        CouponDetailView(coupon: coupon)
                    } label: {
                        CouponRowView(coupon: coupon)
                    }
                    .buttonStyle(.plain)
                }
                if coupons.isEmpty {
                    Text("暂无优惠券数据，可点击下方按钮前往官方领券页")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 12)
                }
                openOfficialButton
                disclaimer
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(platform.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack(spacing: 12) {
            PlatformIconView(platform: platform, size: 52)
            VStack(alignment: .leading, spacing: 4) {
                Text(platform.name)
                    .font(.title3.bold())
                Text(platform.slogan)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(platform.category.icon)
                .font(.title)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var openOfficialButton: some View {
        Button {
            DeepLinkOpener.open(platform: platform, coupon: nil)
        } label: {
            Label("前往 \(platform.name) 官方领券中心", systemImage: "arrow.up.forward.app")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color.couponRed.opacity(0.1))
                .foregroundColor(.couponRed)
                .clipShape(Capsule())
        }
    }

    private var disclaimer: some View {
        Text("优惠券信息仅供参考，请以官方平台实际活动为准。")
            .font(.caption2)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// 优惠券详情页
struct CouponDetailView: View {
    @EnvironmentObject var store: CouponRepository
    let coupon: Coupon

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                couponCard
                if let code = coupon.code {
                    codeRow(code)
                }
                steps
                ClaimButton(coupon: coupon)
                favoriteToggle
                disclaimer
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("券详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var platform: Platform? { store.platform(of: coupon) }

    // MARK: 大券面
    private var couponCard: some View {
        VStack(spacing: 10) {
            if let p = platform {
                HStack(spacing: 8) {
                    PlatformIconView(platform: p, size: 30)
                    Text(p.name)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }
            }
            Text(coupon.amount)
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(.white)
            Text(coupon.condition)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            TagChip(text: coupon.tag)
                .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .background(
            LinearGradient(
                colors: [Color.couponRedLight, Color.couponRed],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.couponRed.opacity(0.3), radius: 8, y: 4)
        .padding(.horizontal, 4)
    }

    // MARK: 口令
    private var codeRow: some View {
        HStack {
            Text("口令：\(coupon.code ?? "")")
                .font(.subheadline.monospaced())
            Spacer()
            Button {
                UIPasteboard.general.string = coupon.code
            } label: {
                Label("复制", systemImage: "doc.on.doc")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: 领取步骤
    private var steps: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("领取步骤")
                .font(.headline)
            stepRow(1, "点击下方「立即领取」，优先跳转官方 App")
            stepRow(2, "未安装 App 时自动打开官方领券网页")
            stepRow(3, "在官方页面登录并领取，下单时自动抵扣")
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func stepRow(_ index: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(index)")
                .font(.caption.bold())
                .frame(width: 20, height: 20)
                .background(Circle().fill(Color.couponRed))
                .foregroundColor(.white)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }

    private var favoriteToggle: some View {
        Button {
            store.toggleFavorite(coupon)
        } label: {
            Label(
                store.isFavorite(coupon) ? "已收藏" : "收藏这张券",
                systemImage: store.isFavorite(coupon) ? "heart.fill" : "heart"
            )
            .font(.subheadline)
        }
        .buttonStyle(.bordered)
    }

    private var disclaimer: some View {
        Text("优惠券信息仅供参考，请以官方平台实际活动为准。")
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

import SwiftUI

// MARK: - 颜色工具
extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)
        if s.count == 6 {
            self.init(
                red: Double((value >> 16) & 0xFF) / 255,
                green: Double((value >> 8) & 0xFF) / 255,
                blue: Double(value & 0xFF) / 255
            )
        } else {
            self.init(red: 0.88, green: 0.15, blue: 0.11)
        }
    }

    static var couponRed: Color { Color(hex: "#E1251B") }
    static var couponRedLight: Color { Color(hex: "#FF4D3A") }
}

// MARK: - 平台图标
struct PlatformIconView: View {
    let platform: Platform
    var size: CGFloat = 48

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.28)
            .fill(Color(hex: platform.colorHex).opacity(0.16))
            .frame(width: size, height: size)
            .overlay(
                Text(platform.emoji)
                    .font(.system(size: size * 0.52))
            )
    }
}

// MARK: - 标签
struct TagChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Capsule().fill(Color.couponRed.opacity(0.12)))
            .foregroundColor(.couponRed)
    }
}

// MARK: - 优惠券行（列表用）
struct CouponRowView: View {
    @EnvironmentObject var store: CouponRepository
    let coupon: Coupon

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(coupon.amount)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text(coupon.condition)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .frame(width: 92, height: 88)
            .background(
                LinearGradient(
                    colors: [Color.couponRedLight, Color.couponRed],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(coupon.title)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Spacer()
                    Button {
                        store.toggleFavorite(coupon)
                    } label: {
                        Image(systemName: store.isFavorite(coupon) ? "heart.fill" : "heart")
                            .foregroundColor(store.isFavorite(coupon) ? .couponRed : .gray)
                    }
                    .buttonStyle(.plain)
                }
                Text(coupon.detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack {
                    TagChip(text: coupon.tag)
                    Spacer()
                    Text(coupon.validText)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 10)
            .frame(maxHeight: 88)
            .background(Color(.secondarySystemGroupedBackground))
        }
        .frame(height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

// MARK: - 优惠券卡片（首页热门横滑用）
struct CouponCardView: View {
    @EnvironmentObject var store: CouponRepository
    let coupon: Coupon

    var body: some View {
        NavigationLink {
            CouponDetailView(coupon: coupon)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                if let p = store.platform(of: coupon) {
                    HStack(spacing: 6) {
                        PlatformIconView(platform: p, size: 26)
                        Text(p.name)
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                    }
                }
                Text(coupon.amount)
                    .font(.title.bold())
                    .foregroundColor(.couponRed)
                Text(coupon.condition)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                TagChip(text: coupon.tag)
                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(width: 150, height: 160, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 领取按钮
struct ClaimButton: View {
    @EnvironmentObject var store: CouponRepository
    let coupon: Coupon

    var body: some View {
        Button {
            if let p = store.platform(of: coupon) {
                ClaimAction.claim(coupon: coupon, platform: p)
            }
        } label: {
            Text(coupon.code != nil ? "复制口令并领取" : "立即领取")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    LinearGradient(
                        colors: [Color.couponRedLight, Color.couponRed],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

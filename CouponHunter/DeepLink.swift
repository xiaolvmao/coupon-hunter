import UIKit
import SwiftUI

/// 跳转逻辑：优先拉起官方 App，未安装时打开官方领券网页
enum DeepLinkOpener {
    static func open(platform: Platform, coupon: Coupon?) {
        for scheme in platform.schemes {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
        let link = coupon?.linkURL ?? platform.webCouponURL
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

/// 领取动作：如有口令先复制，再跳转
enum ClaimAction {
    static func claim(coupon: Coupon, platform: Platform) {
        if let code = coupon.code {
            UIPasteboard.general.string = code
        }
        DeepLinkOpener.open(platform: platform, coupon: coupon)
    }
}

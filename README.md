# 领券助手（CouponHunter）iOS App

一个聚合各平台优惠券入口的 iOS 应用（SwiftUI），覆盖**外卖、购物、美食、咖啡茶饮、打车、娱乐**六大类平台，共 15 个主流平台、22 张示例优惠券。

## 功能

- **首页**：热门推荐横滑卡片、分类快捷入口、全部平台宫格、实时搜索
- **分类**：按外卖 / 购物 / 美食 / 打车等分类浏览平台
- **优惠券列表 / 详情**：券面展示、领取步骤、一键领取、复制口令
- **收藏**：收藏常用券（本地持久化，重启不丢失）
- **智能跳转**：点击"领取"优先拉起官方 App（URL Scheme），未安装时自动打开官方领券网页
- **免责声明**：内置说明本应用仅为信息聚合与跳转工具

## 平台清单

| 分类 | 平台 |
|------|------|
| 外卖 | 美团外卖、饿了么 |
| 购物 | 淘宝、天猫、京东、拼多多、唯品会 |
| 美食 | 大众点评、肯德基、麦当劳 |
| 咖啡茶饮 | 星巴克、瑞幸咖啡 |
| 打车 | 滴滴出行、高德打车 |
| 娱乐 | 猫眼电影 |

## 如何编译运行

1. 环境要求：**Xcode 16+**（使用了 fileSystemSynchronizedGroups 新工程格式），iOS 16.0+
2. 双击打开 `CouponHunter.xcodeproj`
3. 选择一个 iOS 模拟器（如 iPhone 16），按 `⌘R` 运行
4. 真机调试：在 Xcode → Signing & Capabilities 中登录你的 Apple ID 选择 Team（免费个人账号即可真机调试）

## 如何接入真实优惠券

当前数据为内置示例（`CouponHunter/Resources/platforms.json` 与 `coupons.json`），接入真实优惠只需修改这两个 JSON，无需改代码：

- **京东**：接入 [京东联盟](https://union.jd.com) 获取真实领券链接（union.jd.com 提供优惠券 API 与推广链接）
- **淘宝/天猫**：接入淘宝联盟（淘宝客）获取推广券链接
- **拼多多**：接入 [多多进宝](https://jinbao.pinduoduo.com) API
- **美团**：接入美团联盟获取外卖红包推广链接
- **肯德基/麦当劳等**：使用其官方 App / 小程序的领券页链接

把这些联盟返回的领券 URL 填入 `coupons.json` 的 `linkURL` 字段（或 `platforms.json` 的 `webCouponURL`）即可。若后续需要动态更新，可将 JSON 换成远程接口（如在自己的服务器上提供同结构的 JSON）。

## 项目结构

```
CouponHunter/
├── CouponHunter.xcodeproj/
├── CouponHunter/
│   ├── CouponHunterApp.swift   # App 入口 + TabView
│   ├── Models.swift            # Platform / Coupon / CouponCategory
│   ├── CouponRepository.swift  # 数据仓库（加载 JSON + 收藏持久化）
│   ├── DeepLink.swift          # 拉起官方 App / 打开领券页
│   ├── Components.swift        # 券面卡片、行视图、领取按钮等
│   ├── HomeView.swift          # 首页
│   ├── CategoryView.swift      # 分类
│   ├── CouponViews.swift       # 优惠券列表页 / 详情页
│   ├── FavoritesAndProfile.swift # 收藏页 / 我的
│   ├── Info.plist              # 含 LSApplicationQueriesSchemes 白名单
│   └── Resources/
│       ├── platforms.json      # 平台数据（可自行增删平台）
│       └── coupons.json        # 优惠券数据（可替换为联盟真实链接）
└── README.md
```

## 如何编译成 ipa

### 方式一：GitHub Actions 云编译（免费、无需 Mac）✅ 推荐

工程已内置 `.github/workflows/build-ipa.yml`：

1. 把整个项目推送到 GitHub 仓库（`.github/workflows/build-ipa.yml` 必须一起上传）
2. 打开仓库 → **Actions** 标签页 → 选择 **Build iOS IPA** → **Run workflow**
3. 运行完成后在该次运行页面底部的 **Artifacts** 下载 `CouponHunter-ipa`，解压得到 `CouponHunter.ipa`（未签名）
4. 未签名 ipa 可用 **Sideloadly / AltStore / 爱思助手** + Apple ID 签名后安装到真机

### 方式二：本地 Xcode 导出

```bash
xcodebuild -project CouponHunter.xcodeproj -target CouponHunter \
  -configuration Release -sdk iphoneos \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" \
  build CONFIGURATION_BUILD_DIR=build
mkdir -p build/Payload && cp -r build/CouponHunter.app build/Payload/
cd build && zip -r CouponHunter.ipa Payload
```

### 方式三：正式签名（App Store / TestFlight）

需要付费开发者账号（99 美元/年），在 Xcode 中配置证书后用 `xcodebuild archive` + Organizer 导出签名 ipa。

## 免责声明

本应用仅为优惠券信息聚合与跳转工具，不代销、不代购、不参与任何资金交易。所有优惠活动均以各官方平台实际页面为准。上架 App Store 前请确保使用的推广链接符合各平台的联盟推广协议。

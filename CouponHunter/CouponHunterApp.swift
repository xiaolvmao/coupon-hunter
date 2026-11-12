import SwiftUI

@main
struct CouponHunterApp: App {
    @StateObject private var store = CouponRepository()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(Color(hex: "#E1251B"))
        }
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("首页", systemImage: "house.fill") }
            CategoryView()
                .tabItem { Label("分类", systemImage: "square.grid.2x2.fill") }
            FavoritesView()
                .tabItem { Label("收藏", systemImage: "heart.fill") }
            ProfileView()
                .tabItem { Label("我的", systemImage: "person.fill") }
        }
    }
}

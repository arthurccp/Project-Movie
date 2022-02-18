import SwiftUI

struct SearchUserRow: View {
    @StateObject var viewModel: SearchUserViewModel
    @State var user: Result

    var body: some View {
        HStack {
            Text(user.originalTitle)
                .font(Font.system(size: 18).bold())
            Spacer()
            }
            .frame(height: 60)
    }
}

import SwiftUI

struct SearchUserRow: View {
    @ObservedObject var viewModel: SearchUserViewModel
    @State var user: Movie

    var body: some View {
        HStack {
            Text(user.title)
                .font(Font.system(size: 18).bold())
            Spacer()
            }
            .frame(height: 60)
    }
}

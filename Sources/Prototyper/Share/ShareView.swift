//
//  ShareView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 30.11.19.
//

import SwiftUI


// MARK: ShareView
///This View holds two textfields for the emailId and the invite text.
struct ShareView: View {
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    
    /// The State variable holds the emailId of the user to whom the invite needs to be sent to.
    @State var inviteList: String = ""
    /// The State variable holds the inviteText to the invitee.
    @State var inviteText: String = ""
    /// The State variable is updated if the logged in user clicks on Share
    @State var showSendInviteView: Bool = false
    /// The State variable that holds the ShareRequest object.
    @State var shareRequest: ShareRequest?
    /// Stores the old value set as a preference for `UITextView.appearance().backgroundColor` so we can show a placeholder behind the view
    @State var oldTextViewColor: UIColor?
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Send the invitation to test the app to:")
                    TextField("email@example.com", text: $inviteList)
                    Text("Invitation Text:")
                    ZStack(alignment: .topLeading) {
                        if inviteText.isEmpty {
                            Text("This is the content of the invitation...")
                                .foregroundColor(Color(.systemGray3))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $inviteText)
                            .onAppear {
                                oldTextViewColor = UITextView.appearance().backgroundColor
                                UITextView.appearance().backgroundColor = .clear
                            }
                            .onDisappear {
                                UITextView.appearance().backgroundColor = oldTextViewColor
                            }
                            .border(Color(.systemGray6), width: 1)
                    }
                    NavigationLink(destination: SendInviteView(showSendInviteView: $showSendInviteView,
                                                               shareRequest: $shareRequest),
                                   isActive: $showSendInviteView) {
                        Text("")
                    }.frame(height: 0)
                }
                Spacer()
            }.padding([.horizontal, .top], 20)
                .navigationBarTitle("Share App")
                .navigationBarItems(leading: cancelButton, trailing: shareButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Holds the inviteList and the inviteText to be sent
    private var currentShareRequest: ShareRequest {
        var creatorName: String?
        if !state.apiHandler.userIsLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return ShareRequest(email: inviteList,
                            content: inviteText,
                            creatorName: creatorName)
    }
    
    /// Set the color of the Button based on the correctness of the inviteList
    var buttonColor: Color {
        !inviteList.isValidEmail ? .gray : .blue
    }
    
    /// The cancel button displayed at the top left of the View
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    /// The share Button displayed at the top right of the View
    private var shareButton : some View {
        Button(action: share) {
            Text("Share").bold()
        }.disabled(!inviteList.isValidEmail)
    }
    
    
    /// Dismisses the view and make the Feedback bubble appear again.
    private func cancel() {
        Prototyper.dismissView()
        state.setFeedbackButtonIsHidden()
    }
    
    ///Shares the Invite to the emailId mentioned via the SendInviteView
    private func share() {
        shareRequest = currentShareRequest
        self.showSendInviteView = true
    }
}


// MARK: ShareView + Preview
struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}

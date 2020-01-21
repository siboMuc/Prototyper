//
//  ShareView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 30.11.19.
//

import SwiftUI

struct ShareView: View {
    @EnvironmentObject var model: Model
    @State var inviteList: String = ""
    @State var inviteText: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                VStack (alignment: .leading, spacing: 25) {
                    Text("Send the invitation to test the app to:")
                    TextField("email@example.com", text: $inviteList)
                    Text("Invitation Text:")
                    MultilineTextView(text: $inviteText, placeholderText: "This is the content of the invitation...").frame(numLines: 10)
                    NavigationLink(destination: LoginView(), isActive: $model.showLoginView) {
                        Text("")
                    }
                    NavigationLink(destination: SendInviteView(), isActive: $model.showSendInviteView) {
                        Text("")
                    }
                }
                Spacer()
            }.padding(20)
            .navigationBarTitle("Share App")
            .navigationBarItems(leading: cancelButton, trailing: shareButton)
        }
    }
    
    private var currentShareRequest: ShareRequest {
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return ShareRequest(email: inviteList,
                            content: inviteText,
                            creatorName: creatorName)
    }
    
    var buttonColor: Color {
        return !inviteList.isValidEmail ? .gray : .blue
    }
    
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    private var shareButton : some View {
        Button(action: share) {
            Text("Share").bold()
        }.disabled(!inviteList.isValidEmail)
    }
    
    private func cancel() {
        PrototyperController.dismissView()
        PrototyperController.isFeedbackButtonHidden = false
    }
    
    private func share() {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            print("Send screen")
            PrototyperController.currentShareRequest = currentShareRequest
            self.model.showSendInviteView = true
        } else {
            print("SignIn screen")
            PrototyperController.currentShareRequest = currentShareRequest
            self.model.showLoginView = true
        }
    }
    
    private func performSegueToSendInviteView() {
        print("performSegueToSendInviteView")
    }
}

struct Share_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}

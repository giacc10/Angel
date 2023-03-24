//
//  CreateUserView.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import SwiftUI
import RealmSwift
import RevenueCat
import ProgressHUD

struct CreateUserView: View {
    
    // MARK: - PROPERTIES
    @State private var name = ""
    @State private var email = ""
    @State private var repatedEmail = ""
    @ObservedResults(User.self) var users
    @ObservedResults(MeditationsStorage.self) var meditationsStorage
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text(String(localized: "Hello"))
                .customFont(size: 35)
            Text(String(localized: "Tell-Me-Something"))
                .fontWeight(.medium)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "What-Is-Your-Name?") + " *")
                        .textCase(.uppercase)
                        .padding(.leading)
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 10)
                        TextField(String(localized: "Insert-Name"), text: $name)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.primary).opacity(0.05))
                } //: VSTACK
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "What-Is-Your-Email?") + " *")
                        .textCase(.uppercase)
                        .padding(.leading)
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 10)
                        TextField(String(localized: "Insert-Email"), text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.primary).opacity(0.05))
                } //: VSTACK
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "Repeat-Your-Email") + " *")
                        .textCase(.uppercase)
                        .padding(.leading)
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 10)
                        TextField(String(localized: "Repeat-Email"), text: $repatedEmail)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.primary).opacity(0.05))
                    HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.primary)
                            .opacity(0.2)
                        Text(String(localized: "Insert-Valid-Email"))
                            .font(.footnote)
                            .fontWeight(.medium)
                    } //: HSTACK
                } //: VSTACK
                
                Spacer()
                Button {
                    
                    if name == "" {
                        ProgressHUD.showFailed(String(localized: "Please-Insert-Your-Name"))
                        return
                    }
                    
                    if email == "" {
                        ProgressHUD.showFailed(String(localized: "Please-Insert-Your-Email"))
                        return
                    }
                    
                    if email.trimWhiteSpace() != repatedEmail.trimWhiteSpace() {
                        ProgressHUD.showFailed(String(localized: "Please-Insert-Same-Email"))
                        return
                    }
                    
                    hideKeyboard()
                    let user = User()
                    user.name = name.trimWhiteSpace()
                    user.email = email.trimWhiteSpace()
                    $users.append(user)
                    
                    let meditationsStorage = MeditationsStorage()
                    $meditationsStorage.append(meditationsStorage)
                    
                    Purchases.shared.attribution.setDisplayName(user.name)
                    Purchases.shared.attribution.setEmail(user.email)
                    
                } label: {
                    Text(String(localized: "Create-Profile"))
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .foregroundColor(.primary)
                .colorInvert()
                .background(RoundedRectangle(cornerRadius: 50))
                
            } //: VSTACK
            .padding()
        } //: VSTACK
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}

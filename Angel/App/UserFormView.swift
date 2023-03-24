//
//  CreateUserView.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import SwiftUI
import RealmSwift
import RevenueCat
import DynamicColor
import ProgressHUD

struct UserFormView: View {
    
    // MARK: - PROPERTIES
    @ObservedResults(User.self) var users
    @ObservedResults(MeditationsStorage.self) var meditationsStorage

    @State private var name = ""
    @State private var email = ""
    @State private var repatedEmail = ""
    
    var color = "#7FB3D5"
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            ParticleView()
            VStack {
                VStack(alignment: .leading) {
                    Text(String(localized: "Hello-Create-Profile"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                    Text(String(localized: "Tell-Me-Something"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } //: VSTACK
                .padding(.horizontal)
                .padding(.top)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(String(localized: "What-Is-Your-Name?") + " *")
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .padding(.leading)
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .padding(.trailing, 10)
                            TextField(String(localized: "Insert-Name"), text: $name)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .multilineTextAlignment(.leading)
                        } //: HSTACK
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.primary).opacity(0.05))
                    } //: VSTACK
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(String(localized: "What-Is-Your-Email?") + " *")
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .padding(.leading)
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .padding(.trailing, 10)
                            TextField(String(localized: "Insert-Email"), text: $email)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        } //: HSTACK
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.primary).opacity(0.05))
                    } //: VSTACK
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(String(localized: "Repeat-Your-Email") + " *")
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .padding(.leading)
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .padding(.trailing, 10)
                            TextField(String(localized: "Repeat-Email"), text: $repatedEmail)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        } //: HSTACK
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.primary).opacity(0.05))
                        HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                .opacity(0.3)
                            Text(String(localized: "Insert-Valid-Email"))
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                        } //: HSTACK
                    } //: VSTACK
                    
                    Spacer()
                    ButtonCTA(text: String(localized: "Create-Profile"), color: "#7FB3D5") {
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
                    }
                    
                } //: VSTACK
                .padding()
            } //: VSTACK
        } //: ZSTACK
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(DynamicColor(hexString: color).lighter()),
                Color(DynamicColor(hexString: color).saturated(amount: 0.5))
            ]), startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
        )
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        UserFormView()
    }
}

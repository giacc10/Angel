//
//  CreateUserView.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import SwiftUI

struct CreateUserView: View {
    
    // MARK: - PROPERTIES
    @State private var name = ""
    @EnvironmentObject var appRealmManager: AppRealmManager
    
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
                }
                
                Spacer()
                Button {
                    
                    if name != "" {
                        hideKeyboard()
                        appRealmManager.createUser(name: name)
                    }
                    
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

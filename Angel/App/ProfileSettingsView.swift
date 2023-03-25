//
//  ProfileSettingsView.swift
//  Angel
//
//  Created by Thomas Giacinto on 25/03/23.
//

import SwiftUI
import RealmSwift

struct ProfileSettingsView: View {
    
    // MARK: - PROPERTIES
    @ObservedRealmObject var user: User
    @State var isPayWallPresented = false
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: -4) {
                Text(String(localized: "Coming-Soon"))
                    .font(.title)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                Text(String(localized: "For-Premium-User"))
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(String(localized: "CS-Daily-Notifications"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                    
                    Text(String(localized: "CS-Daily-Notifications-Caption"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text(String(localized: "CS-Meditation-Reminder"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                    
                    Text(String(localized: "CS-Meditation-Reminder-Caption" ))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text(String(localized: "CS-Custom-Font"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                    
                    Text(String(localized: "CS-Custom-Font-Caption"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text(String(localized: "CS-More-In-The-Making"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                    
                    Text(String(localized: "CS-More-In-The-Making-Caption"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
            )
            
            Spacer()
            
            if !user.isSubscriptionActive {
                Text(String(localized: "CS-Get-Prepared"))
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                ButtonCTA(text: String(localized: "Go-Premium"), color: "#7FB3D5") {
                    isPayWallPresented.toggle()
                }
                .sheet(isPresented: $isPayWallPresented) {
                    PayWallView(user: user, color: "#7FB3D5")
                }                
            }
            
            
        } //: VSTACK
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(String(localized: "Settings"))
                    //                            .customFont(size: 40)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
            }
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView(user: User())
    }
}

//
//  SettingsView.swift
//  cekilis
//
//  Created by Ezagor on 10.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkModeEnabled = false
    @State private var biometricAuthEnabled = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: PersonalDetailsView()) {
                        SettingsRow(iconName: "person.fill", title: "Kişisel Bilgiler")
                    }
                    NavigationLink(destination: FriendInvitesView()) {
                        SettingsRow(iconName: "envelope.fill", title: "Arkadaş Davetleri")
                    }
                    NavigationLink(destination: NotificationSettingsView()) {
                        SettingsRow(iconName: "bell.fill", title: "Bildirim Ayarları")
                    }
                    NavigationLink(destination: RateAppView()) {
                        SettingsRow(iconName: "hand.thumbsup.fill", title: "Uygulamayı Değerlendir")
                    }
                }
                
                Section {
                    Toggle(isOn: $darkModeEnabled) {
                        SettingsRow(iconName: "moon.fill", title: "Karanlık Mod")
                    }
                    Toggle(isOn: $biometricAuthEnabled) {
                        SettingsRow(iconName: "lock.fill", title: "Biyometrik Giriş")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Ayarlar")
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
           
        }
    }
}

struct SettingsRow: View {
    let iconName: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.black)
            Spacer()
            if iconName != "moon.fill" && iconName != "lock.fill" {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
        
    }
}

// Placeholder views for navigation links
struct PersonalDetailsView: View { var body: some View { Text("Personal Details") } }
struct FriendInvitesView: View { var body: some View { Text("Friend Invites") } }
struct NotificationSettingsView: View { var body: some View { Text("Notification Settings") } }
struct RateAppView: View { var body: some View { Text("Rate App") } }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


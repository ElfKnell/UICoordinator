//
//  Settings.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/03/2025.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("styleMap") private var styleMap: UserMapStyle = .standard
        
    @State private var selectedColorMarker: Color = .blue
    @State private var selectedColorText: Color = .blue
    
    var body: some View {
        
        Form {
            Section(header: Text("Map Style")) {
                Picker("Style", selection: $styleMap) {
                    ForEach(UserMapStyle.allCases, id: \.self) { style in
                        Text(style.description)
                    }
                }
                .accessibilityLabel("Map Style")
            }
            
            Section(header: Text("Style marker")) {
                
                ColorPicker("Marker Color", selection: $selectedColorMarker)
                    .accessibilityLabel("Marker Color")
                
                ColorPicker("Text Color", selection: $selectedColorText)
                    .accessibilityLabel("Text Color")
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    .accessibilityLabel("Enable Notifications")
            }
            
            Section {
                
                Button("Save Settings") {

                    selectedColorMarker.saveToAppStorage("selectedColorMarker")
                    selectedColorText.saveToAppStorage("selectedColorText")
                    
                }
                .foregroundColor(.blue)
                .accessibilityLabel("Save Settings")
                .accessibilityHint("Saves your current map and marker color settings")
            }
            
            SettingsSupportSectionView()
        }
        .navigationTitle("Settings")
        .onAppear {
        
            if let color = Color.loadFromAppStorage("selectedColorMarker") { selectedColorMarker = color }
            if let color = Color.loadFromAppStorage("selectedColorText") { selectedColorText = color }
            
        }
    }
}

#Preview {
    Settings()
}


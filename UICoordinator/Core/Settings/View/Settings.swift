//
//  Settings.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/03/2025.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("styleMap") private var styleMap: ActivityMapStyle = .standard
    @AppStorage("typeMap") private var typeMap: MapTransportType = .automobile
        
    @State private var selectedColorRoute: Color = .blue
    @State private var selectedColorMarker: Color = .blue
    @State private var selectedColorText: Color = .blue
    
    var body: some View {
        Form {
            Section(header: Text("Map Style")) {
                Picker("Style", selection: $styleMap) {
                    ForEach(ActivityMapStyle.allCases, id: \.self) { style in
                        Text(style.description)
                    }
                }
                
                Picker("Transport Type", selection: $typeMap) {
                    ForEach(MapTransportType.allCases, id: \.self) { style in
                        Text(style.description)
                    }
                }
                
                ColorPicker("Route Color", selection: $selectedColorRoute)
            }
            
            Section(header: Text("Style marker")) {
                
                ColorPicker("Marker Color", selection: $selectedColorMarker)
                
                ColorPicker("Text Color", selection: $selectedColorText)
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
            }
            
            Section {
                
                Button("Save Settings") {

                    selectedColorRoute.saveToAppStorage("routerColor")
                    selectedColorMarker.saveToAppStorage("selectedColorMarker")
                    selectedColorText.saveToAppStorage("selectedColorText")
                    
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Settings")
        .onAppear {
        
            if let loadedColor = Color.loadFromAppStorage("routerColor") {
                selectedColorRoute = Color(red: loadedColor.red, green: loadedColor.green, blue: loadedColor.blue, opacity: loadedColor.alpha)
            }
            
            if let loadedColorMarker = Color.loadFromAppStorage("selectedColorMarker") {
                selectedColorMarker = Color(red: loadedColorMarker.red, green: loadedColorMarker.green, blue: loadedColorMarker.blue, opacity: loadedColorMarker.alpha)
            }
            
            if let loadedColorText = Color.loadFromAppStorage("selectedColorText") {
                selectedColorText = Color(red: loadedColorText.red, green: loadedColorText.green, blue: loadedColorText.blue, opacity: loadedColorText.alpha)
            }
        }
    }
}

#Preview {
    Settings()
}


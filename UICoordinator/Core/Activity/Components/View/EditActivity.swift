//
//  EditActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/08/2024.
//

import SwiftUI

struct EditActivity: View {
    
    @Binding var activity: Activity
    @Binding var isSettings: Bool
    
    var body: some View {
        VStack {
            
            VStack {
                
                HStack {
                    
                    Text("Name: ")
                    
                    TextField("Name", text: $activity.name)
                }
                
                HStack {
                    
                    Text("Description: ")
                    
                    TextField("Description", text: $activity.description)
                }
                
            }
            .padding(.horizontal)
            
            HStack {
                
                Text("Type")
                
                Spacer()
                
                Picker("Type", selection: $activity.typeActivity) {
                    ForEach(ActivityType.allCases) { option in
                        Text(option.description).tag(option)
                    }
                }
                
            }
            .padding(.horizontal)
            
            Toggle(isOn: $activity.status) {
                
                Text("Privaty status")
            }
            .tint(.green)
            .padding(.horizontal)
            
            HStack {
                
                Button {
                    isSettings = false
                } label: {
                    
                    Label("Cancel", systemImage: "externaldrive.fill.badge.xmark")
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Button {
                    
                    Task {
                        try await ActivityService.updateActivity(activity)
                        isSettings = false
                    }
                    
                } label: {
                    
                    Label("Save", systemImage: "externaldrive.fill.badge.checkmark")
                        .foregroundStyle(.green)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.white .opacity(0.3))
    }
}

#Preview {
    EditActivity(activity: .constant(DeveloperPreview.activity), isSettings: .constant(true))
}

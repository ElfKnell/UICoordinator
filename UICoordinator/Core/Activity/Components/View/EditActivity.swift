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
    
    @StateObject var viewModel: EditActivityViewModel
    
    init(activity: Binding<Activity>,
         isSettings: Binding<Bool>,
         viewModelBilder: () -> EditActivityViewModel = {
        EditActivityViewModel(activityServise: ActivityServiceUpdate())
    }) {
        self._activity = activity
        self._isSettings = isSettings
        
        let vm = viewModelBilder()
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("General Information").font(.headline)) {
                    
                    TextField("Name", text: $activity.name)
                        .padding(.vertical, 8)
                    
                    TextField("Description", text: $activity.description)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Activity Details").font(.headline)) {
                    
                    HStack {
                        
                        Text("Activity type")
                        
                        Spacer()
                        
                        Picker("Type", selection: $activity.typeActivity) {
                            ForEach(ActivityType.allCases) { option in
                                Text(option.description).tag(option)
                            }
                        }
                        
                    }
                    
                    HStack {
                        
                        Text("Map Style")
                        
                        Spacer()
                        
                        Picker("Style", selection: $activity.mapStyle) {
                            Text("Default").tag(nil as UserMapStyle?)
                            ForEach(UserMapStyle.allCases) { option in
                                Text(option.description).tag(option as UserMapStyle?)
                            }
                        }
                        
                    }
                    
                    Toggle(isOn: $activity.status) {
                        
                        Text("Privaty Status")
                    }
                    .tint(.green)
                    
                }
                
                Section {
                    
                    HStack(spacing: 20) {
                        
                        Button {
                            isSettings = false
                        } label: {
                            
                            Label("Cancel", systemImage: "externaldrive.fill.badge.xmark")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundStyle(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button {
                            
                            Task {
                                await viewModel.updateActivity(activity)
                                if !viewModel.showAlert {
                                    isSettings = false
                                }
                            }
                            
                        } label: {
                            
                            Label("Save", systemImage: "externaldrive.fill.badge.checkmark")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(activity.name.isEmpty)
                        .buttonStyle(.plain)
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
            
        }
        
    }
}

#Preview {
    EditActivity(activity: .constant(DeveloperPreview.activity), isSettings: .constant(true))
}

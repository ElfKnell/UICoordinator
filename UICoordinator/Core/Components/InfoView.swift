//
//  FotoVideoActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/03/2025.
//

import SwiftUI

struct InfoView: View {
    let activity: MapSelectionProtocol
    @State private var showCreatColloqy = false
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            VStack {
                
                Spacer()
                
                PhotoVideoLocationView(location: activity)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.linearGradient(colors: [.red, .yellow], startPoint: .bottomTrailing, endPoint: .topLeading))
                    )
                    .modifier(CornerRadiusModifier())
                    .padding()
                
                HStack() {
                    
                    Text("Description: ")
                        .font(.title2)
                    
                    Text(activity.description)
                        .font(.title2)
                }
                .padding()
                .frame(height: 44)
                .modifier(CornerRadiusModifier())
                .padding()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        showCreatColloqy.toggle()
                    } label: {
                        HStack {
                            Text("Creat new colloquy")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "plus.message")
                                .font(.title2)
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    
                    Spacer()
                    
                }
                .padding()
                .frame(height: 44)
                .modifier(CornerRadiusModifier())
                .padding()
                
                
                if let activity = activity as? Activity {
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("Type")
                        
                        Spacer()
                        
                        Text("\(activity.typeActivity)")
                        
                        Spacer()
                        
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(height: 44)
                    .modifier(CornerRadiusModifier())
                    .padding(.horizontal)
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("Date create: ")
                        
                        Spacer()
                        
                        Text(activity.time.dateValue(), style: .date)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(height: 44)
                    .modifier(CornerRadiusModifier())
                    .padding(.horizontal)
                    
                    if let updateTime = activity.udateTime {
                        HStack {
                            
                            Spacer()
                            
                            Text("Date update: ")
                            
                            Spacer()
                            
                            Text(updateTime.dateValue(), style: .date)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(height: 44)
                        .modifier(CornerRadiusModifier())
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                Spacer()
                
            }
            .navigationTitle(activity.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $showCreatColloqy, content: {
                CreateColloquyView(location: activity as? Location, activityId: ((activity as? Activity) != nil) ? activity.id : nil)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                }
            }
        }
    }
}

#Preview {
    InfoView(activity: DeveloperPreview.activity)
}

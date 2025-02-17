//
//  InfoActivityView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/09/2024.
//

import SwiftUI

struct InfoActivityView: View {
    
    var activity: Activity
    @Binding var isInfo: MapSheetConfig?
    
    var body: some View {
        VStack {
            
            VStack {
                
                HStack {
                    
                    Text("Name: ")
                    
                    Text(activity.name)
                }
                .font(.title2)
                
                HStack {
                    
                    Text("Description: ")
                    
                    Text(activity.description)
                }
                .font(.subheadline)
                
            }
            .fontWeight(.bold)
            .padding(.horizontal)
            
            HStack {
                
                Text("Type")
                
                Spacer()
                
                Text("\(activity.typeActivity)")
                
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal)
            
            HStack {
                Text("Date create: ")
                
                Spacer()
                
                Text(activity.time.dateValue(), style: .date)
            }
            .padding(.horizontal)
            
            if let updateTime = activity.udateTime {
                HStack {
                    Text("Date update: ")
                    
                    Spacer()
                    
                    Text(updateTime.dateValue(), style: .date)
                }
                .padding(.horizontal)
            }
            
            HStack {
                
                Button {
                    isInfo = nil
                } label: {
                    
                    Label("OK", systemImage: "checkmark.circle.fill")
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
    InfoActivityView(activity: DeveloperPreview.activity, isInfo: .constant(nil))
}

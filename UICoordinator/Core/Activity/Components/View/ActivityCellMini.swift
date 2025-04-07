//
//  ActivityCellMini.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import SwiftUI

struct ActivityCellMini: View {
    let activity: Activity

    @StateObject var viewModel = ActivityCellViewModel()
    @State private var showReplies = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: activity.user, size: .small)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    VStack {
                        HStack {
                            
                            Text(activity.user?.username ?? "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(activity.time.timestampString())
                                .font(.caption)
                                .foregroundStyle(Color(.systemGray3))
                            
                        }
                        
                        HStack {
                            
                            Text(activity.name)
                                .font(.footnote)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("^[\(activity.locationsId.count) location](inflect: true)")
                                .font(.footnote)
                            
                        }
                        
                        HStack(spacing: 8) {
                            
                            Text(activity.typeActivity.description)
                                .font(.footnote)
                                .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                }
            }
            
            VerticalSeparatorView()
            
        }
        .padding()
    }
}

#Preview {
    ActivityCellMini(activity: DeveloperPreview.activity)
}

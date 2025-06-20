//
//  ResetPasswordView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/05/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State var viewModel = ResetPasswordViewModel(authReset: AuthResetPasswordService())
    @FocusState private var emailFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            BackgroundView(backgroundHeight: .large)
            
            VStack {
                
                Spacer()
                
                LogoView()
                    .padding()
                
                switch viewModel.processReset {
                case .isStart:
                    
                    InputView(text: $viewModel.email, title: "Email", placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)
                        .focused($emailFieldFocused)
                        .padding()
                    
                    HStack {
                        
                        Button {
                            viewModel.processReset = .isStart
                            dismiss()
                        } label: {
                            ButtonLabelView(title: "Back", widthButton: 170)
                        }
                        
                        Button {
                            Task {
                                await viewModel.resetPassword()
                            }
                        } label: {
                            ButtonLabelView(title: "Send", widthButton: 170)
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    
                case .isSuccess:
                    
                    Text(viewModel.message)
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.green)
                        .padding(.horizontal)
                    
                    Button {
                        viewModel.processReset = .isStart
                        dismiss()
                    } label: {
                        ButtonLabelView(title: "Back", widthButton: 170)
                    }
                    
                case .isIssue:
                    Text(viewModel.message)
                        .font(.title2)
                        .padding(.horizontal)
                    
                    HStack {
                        
                        Button {
                            viewModel.processReset = .isStart
                        } label: {
                            ButtonLabelView(title: "Try again", widthButton: 150)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            viewModel.processReset = .isStart
                            dismiss()
                        } label: {
                            ButtonLabelView(title: "Back", widthButton: 150)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                Spacer()
                
            }
            .onAppear {
                emailFieldFocused = true
            }
        }
    }
}

#Preview {
    
    //let viewModel = ResetPasswordViewModel(authReset: AuthResetPasswordService())
    
    ResetPasswordView()
}

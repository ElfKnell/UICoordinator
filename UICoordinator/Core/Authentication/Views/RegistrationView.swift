//
//  RegistrationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var registrationModel = RegistrationViewModel()
    @Binding var isNewUser: Bool
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                BackgroundView(backgroundHeight: .large)
                
                VStack {
                    
                    Spacer()
                    if sizeClass != .compact {
                        Spacer()
                    }
                    
                    LogoView()
                    
                    InputView(text: $registrationModel.email, title: "Email", placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $registrationModel.name, title: "Full name", placeholder: "Name")
                    
                    InputView(text: $registrationModel.username, title: "Username", placeholder: "Username")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $registrationModel.password, title: "Password", placeholder: "password", isSecureField: true)
                    
                    ZStack(alignment: .trailing) {
                        
                        InputView(text: $registrationModel.cPassword, title: "Confirm password", placeholder: "confirm password", isSecureField: true)
                        
                        if !registrationModel.password.isEmpty && !registrationModel.cPassword.isEmpty {
                            
                            if registrationModel.password == registrationModel.cPassword {
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                                
                            } else {
                                
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    .padding()
                    
                    Button {
                        
                        Task {
                            
                            self.isNewUser = await registrationModel.createUser()
                            
                            if self.isNewUser {
                                dismiss()
                            }
                        }
                        
                    } label: {
                        
                        ButtonLabelView(title: "Sign up", widthButton: 170)
                        
                    }
                    .padding()
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    if sizeClass != .compact {
                        Spacer()
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 20, design: .serif))
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Sign in")
                                .bold()
                                .font(.system(size: 23, design: .serif))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.bottom)
                    
                    Spacer()

                }
                .alert("Login problems", isPresented: $registrationModel.isCreateUserError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(registrationModel.errorCreated ?? "no error")
                }
            }
        }
    }
}

#Preview {
    RegistrationView(isNewUser: .constant(false))
}

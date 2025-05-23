//
//  LoginView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/02/2024.
//

import SwiftUI
import Observation

struct LoginView: View {
    
    @State var loginModel = LoginViewModel()
    @EnvironmentObject var container: DIContainer
    @Environment(\.horizontalSizeClass) var sizeClass
    
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
                    
                    if loginModel.isCreatedUser {
                        
                        HStack {
                            Text("Please sign in")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                        .padding()
                        
                    }
                    
                    InputView(text: $loginModel.email, title: "Email", placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $loginModel.password, title: "Password", placeholder: "password", isSecureField: true)
                        .padding(.bottom)
                    
                    NavigationLink {
                        ResetPasswordView()
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.green)
                            .font(.system(size: 20, design: .serif))
                            .offset(x:90)
                    }
                    .padding(.bottom)
                    
                    Button {
                        Task {
                            
                            await container.authService.login(withEmail: loginModel.email, password: loginModel.password)
                            
                            loginModel.isCreatedUser = false
                            
                            if container.authService.errorMessage != nil {
                                loginModel.isLoginError = true
                            }
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Login", widthButton: 170)
                
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                    if sizeClass != .compact {
                        Spacer()
                    }
                    
                    HStack {
                        
                        Text("Don't have an account?")
                            .font(.system(size: 20, design: .serif))
                        
                        NavigationLink {
                            RegistrationView(isNewUser: $loginModel.isCreatedUser)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Sing up")
                                .bold()
                                .font(.system(size: 23, design: .serif))
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Spacer()
                  
                }
                .alert("Login problems", isPresented: $loginModel.isLoginError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(container.authService.errorMessage ?? "no error")
                }

            }
        }
    }
}

#Preview {
    LoginView()
}

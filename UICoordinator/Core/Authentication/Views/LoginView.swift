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
    
    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                BackgroundView()
                    .onTapGesture {
                        focusedField = nil
                    }
                
                if !loginModel.isLoading {
                    
                    VStack {
                        
                        Spacer()
                        if sizeClass != .compact {
                            Spacer()
                        }
                        
                        LogoView()
                        
                        if sizeClass != .compact {
                            Spacer()
                        }
                        
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
                            .focused($focusedField, equals: .email)
                            .accessibilityLabel("Email input field")
                        
                        InputView(text: $loginModel.password, title: "Password", placeholder: "password", isSecureField: true)
                            .padding(.bottom)
                            .focused($focusedField, equals: .password)
                            .accessibilityLabel("Password input field")
                        
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink {
                                ResetPasswordView()
                            } label: {
                                Text("Forgot password?")
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                                    .font(.title3)
                                
                            }
                            .padding([.bottom, .horizontal])
                            .accessibilityLabel("Forgot password button")
                        }
                        
                        Button {
                            
                            Task {
                                loginModel.isLoading = true
                                
                                await container.authService.login(withEmail: loginModel.email, password: loginModel.password)
                                
                                loginModel.isCreatedUser = false
                                
                                if container.authService.errorMessage != nil {
                                    loginModel.isLoginError = true
                                }
                                
                                loginModel.isLoading = false
                            }
                            
                        } label: {
                            
                            ButtonLabelView(title: "Login", widthButton: 170)
                                .padding(.bottom)
                            
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .accessibilityLabel("Login button")
                        .accessibilityHint("Tap to sign in with your credentials")
                        
                        
                        HStack {
                            
                            Text("Don't have an account?")
                                .font(.title3)
                            
                            NavigationLink {
                                RegistrationView(isNewUser: $loginModel.isCreatedUser)
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Text("Sign up")
                                    .bold()
                                    .underline()
                                    .font(.title2)
                                    .foregroundStyle(.black)
                                    .shadow(radius: 3, x: 0, y: 2)
                            }
                            .accessibilityLabel("Sign up button")
                            .accessibilityHint("Tap to create a new account")
                        }
                        .padding(.top)
                        
                        Spacer()
                        if sizeClass != .compact {
                            Spacer()
                        }
                        
                    }
                    .alert("Login problems", isPresented: $loginModel.isLoginError) {
                        Button("Email Support") {
                            if let emailURL = URL(
                                string: "mailto:kyrych.app@gmail.com"
                            ) {
                                UIApplication.shared.open(emailURL)
                            }
                        }
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(container.authService.errorMessage ?? "no error description")
                    }
                    .onAppear {
                        focusedField = .email
                    }
                    
                } else {
                    LoadingView(size: 250)
                }
                
            }
        }
    }
}

#Preview {
    LoginView()
}

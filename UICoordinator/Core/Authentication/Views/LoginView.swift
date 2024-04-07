//
//  LoginView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/02/2024.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    
                    Spacer()
                    
                    LogoView()
                    
                    InputView(text: $loginModel.email, title: "Email", placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $loginModel.password, title: "Password", placeholder: "password", isSecureField: true)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.green)
                            .font(.system(size: 20, design: .serif))
                            .offset(x:90)
                    }
                    
                    Button {
                        Task {
                            try await loginModel.loginUser()
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Login", widthButton: 170)
                
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                    
                    HStack {
                        
                        Text("Don't have an account?")
                            .font(.system(size: 20, design: .serif))
                        
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Sing up")
                                .bold()
                                .font(.system(size: 23, design: .serif))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

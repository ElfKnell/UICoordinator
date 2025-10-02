//
//  RegistrationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @Binding var isNewUser: Bool
    @StateObject var registrationModel: RegistrationViewModel
    
    @FocusState private var isPasswordFocused: Bool
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss
    
    init(isNewUser: Binding<Bool>, viewModelBuilder: @escaping () -> RegistrationViewModel = { RegistrationViewModel(userCreate: AuthCreateService(createUserService: CreateUserFirebase(firestoreService: FirestoreCreateUserService(firestoreInstance: FirestoreAdapter())), authService: FirebaseAuthCreateService()))
    }) {
        
        self._isNewUser = isNewUser
        _registrationModel = StateObject(wrappedValue: viewModelBuilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                BackgroundView()
                
                if !registrationModel.isLoading {
                    
                    ScrollView {
                        
                        VStack {
                            
                            if sizeClass != .compact {
                                
                                Spacer()
                                Spacer()
                                
                            }
                            
                            LogoView()
                            
                            ZStack(alignment: .leading) {
                                
                                VStack {
                                    
                                    InputView(text: $registrationModel.email, title: "Email", placeholder: "name@example.com")
                                        .textInputAutocapitalization(.never)
                                        .accessibilityLabel("Email field")
                                        .accessibilityHint("Enter your email address")
                                    
                                    InputView(text: $registrationModel.name, title: "Full name", placeholder: "Name")
                                        .accessibilityLabel("Full name field")
                                        .accessibilityHint("Enter your full name")
                                    
                                    InputView(text: $registrationModel.username, title: "Username", placeholder: "Username")
                                        .textInputAutocapitalization(.never)
                                        .accessibilityLabel("Username field")
                                        .accessibilityHint("Enter your username")
                                    
                                    InputView(text: $registrationModel.password, title: "Password", placeholder: "password", isSecureField: true)
                                        .focused($isPasswordFocused)
                                        .accessibilityLabel("Password field")
                                        .accessibilityHint("Enter your password")
                                    
                                }
                                
                                if isPasswordFocused  {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        PasswordRuleView(text: "Minimum 8 characters", isValide: registrationModel.password.count > 7)
                                        
                                        PasswordRuleView(text: "At least one uppercase letter", isValide: registrationModel.password.range(of: "[A-Z]", options: .regularExpression) != nil)
                                        
                                        PasswordRuleView(text: "At least one lowercase letter", isValide: registrationModel.password.range(of: "[a-z]", options: .regularExpression) != nil)
                                        
                                        PasswordRuleView(text: "At least one number", isValide: registrationModel.password.range(of: "[0-9]", options: .regularExpression) != nil)
                                        
                                        PasswordRuleView(text: "(!@$&*^%#)", isValide: registrationModel.password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil)
                                        
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 10)
                                    .transition(.scale)
                                    
                                }
                            }
                            .animation(.easeInOut,
                                       value: registrationModel.password.isEmpty)
                            
                            ZStack(alignment: .trailing) {
                                
                                InputView(text: $registrationModel.cPassword, title: "Confirm password", placeholder: "confirm password", isSecureField: true)
                                    .accessibilityLabel("Confirm password field")
                                    .accessibilityHint("Re-enter your password to confirm")
                                
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
                            
                            Toggle(isOn: $registrationModel.isLicenseAccepted) {
                                
                                HStack {
                                    
                                    Link(destination: URL(string: registrationModel.privacyPolicy)!) {
                                        Text("Privacy Policy")
                                    }
                                    
                                    Text("&")
                                    
                                    Link(destination: URL(string: registrationModel.eula)!) {
                                        Text("EULA")
                                    }
                                }
                            }
                            .frame(width: 300)
                            .padding()
                            .accessibilityLabel("Accept privacy policy and EULA")
                            .accessibilityHint("Toggle to accept terms and conditions")
                            
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
                            .accessibilityLabel("Sign up button")
                            .accessibilityHint("Tap to create a new account")
                            
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
                                        .underline()
                                        .font(.system(size: 23, design: .serif))
                                        .foregroundStyle(.black)
                                        .shadow(radius: 3, x: 0, y: 2)
                                }
                                .accessibilityLabel("Sign in button")
                                .accessibilityHint("Tap to go to login screen")
                                
                            }
                            .padding(.bottom)
                            
                            if sizeClass != .compact {
                                Spacer()
                            }
                            
                        }
                        .alert("Registation problems", isPresented: $registrationModel.isCreateUserError) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(registrationModel.errorCreated ?? "no error")
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    
                } else {
                    LoadingView(size: 300)
                        .accessibilityLabel("Loading indicator")
                        .accessibilityHint("Please wait while we process your registration")
                }
            }
        }
    }
}

#Preview {
    
    RegistrationView(isNewUser: .constant(false))
}

import SwiftUI


struct GoogleSignInButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image("googlelogo") // Replace with your actual logo asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30) // Adjust to your image's aspect ratio
                    

                Text("Google ile Oturum Aç")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.leading, 20)

                Spacer() // This pushes the icon and text to the left
            }
            .padding()
            .background(Color.white) // Use the appropriate color
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
        .frame(width: 280, height: 50) // Adjust width and height as needed
        .padding()
    }
}


// Custom modifier for text fields
struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var showPassword: Bool = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white.opacity(0.2))
                .cornerRadius(15)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding(.leading, 1)

                if isSecure {
                    if showPassword {
                        TextField(placeholder, text: $text)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    } else {
                        SecureField(placeholder, text: $text)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                }

                Spacer()

                if isSecure {
                    Button(action: {
                        self.showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white.opacity(0.6))
                        
                    }
                    .padding(.trailing, 15)
                }
            }
            .padding()
        }
        .frame(height: 50)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 25)
    }
}




// Custom button style for a smoother and more beautiful look
struct BeautifulButtonStyle: ButtonStyle {
    var color1: Color
    var color2: Color
    var textColor: Color
    var frameWidth: CGFloat?

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(width: frameWidth, height: 54)
            .background(LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15) // Smooth rounded corners
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .foregroundColor(textColor)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GradientBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.red]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal, 25)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    let buttonWidth = UIScreen.main.bounds.width - 50
    @State private var isUserLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Logo Image - replace "logo-placeholder" with your image name
                    Image("luckylogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 30)
                    
                    // Email field
                    CustomTextField(
                        icon: "envelope",
                        placeholder: "Email",
                        text: $email
                    )
                    Spacer()
                    
                    CustomTextField(
                        icon: "lock",
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )
                    
                    // Remember Me checkbox
                    HStack {
                        Button(action: {
                            self.rememberMe.toggle()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.square")
                                    .resizable() // Make the image resizable
                                    .frame(width: 24, height: 24) // Set the frame to the desired size
                                    .foregroundColor(rememberMe ? .white : .clear) // Checkmark is white when selected, otherwise transparent
                                    .background(rememberMe ? Color.purple : Color.white) // Background is purple when selected, otherwise white
                                    .cornerRadius(5) // Rounded corners for background
                                Text("Beni Hatırla")
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 0.4)
                            }
                        }
                        .padding(.leading, 25)
                        
                        Spacer()
                        
                        Button(action: {
                            // Forgot password action
                        }) {
                            Text("Şifremi Unuttum?")
                                .foregroundColor(.white)
                                .padding(.trailing, 25)
                                .shadow(color:.black,radius: 0.4)
                        }
                    }
                    .padding(.top, 15)
                    
                    Button("Oturum Aç", action: {
                        self.isUserLoggedIn = true
                        // Handle login logic here
                    })
                    .buttonStyle(BeautifulButtonStyle(color1: .pink, color2: .pink, textColor: .white, frameWidth: buttonWidth))
                    .padding(.top, 20)
                    NavigationLink(destination: ContentView(), isActive: $isUserLoggedIn) {
                                        EmptyView()
                                    }
                    
                    // Divider with "ya da" text in the middle
                    HStack {
                        Line()
                        Text("ya da")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10) // Spacing around the text
                        // Background to overlap the line
                        Line()
                    }
                    .padding(.vertical, 20) // Spacing above and below the divider
                    
                    // Google login button with beautiful style
                    
                    GoogleSignInButton(action: {
                        // Handle Google sign-in action here
                        self.isUserLoggedIn = true
                    })
                    NavigationLink(destination: ContentView(), isActive: $isUserLoggedIn) {
                                        EmptyView()
                                    }
                    
                    .buttonStyle(BeautifulButtonStyle(color1: .white, color2: .white, textColor: .black, frameWidth: buttonWidth))
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    
                    // Sign up link
                    HStack {
                        Text("Hesabın yok mu?")
                            .foregroundColor(.white)
                            .shadow(color:.black,radius: 0.4)
                        Button(action: {
                            // Handle sign up logic here
                        }) {
                            Text("Kaydol")
                                .foregroundColor(Color.pink)
                                .bold()
                                .shadow(color:.white,radius: 0.4)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// A custom view for the line part of the divider
    struct Line: View {
        var body: some View {
            Rectangle()
                .frame(width: 120, height: 1)
                .foregroundColor(.white)
                .opacity(0.5)
        }
    }

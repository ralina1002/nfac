import SwiftUI
import Speech
import AVFoundation

struct WelcomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .green]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Welcome to the Worst Dating Experience!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
                    .cornerRadius(10)
                    .background(Color.yellow.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 4)
                    )
                
                Text("* Have you seriously come to the point of using this?")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.red)
                    .padding(.bottom, 30)
            
                HStack {
                    Text("0 matches made")
                        .font(.caption)
                        .padding([.top, .leading])
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                    
                    Text("1000+ Tears Shed")
                        .font(.headline)
                        .padding([ .bottom, .trailing, .leading])
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(0)
                    
                    Text("999 Design Regrets")
                        .font(.subheadline)
                        .padding([.top, .bottom, .trailing])
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                }
                
                Text("Ready to get your heart broken? (Again)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                NavigationLink(destination: RegistrationView()) {
                    Text("Attempt Registration, huh")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.gray)
                        .cornerRadius(0)
                }.padding(.top, 50)
                
                NavigationLink(destination: LoginView()) {
                    Text("Already Registered? Login")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.padding(.top, 10)
            }
        }.padding(.leading, 17)  // change this from 20 to 10 to make the white line thinner
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeView()
        }
    }
}

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var age: Int = 18
    @State private var phoneNumber: Int = 0
    @State private var nationality: String = ""
    @State private var buttonPosition: CGPoint = CGPoint(x: 50, y: 50)
    @State private var showError: Bool = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    // Dropdown menu options for each letter
    let letterOptions = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @State private var selectedLetters: [String] = Array(repeating: "", count: 8)
    @State private var isRegistrationComplete = false

    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Enter your name:")
                    .padding()
                    .font(.headline)
                HStack {
                    ForEach(0..<8, id: \.self) { index in
                        // Dropdown menu for each letter
                        Picker(selection: $selectedLetters[index], label: Text("Letter \(index + 1)")) {
                            ForEach(letterOptions, id: \.self) { letter in
                                Text(letter).tag(letter)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.yellow)
                    }
                }

                SecureField("Password", text: $password, onCommit: {
                    readPassword()
                })

                .padding()
                .background(Color.blue)

                HStack {
                    Text("Age: \(convertToRoman(age))")
                        .padding()
                        .background(Color.orange)

                    Button(action: {
                        age = Int.random(in: 18...100)
                    }) {
                        Text("No!")
                    }
                    .padding()
                    .background(Color.gray)
                }

                HStack {
                    Text("Phone number: +\(phoneNumber)")
                        .padding()
                        .background(Color.purple)

                    Button(action: {
                        phoneNumber += 1
                    }) {
                        Text("Increase Phone Number")
                    }
                    .padding()
                    .background(Color.purple)
                }

                HStack {
                    TextField("Nationality", text: $nationality)
                        .padding()
                        .background(Color.white)

                    Button(action: {
                        if nationality.lowercased() != "kazakh" {
                            showError = true
                        } else {
                            showError = false
                        }
                    }) {
                        Text("Change")
                    }
                    .padding()
                    .background(Color.orange)
                }

                if showError {
                    Text("Подумай еще раз, может все-таки kazakh")
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    // Perform registration logic here

                    // Assuming registration is successful, set isRegistrationComplete to true
                    isRegistrationComplete = true
                }) {
                    Text("Register Now!")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.black)
                }
                .position(buttonPosition)
                .onReceive(timer) { _ in
                    self.buttonPosition = CGPoint(x: Int.random(in: 0...200), y: Int.random(in: 0...200))
                }
            }
            .padding()
        }
        .background(NavigationLink(destination: FinalView(), isActive: $isRegistrationComplete) { EmptyView() })
    }

    func convertToRoman(_ number: Int) -> String {
        let romanNumerals: [Int: String] = [
            1000: "M",
            900: "CM",
            500: "D",
            400: "CD",
            100: "C",
            90: "XC",
            50: "L",
            40: "XL",
            10: "X",
            9: "IX",
            5: "V",
            4: "IV",
            1: "I"
        ]

        var result = ""
        var num = number

        for (value, letter) in romanNumerals.sorted(by: { $0.key > $1.key }) {
            while num >= value {
                num -= value
                result += letter
            }
        }

        return result
    }

    func readPassword() {
        let utterance = AVSpeechUtterance(string: password)
        speechSynthesizer.speak(utterance)
    }
}

struct FinalView: View {
    var body: some View {
        ZStack {
            Color.red
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("404 Not Found")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Oh, how sad, you are doomed to be alone")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Image("background_image")
                           .resizable()
                           .scaledToFill()
                           .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("Username", text: $username)
                    .background(Color.orange)
                    .padding(.leading, 200)
                    .padding(.top, 400)
                
                SecureField("Password", text: $password)
                    .background(Color.cyan)
                    .padding(.leading, 20)
                    .padding(.top, 100)
                
                Button(action: loginButtonClicked) {
                    Text("Login")
                        .foregroundColor(.black)
                }
                .background(Color.brown)
                .padding(.leading, 250)
                .padding(.top, 300)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func loginButtonClicked() {
        // Implement login functionality here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

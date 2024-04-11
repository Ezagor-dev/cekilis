//
//  GalleryView.swift
//  cekilis
//
//  Created by Ezagor on 10.04.2024.
//


import SwiftUI
import Photos
import CoreMotion
import Kingfisher
import Firebase


class SheetManager: ObservableObject {
    @Published var showingDetail: Bool = false
    @Published var selectedImage: UIImage? // Optional: If you're using UIImage in some contexts
    @Published var selectedPrompt: String?
    @Published var selectedImageURL: String? // Changed to a normal String property
    @Published var showingPurchaseView: Bool = false // Ensure this property is declared

}

class SheetManagerTickets: ObservableObject {
    @Published var showingDetail: Bool = false
    @Published var selectedImage: UIImage? // Optional: If you're using UIImage in some contexts
    @Published var selectedDescription: String?
    @Published var selectedImageURL: String? // Changed to a normal String property
    @Published var showingPurchaseView: Bool = false // Ensure this property is declared
    @Published var selectedTicketTitle: String? 
}

struct Artwork: Identifiable {
    var id: String
    var prompt: String
    var category: String
    var imageURL: String
    var isLoading: Bool = true // Default to true
}

struct Tickets: Identifiable{
    var id: String
    var category: String
    var description: String
    var imageURL: String
    var isAvailable: Bool = true
    var isLive: Bool = false
    var prizeCount: Int
    var prizeValue: Int
    var purchaseCount: Int
    var raffleDateString: String
    var ticketPrice: Double
    var titleTicket: String
    var totalTicket: Int
}

class TicketsViewModel: ObservableObject {
    @Published var tickets = [Tickets]()
    @Published var isLoading = false
        @Published var errorMessage: String?
    private var db = Firestore.firestore()
    private let pageSize = 150 // Decide the number of artworks to fetch each time

    func fetchTickets() {
        isLoading = true
        db.collection("tickets").limit(to: pageSize).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            // Shuffle the artworks here
            self.tickets = documents.map { doc -> Tickets in
                let data = doc.data()
                let category = data["category"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                let isAvailable = data["isAvailable"] as? Bool ?? true
                let isLive = data["isLive"] as? Bool ?? false
                let prizeCount = data["prizeCount"] as? Int ?? 2
                let prizeValue = data["prizeValue"] as? Int ?? 200
                let purchaseCount = data["purchaseCount"] as? Int ?? 5
                let raffleDateString = data["raffleDateString"] as? String ?? ""
                let ticketPrice = data["ticketPrice"] as? Double ?? 5
                let titleTicket = data["titleTicket"] as? String ?? ""
                let totalTicket = data["totalTicket"] as? Int ?? 10
                
                return Tickets(id: doc.documentID, category: category, description: description, imageURL: imageURL, isAvailable: isAvailable, isLive: isLive, prizeCount: prizeCount, prizeValue: prizeValue, purchaseCount: purchaseCount, raffleDateString: raffleDateString, ticketPrice: ticketPrice, titleTicket: titleTicket, totalTicket: totalTicket)

                
            }.shuffled() // Shuffle the array of artworks
        }
        self.isLoading = false
    }
}


class ArtworksViewModel: ObservableObject {
    @Published var artworks = [Artwork]()

    private var db = Firestore.firestore()
    private let pageSize = 150 // Decide the number of artworks to fetch each time

    func fetchArtworks() {
        db.collection("artworks").limit(to: pageSize).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            // Shuffle the artworks here
            self.artworks = documents.map { doc -> Artwork in
                let data = doc.data()
                let category = data["category"] as? String ?? ""
                let prompt = data["prompt"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                
                return Artwork(id: doc.documentID, prompt: prompt, category: category, imageURL: imageURL)

                
            }.shuffled() // Shuffle the array of artworks
        }
    }
}




struct CategoryItem: View {
    var category: String
    var isSelected: Bool
    var action: () -> Void
    @State private var isHovering = false
    var image: Image

    var body: some View {
            image // Assuming you're using local images
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(15)
                .overlay(
                    Text(category)
                        .foregroundColor(isSelected ? .white : Color.white.opacity(0.7))
                        .font(.headline)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10),
                    alignment: .bottom
                )
                .onTapGesture(perform: action)
                .padding(4)
        }
}


struct GalleryView: View {
    @State private var isAnimating = false
    @ObservedObject private var viewModel = ArtworksViewModel()
    @StateObject var sheetManager = SheetManager()
    let categories = ["araba", "beyazEsya", "telefon", "oyunBilgisayari", "televizyon", "tablet", "hoverboard", "karavan"]
    @State private var selectedCategory: String = "araba"
    // Define the gradient colors
       @State private var animateGradient = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var animate = false
    @State private var isImageLoaded = false
    @State private var isLoading = true
    let categoryImages: [String: String] = [
            "araba": "araba",
            "beyazEsya": "beyazEsya",
            "telefon":"telefon",
            "oyunBilgisayari":"oyunBilgisayari",
            "televizyon":"televizyon",
            "tablet":"tablet",
            "hoverboard":"hoverboard",
            "karavan":"karavan"
            // Add the rest of your category image names here
        ]
    

    var filteredArtworks: [Artwork] {
        selectedCategory == "araba" ? viewModel.artworks : viewModel.artworks.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationView {
            
            ZStack{
                
                // Dynamic gradient background
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#6D5BBA"), Color(hex: "#5A189A"), Color(hex: "#9D4EDD"), Color(hex: "#C77DFF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .animation(
                                        Animation.easeInOut(duration: 5)
                                            .repeatForever(autoreverses: true),
                                        value: animateGradient
                                    )
                                    .onAppear {
                                        animateGradient.toggle()
                                    }
                                    .edgesIgnoringSafeArea(.all)
                                
                VStack {
                    
                // Category Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            if let imageName = categoryImages[category], let image = UIImage(named: imageName) {
                                CategoryItem(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: {
                                        withAnimation {
                                            selectedCategory = category
                                        }
                                    },
                                    image: Image(uiImage: image) // The correct position for the image parameter
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                
                // Artworks Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredArtworks) { artwork in
                            
                            
                            Button(action: {
                                
                                                        self.sheetManager.selectedPrompt = artwork.prompt
                                                        self.sheetManager.selectedImageURL = artwork.imageURL // Assuming you have this property
                                                        self.sheetManager.showingDetail = true
                                                    }) {
                                                        ZStack {
                                                            
                                                            if isLoading {
                                                                // Placeholder view
                                                                ZStack {
                                                                    Color.gray.opacity(0.3)
                                                                    VStack(spacing: 20) {
                                                                        ProgressView()
                                                                    }
                                                                }
                                                            }
                                                                        

                                                            KFImage(URL(string: artwork.imageURL))
                                                                .resizable()
                                                                .onSuccess { _ in isImageLoaded = true }
                                                                .onFailure { _ in isImageLoaded = false }
                                                                .scaledToFit()
                                                                .frame(height: 200)
                                                                .cornerRadius(8)
                                                                .opacity(isImageLoaded ? 1 : 0)
                                                            
                                                        }
                                                    }
                                                    .padding(.bottom)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                }
            }
             // Hides the default back button
        }.navigationBarBackButtonHidden(true)
            
            .onAppear() {
                viewModel.fetchArtworks()
                animateGradient.toggle()
                
            }
            
            .fullScreenCover(isPresented: $sheetManager.showingDetail) {
                // Ensure imageURLString is non-nil and create URL
                if let selectedPrompt = sheetManager.selectedPrompt,
                   let imageURLString = sheetManager.selectedImageURL,
                   let imageURL = URL(string: imageURLString) {
                    ImageDetailViewPromptLast(prompt: selectedPrompt, imageURL: imageURL)
                } else {
                    Text("No image selected or image failed to load.")
                }
            }
            
        }
}
    

// Since we're using SwiftUI, we declare a preview provider to see our view in the Xcode canvas

extension ArtworksViewModel {
    var categories: [String] {
        Set(artworks.map { $0.category }).sorted()
    }
}
struct ImageDetailViewPromptLastTickets: View {
    @State private var showSaveAnimation = false
    @State private var isSharing = false

    @StateObject var sheetManagerTickets = SheetManagerTickets()
    @State var motion: CMDeviceMotion? = nil
    let motionManager = CMMotionManager()
    let thresholdPitch: Double = 35 * .pi / 180
    let maxRotationAngle = 20.0
    @State var save = false
    @State private var showSuccessMessage = false
    @State private var showMessage = false
        @State private var messageText = ""
        @State private var messageColor = Color.green
    @State private var animateStrokeStart = false
        @State private var animateStrokeEnd = false
    //var image: UIImage
    var description: String
    var imageURL: URL
    @State private var shareImage: UIImage?

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
   
    
    var body: some View {
        ZStack {
            VStack {
                HStack{

                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Custom Back Icon
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                    
                }
                
                    Spacer()
            
                    
                    Button(action: {
                       
                            isSharing = true
                        loadImageForSharing(from: imageURL)
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .bold()
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 70)
//                                .offset(x: -10, y: -15)
//                                .padding(.top, 70)
                        }
                    
                
                }.padding(.top, 10)
                    .padding([.leading, .trailing], 20) // This ensures the HStack fills the width and places content at the top

                .sheet(isPresented: $isSharing, onDismiss: {
                    // You can perform any actions you need when the sheet is dismissed
                    isSharing = false
                    shareImage = nil
                }, content: {
                    // Convert the URL to a UIImage if possible and present it in an ActivityViewController
                    if let uiImage = shareImage {
                            ActivityViewController(activityItems: [uiImage])
                        }
                })
                /*.frame(maxWidth: .infinity, alignment: .leading)*/ // Ensures the HStack takes full width
                //Spacer()
                
                ZStack{
                    KFImage(imageURL)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                        .cornerRadius(20)
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                        }
                        .padding()

                Text(description)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                
                Spacer()
                
                HStack(spacing: 20) {
                                    Button(action: {
                                        
                                        UIPasteboard.general.string = description
                                        displayMessage("Prompt copied to clipboard.", color: .blue)
                                    }) {
                                        Label("Satın Al", systemImage: "dollarsign")
                                    }
                                    .buttonStyle(ActionButtonStyle(backgroundColor: Color.blue))
                                    
                                    
                                    .padding()
                                }
                            }

                                                   // Message overlay
                                                   if showMessage {
                                                       messageOverlay
                                                           .transition(.move(edge: .bottom).combined(with: .opacity))
                                                           .animation(.easeOut(duration: 2.5), value: showMessage)
                                                          
                                                           .onAppear {
                                                               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                   showMessage = false
                                                               }
                                                           }
                                                   }
                                               }
                                               .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3D2C8D"), Color(hex: "#916BBF")]), startPoint: .top, endPoint: .bottom))
                                               .edgesIgnoringSafeArea(.all)
                                           }

                           private var messageOverlay: some View {
                               Text(messageText)
                                   .bold()
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(messageColor)
                                   .cornerRadius(10)
                                   .shadow(radius: 10)
                                   .padding(.horizontal)
                                   .frame(maxWidth: .infinity)
                                   .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
                           }

    
    private func loadImageForSharing(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.shareImage = image
                    self.isSharing = true // Present the share sheet once the image is loaded
                }
            } else {
                // Handle the error scenario, perhaps show an alert to the user
                print("Error loading image for sharing: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    

    
    
    
        private func displayMessage(_ text: String, color: Color) {
            messageText = text
            messageColor = color
            showMessage = true
        }
    }


struct ImageDetailViewPromptLast: View {
    @State private var showSaveAnimation = false
    @State private var isSharing = false

    @StateObject var sheetManager = SheetManager()
    @State var motion: CMDeviceMotion? = nil
    let motionManager = CMMotionManager()
    let thresholdPitch: Double = 35 * .pi / 180
    let maxRotationAngle = 20.0
    @State var save = false
    @State private var showSuccessMessage = false
    @State private var showMessage = false
        @State private var messageText = ""
        @State private var messageColor = Color.green
    @State private var animateStrokeStart = false
        @State private var animateStrokeEnd = false
    //var image: UIImage
    var prompt: String
    var imageURL: URL
    @State private var shareImage: UIImage?

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
   
    
    var body: some View {
        ZStack {
            VStack {
                HStack{

                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Custom Back Icon
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                    
                }
                
                    Spacer()
            
                    
                    Button(action: {
                       
                            isSharing = true
                        loadImageForSharing(from: imageURL)
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .bold()
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 70)
//                                .offset(x: -10, y: -15)
//                                .padding(.top, 70)
                        }
                    
                
                }.padding(.top, 10)
                    .padding([.leading, .trailing], 20) // This ensures the HStack fills the width and places content at the top

                .sheet(isPresented: $isSharing, onDismiss: {
                    // You can perform any actions you need when the sheet is dismissed
                    isSharing = false
                    shareImage = nil
                }, content: {
                    // Convert the URL to a UIImage if possible and present it in an ActivityViewController
                    if let uiImage = shareImage {
                            ActivityViewController(activityItems: [uiImage])
                        }
                })
                /*.frame(maxWidth: .infinity, alignment: .leading)*/ // Ensures the HStack takes full width
                //Spacer()
                
                ZStack{
                    KFImage(imageURL)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                        .cornerRadius(20)
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                        }
                        .padding()

                Text(prompt)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                
                Spacer()
                
                HStack(spacing: 20) {
                                    Button(action: {
                                        
                                        UIPasteboard.general.string = prompt
                                        displayMessage("Prompt copied to clipboard.", color: .blue)
                                    }) {
                                        Label("Satın Al", systemImage: "dollarsign")
                                    }
                                    .buttonStyle(ActionButtonStyle(backgroundColor: Color.blue))
                                    
                                    
                                    .padding()
                                }
                            }

                                                   // Message overlay
                                                   if showMessage {
                                                       messageOverlay
                                                           .transition(.move(edge: .bottom).combined(with: .opacity))
                                                           .animation(.easeOut(duration: 2.5), value: showMessage)
                                                          
                                                           .onAppear {
                                                               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                   showMessage = false
                                                               }
                                                           }
                                                   }
                                               }
                                               .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3D2C8D"), Color(hex: "#916BBF")]), startPoint: .top, endPoint: .bottom))
                                               .edgesIgnoringSafeArea(.all)
                                           }

                           private var messageOverlay: some View {
                               Text(messageText)
                                   .bold()
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(messageColor)
                                   .cornerRadius(10)
                                   .shadow(radius: 10)
                                   .padding(.horizontal)
                                   .frame(maxWidth: .infinity)
                                   .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
                           }

    
    private func loadImageForSharing(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.shareImage = image
                    self.isSharing = true // Present the share sheet once the image is loaded
                }
            } else {
                // Handle the error scenario, perhaps show an alert to the user
                print("Error loading image for sharing: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    

    
    
    
        private func displayMessage(_ text: String, color: Color) {
            messageText = text
            messageColor = color
            showMessage = true
        }
    }

struct AnimatedStrokeShape: Shape {
    var start: CGFloat
    var end: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(start, end) }
        set {
            start = newValue.first
            end = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        // Your custom shape path
        var path = Path()
        path.addRect(rect)
        return path
    }
}


//#Preview {
//    GalleryView()
//}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update currently needed
    }
}

struct ActionButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
            .shadow(radius: 5)
    }
}

struct SaveB: View {
    @Binding var save: Bool
    var body: some View {
        Image(systemName: "arrow.down").foregroundStyle(.white).bold()
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .overlay{
                RoundedRectangle(cornerRadius: 10).trim(from: 0,to: save ? 1:0)
                    .stroke(lineWidth: 3)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5),value: save)
                    .foregroundStyle(.green)
            }
    }
}






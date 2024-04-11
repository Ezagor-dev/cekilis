import SwiftUI
import Kingfisher

struct CustomTabBar: View {
    @Binding var selectedTab: String
    
    var body: some View {
        ZStack {
            // Curved shape
            HStack {
                Spacer()
            }
            .frame(height: 88) // Match the height of your tab bar content
            .background(Color.purple)
            .cornerRadius(40)
            .overlay(
                HStack(spacing: 0) {
                    // Home Button
                    Button(action: {
                        selectedTab = "home"
                    }) {
                        Image(systemName: "house")
                            .font(.title2)
                            .foregroundColor(selectedTab == "home" ? .white : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    // Live Button
                    Button(action: {
                        selectedTab = "live"
                    }) {
                        Text("CANLI")
                            .font(.caption)
                            .foregroundColor(selectedTab == "live" ? .white : .gray)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Shopping or Bag Button
                    Button(action: {
                        selectedTab = "bag"
                    }) {
                        Image(systemName: "bag")
                            .font(.title2)
                            .foregroundColor(selectedTab == "bag" ? .white : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Profile Button with Notification Badge
                    Button(action: {
                        selectedTab = "person"
                    }) {
                        Image(systemName: "person")
                            .font(.title2)
                            .foregroundColor(selectedTab == "person" ? .white : .gray)
                            .overlay(
                                // Notification badge
                                Text("2")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -10),
                                alignment: .topTrailing
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                    .padding(.horizontal)
            )
        }
    }
}

// Custom curve shape
struct CustomCurveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height: CGFloat = rect.height
        let width: CGFloat = rect.width
        let midWidth = width / 2
        
        // Create a curve from left to right
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: midWidth - 60, y: height))
        path.addQuadCurve(to: CGPoint(x: midWidth + 60, y: height),
                          control: CGPoint(x: midWidth, y: height - 40))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}

// Usage in ContentView
struct ContentView: View {
    @State private var showingSettings = false
    @StateObject var sheetManager = SheetManager()
    @StateObject var sheetManagerTicket = SheetManagerTickets()
    @State private var selectedCategory: String = "araba"
    @State private var animateGradient = false
    @State private var isImageLoaded = false
    @State private var selectedTab: String = "home"
    let categories = ["araba", "beyazEsya", "telefon", "oyunBilgisayari", "televizyon", "tablet", "hoverboard", "karavan"]
    let categoryImages: [String: String] = [
        "araba": "araba",
        "beyazEsya": "beyazEsya",
        "telefon": "telefon",
        "oyunBilgisayari": "oyunBilgisayari",
        "televizyon": "televizyon",
        "tablet": "tablet",
        "hoverboard": "hoverboard",
        "karavan": "karavan"
        // Add the rest of your category image names here
    ]
    @ObservedObject private var viewModel = ArtworksViewModel()
    @ObservedObject private var viewModelTicket = TicketsViewModel()
    
    var filteredArtworks: [Artwork] {
        selectedCategory == "araba" ? viewModel.artworks : viewModel.artworks.filter { $0.category == selectedCategory }
    }
    var filteredTickets: [Tickets] {
        selectedCategory == "araba" ? viewModelTicket.tickets : viewModelTicket.tickets.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                
                ZStack {
                    
                    // Dynamic gradient background
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "#6D5BBA"), Color(hex: "#5A189A"), Color(hex: "#9D4EDD"), Color(hex: "#C77DFF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .animation(
                            Animation.easeInOut(duration: 5)
                                .repeatForever(autoreverses: true),
                            value: animateGradient
                        )
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ScrollView {
                            topLogoBar(showingSettings: $showingSettings)
                                .padding(.top, geometry.safeAreaInsets.top)
                            
                            // Category Bar
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) { // Adjusted spacing to match the provided code
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
                                                image: Image(uiImage: image)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Tickets Grid
                            
                                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                                    ForEach(filteredTickets) { ticket in
                                        TicketView(ticket: ticket)
                                            .frame(width: geometry.size.width, height: 200)
                                            .position(x: geometry.size.width / 2.2, y: geometry.size.height / 5)
                                        Spacer()
                                    }
                                }
                                
                                .padding(.horizontal)
                                .padding(.vertical)
                            Spacer()
                            
                        }
                        
                        Spacer()
                        
                        CustomTabBar(selectedTab: $selectedTab)
                            .frame(width: geometry.size.width, height: 88)
                    }
                    NavigationLink(destination: SettingsView(), isActive: $showingSettings) {
                        EmptyView()
                    }
                    .hidden()
                }
                .navigationBarBackButtonHidden(true)
                .onAppear() {
                    viewModelTicket.fetchTickets()
                    animateGradient.toggle()
                }
                .fullScreenCover(isPresented: $sheetManagerTicket.showingDetail) {
                    if let selectedDescription = sheetManagerTicket.selectedDescription,
                       let imageURLString = sheetManagerTicket.selectedImageURL,
                       let imageURL = URL(string: imageURLString) {
                        ImageDetailViewPromptLastTickets(description: selectedDescription, imageURL: imageURL)
                    } else {
                        Text("No image selected or image failed to load.")
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Separated top logo bar for better readability
func topLogoBar(showingSettings: Binding<Bool>) -> some View {
    HStack {
        // Left top logo
        Image("luckylogo") // Replace with actual image asset name
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .padding(.leading)
        
        Spacer()
        
        // Center top logo
        Image("logoSansli") // Replace with actual image asset name
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 100)
        
        Spacer()
        
        // Right top settings icon
        Button(action: {
            showingSettings.wrappedValue = true
            // Define the action for settings button here
        }) {
            Image(systemName: "gear")
                .font(.title)
                .foregroundColor(.black)
        }
        .padding(.trailing)
    }.background(
        NavigationLink(destination: SettingsView(), isActive: showingSettings) {
            EmptyView()
        }
            .hidden()
    )
}


// Don't forget to define CategoryItem and any other custom views that you are using.




#Preview {
    ContentView()
}

import SwiftUI
import Kingfisher

struct CustomTabBar: View {
    @Binding var selectedTab: String
    @StateObject var cartViewModel = CartViewModel()
    @State private var showingCart = false
    @State private var showingSettings = false
    var body: some View {
        ZStack {
            // Curved shape
            HStack {
                Spacer()
            }
            .frame(height: 90) // Match the height of your tab bar content
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
                        self.showingCart = true
                    }) {
                        Image(systemName: "bag")
                            .font(.title2)
                            .foregroundColor(selectedTab == "bag" ? .white : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .fullScreenCover(isPresented: $showingCart) {
                                CartView(cartViewModel: cartViewModel, isPresented: $showingCart)
                            }
                    
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
    @StateObject var cartViewModel = CartViewModel()
    @State private var showingCart = false
    @State private var isTabBarVisible: Bool = true
    
    
    @State private var showingSettings = false
    @StateObject var sheetManager = SheetManager()
    @StateObject var sheetManagerTicket = SheetManagerTickets()
    @State private var selectedCategory: String = "araba"
    @State private var animateGradient = false
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
    ]
    @ObservedObject private var viewModelTicket = TicketsViewModel()
    
    var checkoutView: some View {
        VStack {
            Spacer()
            VStack {
                HStack{
                VStack {
                    Button(action: {
                        // Toggle the view to show the tab bar when the 'X' button is clicked
                        withAnimation {
                            isTabBarVisible = true
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill") // 'X' mark icon
                            .foregroundColor(Color.gray) // Adjust color as needed
                            .imageScale(.large)
                            .padding(.trailing, 0) // Ensure it's not too close to the text
                    }
                    // Arrow down button for cart view
                    Button(action: {
                        self.showingCart = true
                        // Toggle to show cart view
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                            .padding(.top, 0) // Add some padding above the arrow
                    }
                    
                }
                    
                    VStack(alignment: .leading) {
                        Text("Ödenecek tutar")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(cartViewModel.totalPrice, specifier: "%.2f")₺")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // The action to proceed to payment should be here
                        self.showingCart = true
                    }) {
                        Text("Ödemeye git")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue) // Adjust to match your app's theme
                            .cornerRadius(20)
                    }
                    .fullScreenCover(isPresented: $showingCart) {
                                CartView(cartViewModel: cartViewModel, isPresented: $showingCart)
                            }
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 10)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                
            }
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .transition(.move(edge: .bottom))
        .animation(.easeOut, value: isTabBarVisible)
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
                                                image: Image(uiImage: image)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Tickets Grid
                            LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                                ForEach(viewModelTicket.tickets) { ticket in
                                    TicketView(isTabBarVisible: $isTabBarVisible, ticket: ticket)
                                        .environmentObject(cartViewModel)
                                        .frame(width: geometry.size.width, height: 200)
                                        .position(x: geometry.size.width / 2.2, y: geometry.size.height / 5)
                                }
                                .padding(.horizontal)
                                .padding(.vertical)
                            }
                            Spacer()
                        }
                        
                        if isTabBarVisible {
                            CustomTabBar(selectedTab: $selectedTab)
                                .frame(width: geometry.size.width, height: 88)
                        } else {
                            checkoutView
                                .frame(width: geometry.size.width, height: 88)
                                .background(Color.white)
                        }
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
            }.navigationBarBackButtonHidden()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func topLogoBar(showingSettings: Binding<Bool>) -> some View {
        HStack {
            Image("luckylogo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            Spacer()
            
            Image("logoSansli")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
            
            Spacer()
            
            Button(action: {
                showingSettings.wrappedValue = true
            }) {
                Image(systemName: "gear")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .padding(.trailing)
            .fullScreenCover(isPresented: showingSettings) {
                        // The view you want to present goes here
                        SettingsView() // Replace with your actual settings view
                    }
        }
    }
}


// Don't forget to define CategoryItem and any other custom views that you are using.

class CartViewModel: ObservableObject {
    @Published var totalPrice: Double = 0.0
    @Published var selectedTickets: [TicketSelection] = []
    @Published var savedCards: [CreditCard] = []
   
    
    
    func addTicketToCart(ticket: Tickets, multiplier: Int) {
            if let index = selectedTickets.firstIndex(where: { $0.ticket.id == ticket.id }) {
                // Update the existing ticket multiplier
                selectedTickets[index].multiplier += multiplier
            } else {
                // Add a new ticket selection
                let newSelection = TicketSelection(id: UUID().uuidString, ticket: ticket, multiplier: multiplier)
                selectedTickets.append(newSelection)
            }
            updateTotalPrice()
        }

    private func updateTotalPrice() {
        totalPrice = selectedTickets.reduce(0) { $0 + ($1.ticket.ticketPrice * Double($1.multiplier)) }
    }
    func updateMultiplier(for ticket: Tickets, to multiplier: Int) {
            if let index = selectedTickets.firstIndex(where: { $0.ticket.id == ticket.id }) {
                selectedTickets[index].multiplier = multiplier
            } else {
                // If the ticket isn't already in the cart, add it with the new multiplier
                addTicketToCart(ticket: ticket, multiplier: multiplier)
            }
            updateTotalPrice()
        }
    
}

//struct TicketSelection {
//    var ticket: Tickets
//    var multiplier: Int
//}



#Preview {
    ContentView()
}

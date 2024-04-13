//
//  TicketView.swift
//  cekilis
//
//  Created by Ezagor on 10.04.2024.
//
import SwiftUI

struct TicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let notchWidth: CGFloat = 30.0
        let notchHeight: CGFloat = 20.0
        let cornerRadius: CGFloat = 10.0

        // Start from the top left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // Top left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        // Top edge with notch
        path.addLine(to: CGPoint(x: rect.midX - notchWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + notchHeight))
        path.addLine(to: CGPoint(x: rect.midX + notchWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // Top right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        // Bottom edge with notch
        path.addLine(to: CGPoint(x: rect.midX + notchWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - notchHeight))
        path.addLine(to: CGPoint(x: rect.midX - notchWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        // Bottom left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        // Close the path
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        return path
    }
}


// .rotationEffect(.degrees(90))
struct TicketView: View {
    
    @Binding var isTabBarVisible: Bool
    @EnvironmentObject var cartViewModel: CartViewModel
    var ticket: Tickets
    @State private var showMultipliers = false
    @State private var showPurchaseButton = true
    @State private var selectedMultiplier: Int = 1
    @ObservedObject private var viewModelTicket = TicketsViewModel()
    var body: some View {
        let raffleDate = parseDateString(dateString: ticket.raffleDateString)
        let daysUntilRaffle = daysBetween(start: Date(), end: raffleDate)
        ZStack {
            TicketShape()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 390, height: 200)
                .shadow(radius: 10)
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 7) {
                            HStack{
                                
                                Text("Çekilişe son:")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                
                                Text("\(daysUntilRaffle) Gün")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.white)
                                
                            }
                            AsyncImage(url: URL(string: ticket.imageURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Color.gray
                                }
                            }
                            .frame(width: 100, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            VStack{
                                Text("Ödülün yaklaşık değeri:")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Text("\(ticket.prizeValue)₺")
                                        .font(.system(size: 9))
                                        .foregroundColor(.white)
                                        .bold()
                                    Spacer()
                                    Text("\(ticket.prizeCount) Ödül")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                    //                                        .padding(.leading)
                                }.padding(.top, 10)
                            }
                        }
                        .padding(.leading, 10)
                        
                        DashedSeparator()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .frame(height: 100)
                            .padding(.horizontal,10)
                            .rotationEffect(.degrees(90))
                        Spacer()
                        
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            
                            Text("\(ticket.titleTicket)")
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 10))
                            
                                .lineLimit(4)
                            
                            HStack{
                                Spacer()
                                Text("Çekiliş tarihi:")
                                    .foregroundColor(.black.opacity(0.6))
                                    .font(.system(size: 10))
                                
                                Text("\(ticket.raffleDateString)")
                                    .foregroundColor(.black.opacity(0.6))
                                    .font(.system(size: 10))
                            }
                            
                            
                            let kalanBilet = Double(ticket.totalTicket) - Double(ticket.purchaseCount)
                            let yuzdeBilet = ((kalanBilet / Double(ticket.totalTicket))*100)
                            
                            
                            
                            
                            Text("Kalan Bilet: \(yuzdeBilet, specifier: "%.2f")%")
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 10))
                            
                            Text("\(ticket.ticketPrice, specifier: "%.2f")₺")
                                .foregroundColor(.black.opacity(0.6))
                                .font(.system(size: 16))
                                .bold()
                            
                            // Multiplier toggle button and selection view
                            // Button section
                            
                            HStack {
                                
                                if showPurchaseButton{
                                    purchaseButton
                                    multiplierButton
                                }else{
                                    multiplierSelectionView
                                }

                            }
                            .transition(.move(edge: .trailing)) // Use a transition for smoother appearance/disappearance
                                        .animation(.easeInOut, value: showMultipliers)
                        }
                        .frame(width: 115, alignment: .trailing)
                        
                        
                        
                                                    .padding(.trailing, 10) // Ensure padding is consistent
                    }
                )
        }
    }
    
    
    private func parseDateString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy" // Adjust the date format to the format of your raffleDateString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX locale to ensure consistency
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    }
    var purchaseButton: some View {
        Button(action: {
            withAnimation {
                        cartViewModel.addTicketToCart(ticket: ticket, multiplier: selectedMultiplier)
                        isTabBarVisible = false // This line toggles the visibility of the tab bar which might also control showing/hiding of the checkout view.
                    }
        }) {
            Text("Bilet al")
                .font(.system(size: 8))
                .foregroundColor(.white)
                .padding()
                .frame(height: 30)
                .background(Color.red)
                .cornerRadius(10)
                .bold()
        }
    }
    var multiplierButton: some View {
        Button(action: {
            // This should show the multipliers when there is no selection or reset the selection to 1
            showMultipliers = true
            showPurchaseButton = false
//            if selectedMultiplier == 1 {
//                showMultipliers = true
//            } else {
//                selectedMultiplier = 1
//            }
        }) {
            Text(selectedMultiplier == 1 ? "1X" : "\(selectedMultiplier)x")
                .font(.system(size: 8))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                .frame(height: 30)
                .background(Color.red)
                .cornerRadius(10)
                .bold()
        }
    }
    
    var multiplierSelectionView: some View {
        HStack(spacing: 8) {
            ForEach([1, 5, 10, 20], id: \.self) { multiplier in
                Button(action: {
                    selectedMultiplier = multiplier
                    showMultipliers = false
                    showPurchaseButton = true
                    // Trigger the action to purchase tickets with the selected multiplier
                    // viewModelTicket.purchaseTickets(multiplier: multiplier)
                }) {
                    Text("\(multiplier)x")
                        .font(.system(size: 7))
                        .foregroundColor(.white)
                        
                        .frame(height: 30)
                        .frame(width: 30)
                        
                        .background(Color.black)
                        .cornerRadius(10)
                        .bold()
//                        .font(.system(size: 8))
//                        .bold()
//                        .frame(height: 30)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.5))
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.white, lineWidth: 1)
//                        )
                }
            }
        }
    }
}

struct DashedSeparator: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}


struct TicketView_Previews: PreviewProvider {
    @State static var isTabBarVisible = true
    static var previews: some View {
        TicketView(isTabBarVisible: $isTabBarVisible, ticket: Tickets(id: "1",
                                                                      category: "Test Category",
                                                                      description: "This is a test description for our ticket.",
                                                                      imageURL: "https://example.com/image.png",
                                                                      isAvailable: true,
                                                                      isLive: true,
                                                                      prizeCount: 1,
                                                                      prizeValue: 232725,
                                                                      purchaseCount: 100,
                                                                      raffleDateString: "14.04.24",
                                                                      ticketPrice: 5,
                                                                      titleTicket: "Sample Ticket",
                                                                      totalTicket: 10000))
        .environmentObject(CartViewModel())
    }
}

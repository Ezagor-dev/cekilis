import SwiftUI
import Kingfisher



struct CartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @Binding var isPresented: Bool // Add this line

    var body: some View {
        VStack {
            // Header
            header
                .padding()

            ScrollView {
                // Ticket Items
                ForEach(cartViewModel.selectedTickets) { ticketSelection in
                    TicketCartItemView(ticketSelection: ticketSelection)
                        .padding(.horizontal)
                }

                // Payment Cards
                paymentCardsSection

                // Information Form
                informationFormSection

                // Checkout Summary
                checkoutSummarySection
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    // Header View
    var header: some View {
        HStack {
            Button(action: {
                // Action to go back
                self.isPresented = false
            }) {
                Image(systemName: "arrow.left")
            }
            Spacer()
            Text("Sepet")
                .font(.headline)
            
        }
    }

    // Payment Cards Section
    var paymentCardsSection: some View {
        VStack(alignment: .leading) {
            Text("Kayıtlı Kartlar")
                .font(.headline)
                .padding(.vertical)
            // Horizontal scroll view for cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(cartViewModel.savedCards) { card in
                        CreditCardView(card: card)
                    }
                    Button(action: {
                        // Action to add a new card
                    }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                            Text("Yeni Kart Ekle")
                                .font(.headline)
                        }
                        .frame(width: 150, height: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // Information Form Section
    var informationFormSection: some View {
        VStack(alignment: .leading) {
            Text("Ön bilgilendirme formu")
                .font(.headline)
                .padding(.vertical)
            Text("Çekiliş sistem numarası: 3709\nOyun Planı Numarası: 2024-115\nÖdüller: 1 Adet 232.500 TL değerinde Samsung 980Q8C 4K Ultra HD 98inç 245 Ekran Uydu Alıcılı Smart QLED TV")
                .padding(.bottom)
        }
        .padding(.horizontal)
        .background(Color.white)
    }

    // Checkout Summary Section
    var checkoutSummarySection: some View {
        VStack(alignment: .center) {
            Text("Ödenecek Toplam Tutar")
                .font(.headline)
            Text("\(cartViewModel.totalPrice, specifier: "%.2f")₺")
                .font(.title)
                .bold()
                .padding(.vertical)

            Button(action: {
                // Action to complete the purchase
            }) {
                Text("Ödemeyi Tamamla")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
    }
}

// Assuming TicketSelection has a Tickets model that includes an 'image' property
struct TicketCartItemView: View {
    var ticketSelection: TicketSelection

    var body: some View {
        HStack {
            KFImage(URL(string: ticketSelection.ticket.imageURL)) // Replace with actual image loading mechanism
                .resizable()
                .frame(width: 100, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(ticketSelection.ticket.titleTicket)
                    .font(.headline)
                Text(ticketSelection.ticket.description) // Replace with actual description property
                    .font(.subheadline)
            }

            Spacer()

            // Quantity adjuster
            HStack {
                Button(action: {
                    // Decrease ticket count
                }) {
                    Image(systemName: "minus.circle")
                }
                Text("\(ticketSelection.multiplier)")
                Button(action: {
                    // Increase ticket count
                }) {
                    Image(systemName: "plus.circle")
                }
            }

            Text("\(ticketSelection.ticket.ticketPrice * Double(ticketSelection.multiplier), specifier: "%.2f")₺")
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Dummy model structures
struct CreditCard: Identifiable {
    let id: String
    let lastFourDigits: String
    let expires: String
    let cardholderName: String
}

struct TicketSelection: Identifiable {
    let id: String
    var ticket: Tickets
    var multiplier: Int
}

struct CreditCardView: View {
    let card: CreditCard

    var body: some View {
        VStack {
            Text(card.cardholderName)
            Text("**** **** **** \(card.lastFourDigits)")
            Text(card.expires)
        }
        .frame(width: 150, height: 200)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

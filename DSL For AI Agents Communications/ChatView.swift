import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @State private var messageText = ""

    var body: some View {
        VStack {
            // Display messages in a scrollable view
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        ChatMessageView(message: message)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))

            Divider()

            HStack {
                Button(action: {
                    viewModel.speechToText()
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }

                
                TextField("Type your message here...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.send)
                    .onSubmit {
                        sendAndClear()
                    }
                Button(action: {
                    sendAndClear()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Chat", displayMode: .inline)
    }

    
    private func sendAndClear() {
        viewModel.sendText(messageText)
        messageText = "" // Clear the text field after sending
    }
}

// View for individual chat messages
struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            Text(message.text)
                .padding()
                .background(message.isFromUser ? Color.blue : Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
            if !message.isFromUser {
                Spacer()
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: message.text)
    }
}

struct ChatMessage: Identifiable {
    var id = UUID()
    var text: String
    var isFromUser: Bool
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

//
//  ChatView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @ObservedObject private var speechManager = SpeechToTextManager()
    @State private var messageText = ""

    var body: some View {
        VStack {
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
        .padding(10)
    }

    
    private func sendAndClear() {
        print("Input: " + messageText)
        viewModel.sendText(messageText)
        messageText = ""
        print("Processing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Processing.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Processing..")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("Processing...")
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

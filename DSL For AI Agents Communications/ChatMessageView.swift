//
//  ChatMessageView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 02.05.2024.
//

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            Group {
               if let imageUrl = message.imageUrl, let url = URL(string: imageUrl) {
                   AsyncImage(url: url) { phase in
                       if let image = phase.image {
                           image.resizable()
                                .aspectRatio(contentMode: .fit)
                       } else if phase.error != nil {
                           Text("An error occurred while loading the image.")
                       } else {
                           ProgressView()
                       }
                   }
                   .frame(width: 200, height: 200)
                   .cornerRadius(10)
               } else if let text = message.text {
                   Text(text)
                       .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                       .background(message.isFromUser ? Color.blue : Color.gray)
                       .cornerRadius(10)
                       .foregroundColor(.white)
               }
           }
            if !message.isFromUser && message.text != nil {
                Spacer()  
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: message.text ?? message.imageUrl ?? "")
    }
}


struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color.gray)
                    .opacity(animate ? 1.0 : 0.4)
                    .scaleEffect(animate ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
        .onDisappear {
            animate = false
        }
    }
}

struct ChatMessage_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            ChatMessageView(message: ChatMessage(text: "Yolo", isFromUser: true))
            Spacer()
            ChatMessageView(message: ChatMessage(text: "Yolo", isFromUser: false))
            Spacer()
        }
    }
}

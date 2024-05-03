//
//  SelectionView.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI

struct SelectionView: View {
    var body: some View {
            NavigationView {
                VStack {
                    Spacer()
                    Text("Select the preffered Image Wizard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 100)
                    NavigationLink(destination: TextToImage()) {
                        Text("Text to Image")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    NavigationLink(destination: ImageToText()) {
                        Text("Image to Text")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }
                    .padding()
                    Spacer()
                }
            }
        }
}

#Preview {
    SelectionView()
}

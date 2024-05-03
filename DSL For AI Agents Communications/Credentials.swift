//
//  Credentials.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI

import SwiftUI

struct CreditsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Credits")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Team Members:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Mindrescu Dragomir")
                    .fontWeight(.medium)
                Text("Comarov Maxim")
                    .fontWeight(.medium)
                Text("Grigoras Dumitru")
                    .fontWeight(.medium)
                Text("Cusnir Grigore")
                    .fontWeight(.medium)
                Text("Perlog Boris")
                    .fontWeight(.medium)
                
                Text("This project, a comprehensive application of modern AI technologies, integrates several advanced features designed to enhance user interaction through natural language processing and multimedia analysis.")
                
                Text("AI Chat: The core of our application is the AI Chat, which leverages cutting-edge natural language processing algorithms to understand and respond to user queries intelligently. This feature is built on a robust framework that analyzes input text, interprets user intentions, and generates relevant, conversational responses. This AI-driven interaction enables a dynamic and engaging user experience, simulating a real-life conversation.")
                
                Text("Speech to Text Transcriber: An essential component of our project is the Speech to Text Transcriber. This functionality allows users to convert their spoken words into written text seamlessly. By using advanced speech recognition technology, the transcriber accurately captures and converts speech in real-time, facilitating an efficient way for users to interact with the application without the need for manual text entry.")
                
                Text("Speech to Speech Assistant: Expanding on voice technology, our Speech to Speech Assistant enhances user interaction by not only recognizing spoken commands but also responding verbally. This feature employs sophisticated text-to-speech technology, enabling the application to communicate with users audibly. It is particularly beneficial for hands-free operations and offers an inclusive user experience, accommodating different user needs and preferences.")
                
                Text("Image Analyzer: Lastly, the Image Analyzer adds a visual dimension to our application. This tool utilizes advanced image recognition technologies to analyze and interpret images provided by users. Whether identifying objects, analyzing scenes, or extracting text, the Image Analyzer provides insightful feedback and enriches the overall functionality of the project by integrating visual data processing capabilities.")
                
                Text("Together, these technologies combine to create a versatile and user-friendly platform, showcasing the practical application of AI in enhancing digital interactions and making technology more accessible and effective for a broad audience.")
            }
            .padding()
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}

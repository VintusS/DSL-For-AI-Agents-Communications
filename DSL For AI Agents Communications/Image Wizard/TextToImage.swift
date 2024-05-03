//
//  TextToImage.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI

// Model for the input-output data
struct InputOutputData: Codable, Identifiable {
    var id = UUID()
    let input: String
    let output: String
}

// ViewModel that handles the logic
class ImageFetcher: ObservableObject {
    @Published var imageUrl: URL?
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    private var dataSet: [InputOutputData] = []
    
    init() {
        loadJson()
    }
    
    func loadJson() {
        let jsonString = """
        [
            {
                "input": "test",
                "output": "https://photographylife.com/wp-content/uploads/2017/03/How-to-find-beautiful-landscapes-4.jpg"
            },
            {
                "input": "Find an image of a cute kitten.",
                "output": "https://i.pinimg.com/564x/2d/4a/fd/2d4afd41d465c1d42a589c2fe6ba961b.jpg"
            }
        ]
        """
        if let data = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode([InputOutputData].self, from: data) {
                dataSet = jsonData
            }
        }
    }
    
    func fetchImage(for inputText: String) {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        print("Searching for: '\(trimmedText)'")  // Debugging output
        
        if let match = dataSet.first(where: { $0.input.lowercased() == trimmedText }) {
            print("Match found: \(match.input)")  // Confirm match
            self.imageUrl = URL(string: match.output)
            self.message = ""
        } else {
            print("No match found")  // Confirm no match
            self.imageUrl = nil
            self.message = "Prompt not found"
        }
        self.showMessage = true
    }


}

struct TextToImage: View {
    @State private var inputText: String = ""
    @ObservedObject var imageFetcher = ImageFetcher()
    
    var body: some View {
        VStack {
            TextField("Enter search term", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search") {
                imageFetcher.fetchImage(for: inputText)
            }
            .padding()
        }
        .sheet(isPresented: $imageFetcher.showMessage) {
            if let imageUrl = imageFetcher.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(maxHeight: 300)
                .padding()
                .overlay(
                    Button("Close") {
                        imageFetcher.showMessage = false
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    , alignment: .topTrailing
                )
            } else {
                Text(imageFetcher.message)
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .overlay(
                        Button("Close") {
                            imageFetcher.showMessage = false
                        }
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        , alignment: .topTrailing
                    )
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
}


#Preview {
    TextToImage()
}

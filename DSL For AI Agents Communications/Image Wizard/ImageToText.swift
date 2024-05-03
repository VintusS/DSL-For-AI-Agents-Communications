//
//  ImageToText.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI

class ImageToTextViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var imageDescription: String?

    private var descriptions: [String] = [
        "Description for first image",
        "Description for second image",
        "Description for third image",
        "Description for fourth image",
        "Description for fifth image"
    ]

    func updateDescription() {
        if !descriptions.isEmpty {
            imageDescription = descriptions.removeFirst()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        var onImagePicked: () -> Void

        init(_ parent: ImagePicker, onImagePicked: @escaping () -> Void) {
            self.parent = parent
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                onImagePicked()
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct ImageToText: View {
    @StateObject private var viewModel = ImageToTextViewModel()
    @State private var isImagePickerPresented = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoadingDescription = false

    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .padding()
                    .scaledToFit()
                
                if isLoadingDescription {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
                
                if let description = viewModel.imageDescription {
                    Text(description)
                        .padding()
                        .opacity(isLoadingDescription ? 0 : 1)
                        .animation(.easeInOut(duration: 1), value: isLoadingDescription)
                }
            } else {
                
                VStack {
                    Spacer()
                    
                    Text("Choose an image and I'll try to describe it")
                        .font(.largeTitle)
                        .padding()
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    Text("Tap to select an image")
                        .foregroundColor(.gray)
                    Spacer()
                    Spacer()
                }
            }
        }
        .onTapGesture {
            isImagePickerPresented = true
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage) {
                viewModel.updateDescription()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ImageToText()
}

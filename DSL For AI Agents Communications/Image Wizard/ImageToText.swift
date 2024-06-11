//
//  ImageToText.swift
//  DSL For AI Agents Communications
//
//  Created by Dragomir Mindrescu on 03.05.2024.
//

import SwiftUI

class ImageToTextViewModel: ObservableObject {
    @Published var selectedImage: UIImage? {
        didSet {
            print("ViewModel: selectedImage set")
        }
    }
    @Published var imageDescription: String? {
        didSet {
            print("ViewModel: imageDescription set to \(imageDescription ?? "nil")")
        }
    }

    private var descriptions: [String] = ["Description for image 1", "Description for image 2", "Description for image 3"]

    func updateDescription() {
        print("ViewModel: updateDescription called")
        if !descriptions.isEmpty {
            imageDescription = descriptions.removeFirst()
            print("ViewModel: imageDescription updated to \(imageDescription ?? "nil")")
        } else {
            imageDescription = "No more descriptions available."
            print("ViewModel: No more descriptions available")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        print("ImagePicker: makeUIViewController called")
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
                print("ImagePicker: image picked")
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
    @State private var showDescription = false

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
                
                if showDescription, let description = viewModel.imageDescription {
                    Text(description)
                        .padding()
                        .opacity(isLoadingDescription ? 0 : 1)
                        .animation(.easeInOut(duration: 1), value: isLoadingDescription)
                }
            } else {
                VStack {
                    Spacer()
                    
                    Text("Upload an image and I'll describe it")
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
            print("ImageToText: Image picker presented")
            isImagePickerPresented = true
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage) {
                print("ImageToText: Image picked, updating description")
                isLoadingDescription = true
                showDescription = false
                viewModel.updateDescription()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    print("ImageToText: Description loaded")
                    isLoadingDescription = false
                    showDescription = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("ImageToText: View appeared")
        }
        .onDisappear {
            print("ImageToText: View disappeared")
        }
    }
}

struct ImageToText_Previews: PreviewProvider {
    static var previews: some View {
        ImageToText()
    }
}

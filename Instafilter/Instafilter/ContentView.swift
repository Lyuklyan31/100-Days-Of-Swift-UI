//
//  ContentView.swift
//  Instafilter
//
//  Created by admin on 19.03.2024.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

//MARK: ContentUnavailableView
struct ContentUnavailableView: View {
    let title: String
    let systemImage: String
    let description: String
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.largeTitle)
            Text(title)
                .font(.title)
            Text(description)
                .font(.body)
                .padding()
        }
        .multilineTextAlignment(.center)
    }
}

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensinty = 0.5
    @State private var radiusIntensinty = 0.5
    @State private var scaleIntensinty = 0.5
    @State private var selectedItem: PhotosPickerItem?
    var disableForm: Bool {
        selectedItem == nil//new
    }
    
    @State private var showingFilters = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    @AppStorage("filterCount") var filtercount = 0
    @Environment(\.requestReview) var requestReview
    var context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView(title: "No Picture", systemImage: "photo.badge.plus", description: "Tap to import a photo")
                    }
                }
                .onChange(of: selectedItem) { newValue in
                    loadImage()
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                if let processedImage {
                    ShareLink(item: processedImage, preview: SharePreview("InstaFilter image", image: processedImage))
                }
                
                HStack {
                    VStack{
                        HStack{
                            Text("Radius   ")
                            Slider(value: $radiusIntensinty)
                                .disabled(disableForm)//new
                                .onChange(of: radiusIntensinty) { newValue in
                                    applyProcessing()
                                }
                        }
                        
                        HStack{
                            Text("Scale     ")
                            Slider(value: $scaleIntensinty)
                                .disabled(disableForm)//new
                                .onChange(of: scaleIntensinty) { newValue in
                                    applyProcessing()
                                }
                                
                        }
                        
                        HStack {
                            Text("Intensity")
                            Slider(value: $filterIntensinty)
                                .disabled(disableForm)//new
                                .onChange(of: filterIntensinty) { newValue in
                                    applyProcessing()
                                }
                        }
                    }
                    
                }
                .padding(.vertical)
               
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(disableForm) //new
                    Spacer()
                    
                    
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystalize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { CIFilter.edges() }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Cmyk Halftone") { setFilter(CIFilter.cmykHalftone()) }
                Button("Darken Blend Mode") { setFilter(CIFilter.darkenBlendMode()) }
                Button("Cancel", role: .cancel) { }
            }
        }
        
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensinty, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radiusIntensinty * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scaleIntensinty * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filtercount += 1
        
        if filtercount >= 30 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}



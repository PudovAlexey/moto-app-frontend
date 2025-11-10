import SwiftUI
import PhotosUI
import AVFoundation
import Photos

struct CameraView: View {
    let session: AVCaptureSession
    var showRedCircle: Bool = true
    
    var body: some View {
        ZStack {
            // Камера
            CameraPreviewView(session: session)
                .cornerRadius(8)
            
            // Красный кружок
            if showRedCircle {
                Circle()
                    .fill(.red)
                    .frame(width: 20, height: 20)
            }
        }
    }
}


struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.cornerRadius = 8
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}

struct ActiveCameraCellView: View {
    let session: AVCaptureSession
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: session)
                .frame(height: 80)
                .cornerRadius(8)
                .clipped()
            
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: 50, height: 50)
            
            Image(systemName: "camera.fill")
                .font(.title2)
                .foregroundColor(.white)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

struct GalleryImageView: View {
    let asset: PHAsset
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 80)
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                            .tint(.white)
                    )
            }
        }
        .onAppear {
            loadImageFromAsset()
        }
    }
    
    private func loadImageFromAsset() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            DispatchQueue.main.async {
                self.image = result
            }
        }
    }
}

struct RealImageView: View {
    let image: UIImage
    let onDelete: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 80)
                .clipped()
                .cornerRadius(8)
            
            if onDelete != nil {
                Button(action: {
                    onDelete?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}

struct AttachBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImages: [UIImage] = []
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var cameraSession: AVCaptureSession?
    @State private var showCameraAlert = false
    @State private var cameraError: String?
    
    // Галерея фото
    @State private var galleryAssets: [PHAsset] = []
    @State private var showGalleryAlert = false
    @State private var galleryError: String?
    @State private var isLoadingGallery = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Основной контент
                VStack(spacing: 0) {
                    // Заголовок
                    HStack {
                        Text("Выберите изображение")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(selectedImages.count)/10")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Грид сетка
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            // СЕКЦИЯ 1: Активная камера
                            if let session = cameraSession {
                                ActiveCameraCellView(session: session)
                                    .onTapGesture {
                                        takePhoto()
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 80)
                                    .cornerRadius(8)
                                    .overlay(
                                        ProgressView()
                                            .tint(.white)
                                    )
                                    .onAppear {
                                        setupCamera()
                                    }
                            }
                            
                            // СЕКЦИЯ 2: Выбранные фото
                            ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                RealImageView(image: image) {
                                    deleteImage(at: index)
                                }
                            }
                            
                            // СЕКЦИЯ 3: ВСЯ ГАЛЕРЕЯ фото с устройства
                            ForEach(galleryAssets, id: \.localIdentifier) { asset in
                                GalleryImageView(asset: asset)
                                    .onTapGesture {
                                        selectImageFromGallery(asset: asset)
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    // Индикатор загрузки галереи
                    if isLoadingGallery {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Загрузка галереи...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                
                // Кнопки внизу
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: 12) {
                        Button("Отмена") {
                            stopCamera()
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("Фото в галерее: \(galleryAssets.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Ошибка камеры", isPresented: $showCameraAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(cameraError ?? "Неизвестная ошибка")
        }
        .alert("Ошибка галереи", isPresented: $showGalleryAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(galleryError ?? "Неизвестная ошибка")
        }
        .onAppear {
            loadAllGalleryPhotos()
        }
        .onChange(of: photoItems) { _, newItems in
            loadImages(from: newItems)
        }
        .onDisappear {
            stopCamera()
        }
    }
    
    // MARK: - Camera Methods
    
    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            requestCameraPermission()
            return
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) ??
                AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            showCameraError("Камера не доступна на этом устройстве")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
            
            DispatchQueue.main.async {
                self.cameraSession = session
            }
            
        } catch {
            showCameraError("Ошибка настройки камеры: \(error.localizedDescription)")
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.setupCamera()
                } else {
                    self.showCameraError("Доступ к камере запрещен. Разрешите доступ в настройках.")
                }
            }
        }
    }
    
    private func takePhoto() {
        guard let session = cameraSession else { return }
        
        let output = AVCapturePhotoOutput()
        guard session.canAddOutput(output) else {
            showCameraError("Не удалось настроить вывод фото")
            return
        }
        
        session.beginConfiguration()
        session.addOutput(output)
        session.commitConfiguration()
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        output.capturePhoto(with: settings, delegate: PhotoCaptureDelegate { image in
            if let image = image {
                DispatchQueue.main.async {
                    if self.selectedImages.count < 10 {
                        self.selectedImages.append(image)
                    }
                }
            }
        })
    }
    
    private func stopCamera() {
        cameraSession?.stopRunning()
        cameraSession = nil
    }
    
    private func showCameraError(_ message: String) {
        cameraError = message
        showCameraAlert = true
    }
    
    // MARK: - Gallery Methods
    
    private func loadAllGalleryPhotos() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            fetchAllGalleryPhotos()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.fetchAllGalleryPhotos()
                    } else {
                        self.showGalleryError("Доступ к галерее запрещен. Разрешите доступ в настройках.")
                    }
                }
            }
        case .denied, .restricted:
            showGalleryError("Доступ к галерее запрещен. Разрешите доступ в настройках.")
        @unknown default:
            break
        }
    }
    
    private func fetchAllGalleryPhotos() {
        isLoadingGallery = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            // УБИРАЕМ fetchLimit - загружаем ВСЕ фото!
            
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var galleryAssets: [PHAsset] = []
            assets.enumerateObjects { asset, _, _ in
                galleryAssets.append(asset)
            }
            
            DispatchQueue.main.async {
                self.galleryAssets = galleryAssets
                self.isLoadingGallery = false
                print("Загружено фото из галереи: \(galleryAssets.count)")
            }
        }
    }
    
    private func selectImageFromGallery(asset: PHAsset) {
        guard selectedImages.count < 10 else { return }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 1024, height: 1024),
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.selectedImages.append(image)
                }
            }
        }
    }
    
    private func showGalleryError(_ message: String) {
        galleryError = message
        showGalleryAlert = true
        isLoadingGallery = false
    }
    
    // MARK: - Image Methods
    
    private func loadImages(from items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }
        
        Task {
            var loadedImages: [UIImage] = []
            
            for item in items {
                do {
                    if let data = try await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            loadedImages.append(image)
                        }
                    }
                } catch {
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
            
            await MainActor.run {
                let availableSlots = 10 - selectedImages.count
                let imagesToAdd = Array(loadedImages.prefix(availableSlots))
                selectedImages.append(contentsOf: imagesToAdd)
                photoItems.removeAll()
            }
        }
    }
    
    private func deleteImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
}

// MARK: - Photo Capture Delegate

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Ошибка захвата фото: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            completion(nil)
            return
        }
        
        completion(image)
    }
}

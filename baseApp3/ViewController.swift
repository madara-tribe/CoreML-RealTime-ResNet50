import UIKit
import AVFoundation
import Vision
import SwiftUI

final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var uiimage: UIImage?
    public var text0:UILabel = UILabel()
    public var text1:UILabel = UILabel()
    var detecting:Bool = false
    
    let captureSession = AVCaptureSession()
    let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var backCamera: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startCapture()
        
        let fontsize:CGFloat = 20
        // Text bg
        self.text0.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
        self.text0.numberOfLines = 0
        self.text0.layer.cornerRadius = 4
        self.text0.clipsToBounds = true
        self.view.addSubview(self.text0)

        // Text
        self.text1.textColor = UIColor.green
        self.text1.font = UIFont.systemFont(ofSize:fontsize)
        self.text1.numberOfLines = 0
        self.view.addSubview(self.text1)

        self.setPosition()
    }
    
    private func calcurateTime(stime:Date)-> String{
        let timeInterval = Date().timeIntervalSince(stime)
        let predtime = String((timeInterval * 100) / 100) + "[ms]"
        return  predtime
    }
    
    private func startCapture() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else { return }
        guard captureSession.canAddInput(input) else { return }
        captureSession.addInput(input)
        
        // 出力の設定
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        guard captureSession.canAddOutput(output) else { return }
        captureSession.addOutput(output)
        
        // プレビューの設定
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.insertSublayer(previewLayer, at: 0)
        // キャプチャー開始
        captureSession.startRunning()
    }
    func stopCapture() {
        captureSession.stopRunning()
    }
    private func setPosition() {
        self.text0.frame = CGRect.init(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.text1.frame = self.text0.frame.offsetBy(dx: 8.0, dy: 0)

    }
    private func UIImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            let context = CIContext()
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image)
            }
        }
        return nil
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if (self.detecting == false) {
            self.detecting = true
            uiimage = self.UIImageFromSampleBuffer(sampleBuffer)
            let start_time = Date()
            DispatchQueue(label:"detecting.queue").async {
                var s:String = self.calcurateTime(stime:start_time)//"PX1 testing"
                DispatchQueue.main.async {
                    self.text1.text = "PX1 testing: " + s
                }
                usleep(500*1000) // ms
                self.detecting = false
            }
        }
    }
}


extension CameraViewController : UIViewControllerRepresentable{
    public typealias UIViewControllerType = CameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController()
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
    }
}


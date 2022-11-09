import AVFoundation
import Vision
import SwiftUI

final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    public var obsLabel:UILabel = UILabel()
    public var text:UILabel = UILabel()
    public var predtime:UILabel = UILabel()
    
    let fontsize:CGFloat = 20
    var ciimage: CIImage?
    var detecting:Bool = false
    var stime:Date!
    
    let captureSession = AVCaptureSession()
    let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var backCamera: AVCaptureDevice?
    
    private let resnet50ModelManager = Resnet50ModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resnet50ModelManager.delegate = self
        self.setTexts()
        self.startCapture()
    }
    
    private func startCapture() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else { return }
        guard captureSession.canAddInput(input) else { return }
        captureSession.addInput(input)
        
        // set output
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        guard captureSession.canAddOutput(output) else { return }
        captureSession.addOutput(output)
        
        // set preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.insertSublayer(previewLayer, at: 0)
        // start capture
        captureSession.startRunning()
    }
    func stopCapture() {
        captureSession.stopRunning()
    }
    private func setTexts() {
        // Text PX
        self.text.frame = CGRect.init(x:0, y:10, width: 300, height: 30)
        self.text.textColor = UIColor.red
        self.text.font = UIFont.systemFont(ofSize:fontsize)
        self.text.text = "PX1 Testing"
        self.view.addSubview(self.text)
        
        // Text
        self.obsLabel.textColor = UIColor.green
        self.obsLabel.font = UIFont.systemFont(ofSize:fontsize)
        self.obsLabel.numberOfLines = 0
        self.obsLabel.frame = CGRect.init(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+200)
        self.view.addSubview(self.obsLabel)
        
        // predtime
        self.predtime.textColor = UIColor.white
        self.predtime.font = UIFont.systemFont(ofSize:fontsize)
        self.predtime.frame = CGRect.init(x:0, y:40, width: 500, height: 30)
        self.view.addSubview(self.predtime)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let ciimage = CIImageFromSampleBuffer(sampleBuffer)
        //uiimage = UIResize(image:uiimage!, width:224.0)
        self.stime = Date()
        self.resnet50ModelManager.performRequet(ciimage:ciimage!)
    }
}

extension CameraViewController: Resnet50ModelManagerDelegate {
    func didRecieve(_ observation: VNClassificationObservation) {
        if (self.detecting == false) {
            self.detecting = true
            DispatchQueue.main.async(execute: {
                self.obsLabel.text = "\(observation.identifier) is \(ceil(observation.confidence*1000)/10)%"
                self.predtime.text = "Latency: " + calcurateTime(stime:self.stime)
            })
            usleep(500*1000) // ms
            self.detecting = false
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

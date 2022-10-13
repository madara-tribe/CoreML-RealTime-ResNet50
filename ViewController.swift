import AVFoundation
import Vision
import SwiftUI

final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    public var obsLabel1:UILabel = UILabel()
    public var obsLabel2:UILabel = UILabel()
    public var text1:UILabel = UILabel()
    public var predtime:UILabel = UILabel()
    
    let fontsize:CGFloat = 20
    var uiimage: UIImage?
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
        self.startCapture()
        
        // Text PX
        self.text1.frame = CGRect.init(x:0, y:10, width: 300, height: 30)
        self.text1.textColor = UIColor.red
        self.text1.font = UIFont.systemFont(ofSize:fontsize)
        self.view.addSubview(self.text1)
        
        // Text bg
        self.obsLabel1.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
        self.obsLabel1.numberOfLines = 0
        self.view.addSubview(self.obsLabel1)

        // Text
        self.obsLabel2.textColor = UIColor.green
        self.obsLabel2.font = UIFont.systemFont(ofSize:fontsize)
        self.obsLabel2.numberOfLines = 0
        self.view.addSubview(self.obsLabel2)
        
        // Text for predtime
        self.predtime.textColor = UIColor.white
        self.predtime.font = UIFont.systemFont(ofSize:fontsize)
        self.obsLabel1.numberOfLines = 0
        self.view.addSubview(self.predtime)
        self.setPosition()
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
    private func setPosition() {
        self.text1.text = "PX1 Testing"
        self.obsLabel1.frame = CGRect.init(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.obsLabel2.frame = self.obsLabel1.frame.offsetBy(dx: 8.0, dy: 0)
        self.predtime.frame = CGRect.init(x:0, y:40, width: 500, height: 30)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        uiimage = UIImageFromSampleBuffer(sampleBuffer)
        self.stime = Date()
        //uiimage = UIResize(image:uiimage!, width:224.0)
        resnet50ModelManager.performRequet(image:uiimage!)
        //self.predtime.text = String(Double(uiimage!.size.height))
    }
}

extension CameraViewController: Resnet50ModelManagerDelegate {
    func didRecieve(_ observation: VNClassificationObservation) {
        if (self.detecting == false) {
            self.detecting = true
            DispatchQueue.main.async(execute: {
                self.predtime.text = "Latency: " + calcurateTime(stime:self.stime)
                self.obsLabel2.text = "\(observation.identifier) is \(ceil(observation.confidence*1000)/10)%"
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


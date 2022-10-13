import SwiftUI
import Vision
import CoreImage


func UIResize(image: UIImage, width: Double) -> UIImage? {
        
    // オリジナル画像のサイズからアスペクト比を計算
    let aspectScale = image.size.height / image.size.width
    
    // widthからアスペクト比を元にリサイズ後のサイズを取得
    let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
    
    // リサイズ後のUIImageを生成して返却
    UIGraphicsBeginImageContext(resizedSize)
    image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
}

func UIImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
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


func calcurateTime(stime:Date)-> String{
    let timeInterval = Date().timeIntervalSince(stime)
    //let predtime = String((timeInterval * 100) / 100) + "[ms]"
    return String(ceil(timeInterval * 10000) / 10000) + "[ms]"
}

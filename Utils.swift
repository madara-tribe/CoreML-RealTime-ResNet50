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

func CIImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> CIImage? {
    if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        let context = CIContext()
        if let image = context.createCGImage(ciImage, from: imageRect) {
            return CIImage(cgImage: image)
        }
    }
    return nil
}


func calcurateTime(stime:Date)->String{
    let timeInterval = Date().timeIntervalSince(stime)
    return String((timeInterval * 100) / 100) + "[ms]"
}

func trimmingImage(_ image: UIImage, ratio_:Double)-> UIImage{
    let trimmingArea = CGRect(x:0.0, y:0.0, width:image.size.width*ratio_, height:image.size.height*ratio_)
    let imgRef = image.cgImage?.cropping(to: trimmingArea)
    let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)
    return trimImage
}

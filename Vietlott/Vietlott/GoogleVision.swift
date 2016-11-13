//
//  File.swift
//  Camera&Number
//
//  Created by CongTruong on 11/11/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoogleVision {
    private var googleAPIKey = "AIzaSyCyz-3RpY_-lahd9c3-K12KQt0Z343rU4I"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    let session = URLSession.shared
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2 * 1024 * 1024) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String, handleSuccess: @escaping (_ lotteryArray: [String]) -> ()) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request, handleSuccess: handleSuccess) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest, handleSuccess: @escaping (_ lotteryArray: [String]) -> ()) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data, handleSuccess: handleSuccess)
        }
        
        task.resume()
    }
}

/// Image processing
extension GoogleVision {
    
    func analyzeResults(_ dataToParse: Data, handleSuccess: @escaping (_ lotteryArray: [String]) -> ()) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                //print(json)
                let responses: JSON = json["responses"][0]
                
                // get textAnnotations
                let textAnnotations: JSON = responses["textAnnotations"][0]
                // get text result
                let textResult = textAnnotations["description"].rawValue as? String
                
                if let text = textResult {
                    let lotteryStringArray = self.processToLotteryNumber(stringArray: text)
                    print(lotteryStringArray)
                    
                    handleSuccess(lotteryStringArray)
                }
            }
        })
    }

    func processToLotteryNumber(stringArray: String) -> [String] {
        // split to String
        let stringArray = stringArray.characters.split{$0 == "\n"}.map(String.init)
        var resultArrayString = [String]()
        
        for item in stringArray {
            let str = item.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let newString = str.joined(separator: "")
            if newString.characters.count == 12 {
                resultArrayString.append(newString)
            }
        }
        
        return resultArrayString
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
//    
//    func cropToBounds(image: UIImage, x: Double, y: Double, width: Double, height: Double) -> UIImage {
//        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
//        
//        let posX = CGFloat(x)
//        let posY = CGFloat(y)
//        let cgwidth = CGFloat(width)
//        let cgheight = CGFloat(height)
//        
//        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
//        
//        // Create bitmap image from context using the rect
//        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
//        
//        // Create a new image based on the imageRef and rotate back to the original orientation
//        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
//        
//        return image
//    }
}


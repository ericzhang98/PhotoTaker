//
//  ViewController.swift
//  PhotoTaker
//
//  Created by Eric Zhang on 12/24/16.
//  Copyright © 2016 Eric Zhang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Security

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet var imageView: UIImageView!
    var images:[UIImage] = []

    @IBAction func takePhotos(_ sender: AnyObject) {
        let avSession = AVCaptureSession()
        let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera , mediaType: AVMediaTypeVideo, position: .front)
        do {
            //get input and start session
            let frontCameraInput = try AVCaptureDeviceInput.init(device: frontCameraDevice)
            avSession.addInput(frontCameraInput)
            avSession.startRunning()
            print("SESSION HAS STARTED")

            //show output screen on new view
            let output = AVCapturePhotoOutput()
            avSession.addOutput(output)
            if let previewLayer = AVCaptureVideoPreviewLayer(session: avSession) {
                previewLayer.bounds = view.bounds
                previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
                cameraPreview.layer.addSublayer(previewLayer)
                view.addSubview(cameraPreview)
                
                
//                let connection = output.connection(withMediaType: AVMediaTypeVideo)
//                
//                // update the video orientation to the device one
//                connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
               
                //clear old pictures and take 10 pictures 0.5 secs apart
                images = []
                for i in 1...10 {
                    delay(0.5*Double(i)){
                        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
                    }
                }
                
                //pop out of subview after 5 seconds
                delay(5) {
                    cameraPreview.removeFromSuperview()
                }
            }
            
            
            
        } catch {print("FRONT CAMERA INPUT ISSUE")}

    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        //process photo
        let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        let image = UIImage(data: dataImage!)
        images.append(image!)

        if (images.count == 10) {
            storePhotos();
        }
    }
    
    func storePhotos() {
        //conver UIImage to Data in JPEG form
        var dataArray:[Data] = [];
        for i in 0...9 {
            dataArray.append(UIImageJPEGRepresentation(images[i], 1.0)!);
        }
        
        for i in 0...9 {
            KeychainManager.deleteData(itemKey: "PhotoTakerImage_\(i)")
            KeychainManager.addData(imageKey: "PhotoTakerImage_\(i)", imageData: dataArray[i])
        }
        
////        Keychain params
//        let serviceIdentifier = "serviceID"
//        let userAccount = "authenticatedUser"
//        let accessGroup = "accessGroup"
//        
//        var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, serviceIdentifier, userAccount, kCFBooleanTrue, kSecMatchLimitOne], forKeys: [kSecClass as! NSCopying, kSecAttrService as! NSCopying, kSecAttrAccount as! NSCopying, kSecReturnData as! NSCopying, kSecMatchLimit as! NSCopying])

    }
    
    @IBAction func getPhotos(_ sender: Any) {
        //Display photos in view
        
        var dataArray:[Data] = []
        for i in 0...9 {
            dataArray.append(KeychainManager.queryData(itemKey: "PhotoTakerImage_\(i)"))
        }
        
        for i in 0...9 {
            let imageView = UIImageView.init(image: UIImage(data: dataArray[9-i]))
            imageView.frame = view.frame
            let pictureView = UIView.init(frame: view.frame)
            pictureView.addSubview(imageView)
            pictureView.addGestureRecognizer(UITapGestureRecognizer.init(target: pictureView, action: #selector(pictureView.removeFromSuperview)))
            view.addSubview(pictureView)
        }
//        let imageData = KeychainManager.queryData(itemKey: "PhotoTakerImage_2")
//        print(imageData.base64EncodedData())
//        self.imageView.image = UIImage(data: imageData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                                  completionHandler: { (granted:Bool) -> Void in
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  FJScannerViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class FJScannerViewController: FJRootViewController {
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var dest:FJRootViewController? = nil
    
    var scanSwitch : Bool {
        willSet {
            if newValue {
                self.startSession()
            }
            else {
                self.stopSession()
            }
        }
    }
    
    init() {
        self.scanSwitch = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openCamera()
        
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: mainQueue) { (note) in
            self.scanSwitch = true
        }
        center.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: mainQueue) { (note) in
            self.scanSwitch = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = self.navigationController!.tabBarItem.title
        
        let status:AVAuthorizationStatus=AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status==AVAuthorizationStatus.authorized {//获得权限
            self.setupCaptureDeviceAndSession()
            self.scanSwitch = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanSwitch = false
    }
    
    //MARK: - private
    func setupCaptureDeviceAndSession() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        guard (captureDevice != nil) else {
            print("Create AVCaptureDevice error")
            return
        }
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        
        do {
            let input: AVCaptureInput!
            try input = AVCaptureDeviceInput(device: captureDevice!)
            guard input != nil else {
                print("create AVCaptureDeviceInput error")
                return
            }
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            guard captureSession != nil else {
                print("create AVCaptureSession error")
                return
            }
            // Set the input device on the capture session.
            captureSession?.addInput(input as AVCaptureInput)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            guard videoPreviewLayer != nil else {
                print("create AVCaptureVideoPreviewLayer error")
                return
            }
            view.layer.addSublayer(videoPreviewLayer!)
            
        } catch {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("create AVCaptureDeviceInput error")
            return
        }
    }
    
    func startSession() {
        // Start video capture.
        captureSession?.startRunning()
    }
    
    func stopSession() {
        captureSession?.stopRunning()
    }
    
    func openCamera(){
        
        //获取相册权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            
            switch status {
            case .notDetermined:
                self.gotoSetting()
                break
            case .restricted:
                //此应用程序没有被授权访问的照片数据
                self.view.makeToast("此应用程序没有被授权访问的照片数据")
                break
            case .denied:
                //用户已经明确否认了这一照片数据的应用程序访问
                self.gotoSetting()
                break
            case .authorized:
                //已经有权限，开始扫描
                if !self.scanSwitch {
                    self.scanSwitch = true
                }
                break
            }
        })
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (ist) in
            
            let status:AVAuthorizationStatus=AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if status==AVAuthorizationStatus.authorized {//获得权限

            }
            else if status==AVAuthorizationStatus.denied ||
                    status==AVAuthorizationStatus.restricted {
                self.gotoSetting()
            }
            
        })
    }
    
    //去设置权限
    func gotoSetting(){
        
        let alertController:UIAlertController = UIAlertController.init(title: "设置应用权限",
                                                                       message: "设置-》通用-》",
                                                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let sure:UIAlertAction = UIAlertAction.init(title: "去开启权限", style: UIAlertActionStyle.default) { (ac) in
            
            let url=URL.init(string: UIApplicationOpenSettingsURLString)
            
            if UIApplication.shared.canOpenURL(url!){
                
                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist) in
                    
                })
            }
        }
        alertController.addAction(sure)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func makeAlert(_ msg:String) {
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let openAction = UIAlertAction(title: "打开", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            guard let url = URL.init(string: msg) else {
                self.view.makeToast("打不开链接")
                self.scanSwitch = true
                return;
            }
            
            UIApplication.shared.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly:NSNumber.init(value: true)], completionHandler: { (success) in
                if !success {
                    self.view.makeToast("打不开链接")
                    self.scanSwitch = true
                }
            })
        })
        
        alertController.addAction(openAction)
        
        let copyAction = UIAlertAction(title: "复制", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = msg
            self.scanSwitch = true
        })
        alertController.addAction(copyAction)

        let collectAction = UIAlertAction(title: "收藏", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            self.scanSwitch = true
        })
        alertController.addAction(collectAction)

        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension FJScannerViewController:AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == .qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            //let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) as! AVMetadataMachineReadableCodeObject
            if metadataObj.stringValue != nil && self.scanSwitch {
                self.scanSwitch = false
                self.makeAlert(metadataObj.stringValue!)
            }
        }
    }
}


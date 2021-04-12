//
//  ViewController.swift
//  BarCodeScanner
//
//  Created by Дмитрий Кондратьев on 20.03.2021.
//
// https://barcode.tec-it.com/ru/Code93?data=ABC-1234-%2F%2B

import UIKit
import AVFoundation

class BarCodeScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var barCodeTextView: UITextView!
    var typeBarCodeLable: UILabel!
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // MARK: Create UI
    
    func createUILableBarCode() {
        barCodeTextView = UITextView(frame: CGRect(x:0, y: view.layer.frame.height-179, width: view.layer.frame.width, height: 96))
        barCodeTextView.backgroundColor = UIColor.red
        barCodeTextView.text = "I'm a test label. I'm a test label. I'm a test "
        barCodeTextView.isEditable = false
        self.view.addSubview(barCodeTextView)
    }
    
    func createUILableTypeBarCode() {
        typeBarCodeLable = UILabel(frame: CGRect(x:0, y: view.layer.frame.height-200, width: view.layer.frame.width, height: 21))
        typeBarCodeLable.backgroundColor = UIColor.green
        typeBarCodeLable.text = "Type Bar Code"
        self.view.addSubview(typeBarCodeLable)
    }
    
    func createBarCodeSessionCapture() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height-200)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createUILableBarCode()
        createUILableTypeBarCode()
        createBarCodeSessionCapture()
    }
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    /*func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let type = metadataObject.type
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundBarCode(code: stringValue, type: type.rawValue)
        }

        //dismiss(animated: true)
    }*/
    
    // MARK: - Private Methods
    
    /// - parameter failed: Output error
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
}

// MARK: extension AVCaptureMetadataOutputObjectsDelegate

extension BarCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    private func foundBarCode(code: String, type: String) {
        
        print(code, type)
        typeBarCodeLable.text = type
        barCodeTextView.text = code
        
        let message = "Тип: \(type)\n Штрих код: \(code)"
        
        let ac = UIAlertController(title: "Штрих код", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let myDelegete = UIApplication.shared.delegate as! AppDelegate
            let context = myDelegete.persistentContainer.viewContext
            let barCodeHistory = BarCodeHistory(context: context)
            
            barCodeHistory.typeBarCode = type
            barCodeHistory.barCode = code
            
            myDelegete.saveContext()
            
            self.captureSession.startRunning()
        }
        ac.addAction(yesAction)
        present(ac, animated: true)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let type = metadataObject.type
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            captureSession.stopRunning()
            foundBarCode(code: stringValue, type: type.rawValue)
        }
        
        

        //dismiss(animated: true)
    }
}



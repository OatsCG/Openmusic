//
//  ProximityManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-12.
//

import CoreVideo
import AVFoundation

class ProximityManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureDepthDataOutputDelegate {
    private let session = AVCaptureSession()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private let queue = DispatchQueue(label: "com.example.DepthDataVideoCaptureQueue")
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    var depthData: CVPixelBuffer? = nil

    override init() {
        super.init()
        sessionQueue.async { [weak self] in
            self?.configureCaptureSession()
        }
    }

    private func configureCaptureSession() {
        guard let device = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Unable to access front TrueDepth camera.")
            return
        }
        
        session.beginConfiguration()
        if session.canAddInput(input) { session.addInput(input) }

        if session.canAddOutput(depthDataOutput) {
            depthDataOutput.isFilteringEnabled = false
            session.addOutput(depthDataOutput)
            if let connection = depthDataOutput.connection(with: .depthData) {
                connection.isEnabled = true
            }
        } else {
            print("Depth Data Output is not supported on this device.")
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()

        //videoOutput.setSampleBufferDelegate(self, queue: queue)
        depthDataOutput.setDelegate(self, callbackQueue: queue)
        
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }

    // MARK: - Video Data Output Delegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            //if output == videoOutput {
                // Retrieve the video sample buffer
                //guard CMSampleBufferGetImageBuffer(sampleBuffer) != nil else { return }
           // }
        }

    // MARK: - Depth Data Output Delegate
    func depthDataOutput(_ output: AVCaptureDepthDataOutput,
                         didOutput depthData: AVDepthData,
                         timestamp: CMTime,
                         connection: AVCaptureConnection) {
        // Here we can access the depth data
        let depthPixelBuffer = depthData.converting(toDepthDataType: kCVPixelFormatType_DepthFloat32).depthDataMap
        self.depthData = depthPixelBuffer
        
        // Handle your depth pixel buffer (e.g., processing or display in the UI)
    }

    // Call this method to stop the capture session
    func stopRunning() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    //MARK: - MY SHIT
    func columnDepth(from pixelBuffer: CVPixelBuffer, at normalizedY: Float) -> [Float]? {
        //print(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        
        // Calculate the row index
        let rowIndex = Int(floor(normalizedY * Float(height)))
        
        // Lock the buffer base address for reading
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        // Get the base address of the pixel buffer
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            return nil
        }
        
        // Assuming the depth data is in Float32 format
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let floatBuffer = baseAddress.assumingMemoryBound(to: Float.self)
        
        // Calculate the starting point of the desired row
        let rowStart = floatBuffer.advanced(by: rowIndex * bytesPerRow / MemoryLayout<Float>.size)
        
        // Extract the row data
        let bufferPointer = UnsafeBufferPointer(start: rowStart, count: width)
        let rowData = Array(bufferPointer)
        
        return rowData
    }
    
    func rowDepth(from pixelBuffer: CVPixelBuffer, at normalizedX: Float) -> [Float]? {
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        
        // Calculate the column index
        let columnIndex = Int(floor(normalizedX * Float(width)))
        
        // Lock the buffer base address for reading
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        // Get the base address of the pixel buffer
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            return nil
        }
        
        // Assuming the depth data is in Float32 format
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let floatBuffer = baseAddress.assumingMemoryBound(to: Float.self)
        
        // Create an array to store the column data
        var columnData: [Float] = []
        columnData.reserveCapacity(height)
        
        // Extract the column data
        for row in 0..<height {
            let pixelData = floatBuffer.advanced(by: row * bytesPerRow / MemoryLayout<Float>.size + columnIndex)
            columnData.append(pixelData.pointee)
        }
        
        return columnData
    }

    func extractCenterPixel(row: Float, range: Double, completion: @escaping ((depth: Float, good: Bool)?) -> Void) -> Void {
        if let depth = self.depthData {
            let centerColumn = self.columnDepth(from: depth, at: row * 0.95) // row is cut because of irrelevant data in depth buffer
            //print(centerRow)
            if let centerColumn {
                let proxRange: Double = range * 0.5 // proxrange% pixels will be averaged
                let offset: Double = 0.5 // top to bottom, middle of proxRange
                let proxRangePixelCount: Int = Int(Double(centerColumn.count) * proxRange)
                
                let proxRangeTop = Int((Double(centerColumn.count) * offset) - (Double(centerColumn.count) * (proxRange / 2)))
                let proxRangeBottom = Int((Double(centerColumn.count) * offset) + (Double(centerColumn.count) * (proxRange / 2)))
                
                //print("centerRow.count: \(centerColumn.count), posStart: \(proxRangeTop), posEnd: \(proxRangeBottom)")
                var sum: Float = 0
                for i in proxRangeTop...(proxRangeBottom - 1) {
                    //groupthing.append(1/centerRow[i])
                    sum += convertDepthDistance(x: centerColumn[i])
                }
                //convertDepthDistance(x: centerRow[0])
                let avgDistance: Float = (sum / Float(proxRangePixelCount))
                //print(String(repeating: "|", count: Int(avgDistance * 30)))
                //print(avgDistance)
                completion((avgDistance, avgDistance >= 0.7))
            } else {
                completion(nil)
            }
        }
    }
}


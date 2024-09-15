import SwiftUI

/// A variable blur view.
public class VariableBlurUIView: UIVisualEffectView {
    public init(
        gradientMask: CGImage?,
        maxBlurRadius: CGFloat = 20,
        filterType: String = "variableBlur"
    ) {
        super.init(effect: UIBlurEffect(style: .regular))

        let filterClassStringEncoded = "Q0FGaWx0ZXI="

        let filterClassString: String = {
            if
                let data = Data(base64Encoded: filterClassStringEncoded),
                let string = String(data: data, encoding: .utf8)
            {
                return string
            }

            print("[VariableBlurView] couldn't decode the filter class string.")
            return ""
        }()

        let filterWithTypeStringEncoded = "ZmlsdGVyV2l0aFR5cGU6"

        let filterWithTypeString: String = {
            if let data = Data(base64Encoded: filterWithTypeStringEncoded), let string = String(data: data, encoding: .utf8) {
                return string
            }
            print("[VariableBlurView] couldn't decode the filter method string.")
            return ""
        }()
        
        let filterWithTypeSelector = Selector(filterWithTypeString)
        guard let filterClass = NSClassFromString(filterClassString) as AnyObject as? NSObjectProtocol else {
            print("[VariableBlurView] couldn't create CAFilter class.")
            return
        }

        /// Make sure the filter class responds to the selector.
        guard filterClass.responds(to: filterWithTypeSelector) else {
            print("[VariableBlurView] Doesn't respond to selector \(filterWithTypeSelector)")
            return
        }

        /// Create the blur effect.
        let variableBlur = filterClass
            .perform(filterWithTypeSelector, with: filterType)
            .takeUnretainedValue()

        guard let variableBlur = variableBlur as? NSObject else {
            print("[VariableBlurView] Couldn't cast the blur filter.")
            return
        }


        let gradientImageRef: CGImage? = gradientMask
        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
        variableBlur.setValue(gradientImageRef, forKey: "inputMaskImage")
        variableBlur.setValue(true, forKey: "inputNormalizeEdges")

        if subviews.indices.contains(1) {
            let tintOverlayView = subviews[1]
            tintOverlayView.alpha = 0
        }

        let backdropLayer = subviews.first?.layer
        backdropLayer?.filters = [variableBlur]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func didMoveToWindow() {
        // fixes visible pixelization at unblurred edge (https://github.com/nikstar/VariableBlur/issues/1)
        guard let window, let backdropLayer = subviews.first?.layer else { return }
        backdropLayer.setValue(window.screen.scale, forKey: "scale")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {}
}

/// A variable blur view.
public struct VariableBlurView: UIViewRepresentable {
    public var gradientMask: CGImage?
    public var maxBlurRadius: CGFloat
    public var filterType: String

    /// A variable blur view.
    public init(
        maxBlurRadius: CGFloat = 20,
        filterType: String = "variableBlur",
        flat: Bool = false
    ) {
        if (flat == false) {
            self.gradientMask = variableBlurGradientConstructor.shared.globalBlur
        } else {
            self.gradientMask = variableBlurGradientConstructor.shared.flatBlur
        }
        self.maxBlurRadius = maxBlurRadius
        self.filterType = filterType
    }

    public func makeUIView(context: Context) -> VariableBlurUIView {
        let view = VariableBlurUIView(
            gradientMask: gradientMask,
            maxBlurRadius: maxBlurRadius,
            filterType: filterType
        )
        return view
    }

    public func updateUIView(_ uiView: VariableBlurUIView, context: Context) {}
}


final class variableBlurGradientConstructor: Sendable {
    static let shared: variableBlurGradientConstructor = variableBlurGradientConstructor()
    let globalBlur: CGImage
    let flatBlur: CGImage
    init() {
        self.globalBlur = createVerticalGradientImage(size: .init(width: 100, height: 100))!
        self.flatBlur = createflatImage(size: .init(width: 100, height: 100))!
    }
}

func createVerticalGradientImage(size: CGSize) -> CGImage? {
    let startColor = CIColor(color: .clear)
    let endColor = CIColor(color: .black)

    let filter = CIFilter(name: "CISmoothLinearGradient")!
    filter.setValue(CIVector(x: 0.7, y: size.height), forKey: "inputPoint0")
    filter.setValue(CIVector(x: 0.05, y: 0), forKey: "inputPoint1")
    filter.setValue(startColor, forKey: "inputColor0")
    filter.setValue(endColor, forKey: "inputColor1")

    if let outputImage = filter.outputImage {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height)) {
            return cgImage
        }
    }
    return nil
}

func createflatImage(size: CGSize) -> CGImage? {
    let width = Int(size.width)
    let height = Int(size.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
        return nil
    }
    context.setFillColor(UIColor.black.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    return context.makeImage()
}

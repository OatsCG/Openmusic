//
//  BasicAudioPlayer
//  BAPError.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

public enum BAPError: Error {
    
    case renderingInvalidRegionBounds
    case renderingNoSourceLoaded
    case renderingBufferCreationFailed
    case renderingUnknownError
    
    public var description: String {
        switch self {
        case .renderingInvalidRegionBounds:
            return "The rendering region bounds are invalid"
            
        case .renderingNoSourceLoaded:
            return "No audio file is loaded"
            
        case .renderingBufferCreationFailed:
            return "Buffer creation failed"
            
        case .renderingUnknownError:
            return "A problem occurred during rendering and resulted in no data being returned"
        }
    }
    
}

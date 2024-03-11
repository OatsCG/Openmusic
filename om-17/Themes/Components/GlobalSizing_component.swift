//
//  GlobalSizing_component.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI

/*
@Environment(\.horizontalSizeClass) private var horizontalSizeClass
@Environment(\.verticalSizeClass) private var verticalSizeClass
*/

func TrackLink_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (count: Int, span: Int) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(count: 28, span: 2)
        } else {
            // iOS portrait
            return(count: 13, span: 2)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(count: 28, span: 2)
        } else {
            // iPadOS + MacOS
            return(count: 28, span: 2)
        }
    }
}

func SearchTrackLink_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (width: CGFloat, height: CGFloat) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(width: 250, height: 60)
        } else {
            // iOS portrait
            return(width: 250, height: 60)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(width: 250, height: 60)
        } else {
            // iPadOS + MacOS
            return(width: 300, height: 72)
        }
    }
}

func SearchAlbumLink_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (width: CGFloat, height: CGFloat) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(width: 160, height: 0)
        } else {
            // iOS portrait
            return(width: 160, height: 0)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(width: 160, height: 0)
        } else {
            // iPadOS + MacOS
            return(width: 190, height: 0)
        }
    }
}

func SearchAlbumLinkBig_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (width: CGFloat, height: CGFloat) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(width: 200, height: 0)
        } else {
            // iOS portrait
            return(width: 200, height: 0)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(width: 200, height: 0)
        } else {
            // iPadOS + MacOS
            return(width: 250, height: 0)
        }
    }
}

func SearchArtistLink_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (width: CGFloat, height: CGFloat) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(width: 130, height: 173)
        } else {
            // iOS portrait
            return(width: 130, height: 173)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(width: 130, height: 173)
        } else {
            // iPadOS + MacOS
            return(width: 180, height: 239)
        }
    }
}

func Miniplayer_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (width: CGFloat, height: CGFloat) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(width: 0, height: 55)
        } else {
            // iOS portrait
            return(width: 0, height: 55)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(width: 0, height: 55)
        } else {
            // iPadOS + MacOS
            return(width: 0, height: 65)
        }
    }
}

func QPSingle_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (count: Int, span: Int) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(count: 65, span: 10)
        } else {
            // iOS portrait
            return(count: 38, span: 10)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(count: 67, span: 10)
        } else {
            // iPadOS + MacOS
            return(count: 65, span: 10)
        }
    }
}

func QPMultiple_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> (count: Int, span: Int) {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(count: 55, span: 10)
        } else {
            // iOS portrait
            return(count: 22, span: 10)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(count: 52, span: 10)
        } else {
            // iPadOS + MacOS
            return(count: 55, span: 10)
        }
    }
}

func albumGridColumns_sizing(h: UserInterfaceSizeClass?, v: UserInterfaceSizeClass?) -> Int {
    if (h == .compact) {
        if (v == .compact) {
            // iOS small landscape
            return(4)
        } else {
            // iOS portrait
            return(2)
        }
    } else {
        if (v == .compact) {
            // iOS big landscape
            return(4)
        } else {
            // iPadOS + MacOS
            return(5)
        }
    }
}

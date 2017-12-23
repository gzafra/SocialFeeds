//
//  ImageKeys.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import UIKit

enum ImageKeys: String {
    case facebookIcon
    case placerHolderUser
    
    var image: UIImage  {
        let image = UIImage(named: self.rawValue, in: Bundle.main, compatibleWith: nil)
        assert(image != nil, "image resource missing: \(self.rawValue)")
        return image!
    }
}

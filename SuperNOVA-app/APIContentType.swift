//
//  AplContentType.swift
//  SwiftTest
//
//  Created by y-okada on 2016/09/24.
//  Copyright © 2016年 SuperNOVA. All rights reserved.
//

import Foundation

/// リクエスト種別
enum APIContentType: String {
    case APPLICATION_OCTET  = "application/octet-stream"
    case TEXT_PLAIN         = "text/plain"
    case APPLICATION_TAR    = "application/x-tar"
    case APPLICATION_RAR    = "application/x-rar-compressed"
    case APPLICATION_ZIP    = "application/zip"
    case APPLICATION_JAR    = "application/java-archiver"
    case APPLICATION_PDF    = "application/pdf"
    case APPLICATION_XML    = "application/xml"
    case IMAGE_JPG          = "image/jpg"
    case IMAGE_GIF          = "image/gif"
    case IMAGE_PNG          = "image/png"
    case IMAGE_BMP          = "image/x-bmp"
    case AUDIO_MP3          = "audio/mpeg"
    case AUDIO_WAV          = "audio/wav"
}
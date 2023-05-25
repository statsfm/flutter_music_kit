//
//  MusicKitPluginToken.swift
//  music_kit
//
//  Created by Xavier Lyu on 2022/5/25.
//

import Foundation
import MusicKit

let kErrorRequestUserToken = "ERR_REQUEST_USER_TOKEN"

extension SwiftMusicKitPlugin {
  func developerToken(_ result: @escaping FlutterResult) {
    Task {
      do {
        let token = try await DefaultMusicTokenProvider().developerToken(options: MusicTokenRequestOptions.ignoreCache)
        result(token)
      } catch {
        result(nil)
      }
    }
  }
  
  func fetchUserToken(developerToken: String, result: @escaping FlutterResult) {
    Task {
      do {
        let token = try await MusicUserTokenProvider().userToken(for: developerToken, options: MusicTokenRequestOptions.ignoreCache)
        result(token)
      } catch {
        if (error is MusicTokenRequestError) {
          //TODO: Make a custom enum for Flutter to use
          let requestError: MusicTokenRequestError = error as! MusicTokenRequestError;
          result(FlutterError(code: "ERR_MUSICKIT_USER_TOKEN", message: requestError.rawValue))
        } else {
          result(FlutterError(code: kErrorRequestUserToken, message: error.localizedDescription)) 
        }
      }
    }
  }
}

// TODO: MusicTokenRequestError

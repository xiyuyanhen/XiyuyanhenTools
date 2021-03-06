// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation
import Foundation

#if os(macOS)
extension AVAudioEngine {
    func setDevice(id: AudioDeviceID) {
        var outputID = id
        if let outputUnit = outputNode.audioUnit {
            let error = AudioUnitSetProperty(outputUnit,
                                             kAudioOutputUnitProperty_CurrentDevice,
                                             kAudioUnitScope_Global,
                                             0,
                                             &outputID,
                                             UInt32(MemoryLayout<AudioDeviceID>.size))
            if error != noErr {
                AudioKit_Log("setDevice error: ", error)
            }
        }
    }

    func getDevice() -> AudioDeviceID {
        if let outputUnit = outputNode.audioUnit {
            var outputID: AudioDeviceID = 0
            var propsize = UInt32(MemoryLayout<AudioDeviceID>.size)
            let error = AudioUnitGetProperty(outputUnit,
                                             kAudioOutputUnitProperty_CurrentDevice,
                                             kAudioUnitScope_Global,
                                             0,
                                             &outputID,
                                             &propsize)
            if error != noErr {
                AudioKit_Log("getDevice error: ", error)
            }
            return outputID
        }

        return 0
    }
}
#endif

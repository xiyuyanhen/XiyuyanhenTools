// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation
import os.log

// Print out a more human readable error message
///
/// - parameter error: OSStatus flag
///
public func CheckError(_ error: OSStatus) {
    #if os(tvOS) // No CoreMIDI
        switch error {
        case noErr:
            return
        case kAudio_ParamError:
            AudioKit_Log("kAudio_ParamError", log: OSLog.general, type: .error)

        case kAUGraphErr_NodeNotFound:
            AudioKit_Log("kAUGraphErr_NodeNotFound", log: OSLog.general, type: .error)

        case kAUGraphErr_OutputNodeErr:
            AudioKit_Log("kAUGraphErr_OutputNodeErr", log: OSLog.general, type: .error)

        case kAUGraphErr_InvalidConnection:
            AudioKit_Log("kAUGraphErr_InvalidConnection", log: OSLog.general, type: .error)

        case kAUGraphErr_CannotDoInCurrentContext:
            AudioKit_Log("kAUGraphErr_CannotDoInCurrentContext", log: OSLog.general, type: .error)

        case kAUGraphErr_InvalidAudioUnit:
            AudioKit_Log("kAUGraphErr_InvalidAudioUnit", log: OSLog.general, type: .error)

        case kAudioToolboxErr_InvalidSequenceType:
            AudioKit_Log("kAudioToolboxErr_InvalidSequenceType", log: OSLog.general, type: .error)

        case kAudioToolboxErr_TrackIndexError:
            AudioKit_Log("kAudioToolboxErr_TrackIndexError", log: OSLog.general, type: .error)

        case kAudioToolboxErr_TrackNotFound:
            AudioKit_Log("kAudioToolboxErr_TrackNotFound", log: OSLog.general, type: .error)

        case kAudioToolboxErr_EndOfTrack:
            AudioKit_Log("kAudioToolboxErr_EndOfTrack", log: OSLog.general, type: .error)

        case kAudioToolboxErr_StartOfTrack:
            AudioKit_Log("kAudioToolboxErr_StartOfTrack", log: OSLog.general, type: .error)

        case kAudioToolboxErr_IllegalTrackDestination:
            AudioKit_Log("kAudioToolboxErr_IllegalTrackDestination", log: OSLog.general, type: .error)

        case kAudioToolboxErr_NoSequence:
            AudioKit_Log("kAudioToolboxErr_NoSequence", log: OSLog.general, type: .error)

        case kAudioToolboxErr_InvalidEventType:
            AudioKit_Log("kAudioToolboxErr_InvalidEventType", log: OSLog.general, type: .error)

        case kAudioToolboxErr_InvalidPlayerState:
            AudioKit_Log("kAudioToolboxErr_InvalidPlayerState", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidProperty:
            AudioKit_Log("kAudioUnitErr_InvalidProperty", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidParameter:
            AudioKit_Log("kAudioUnitErr_InvalidParameter", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidElement:
            AudioKit_Log("kAudioUnitErr_InvalidElement", log: OSLog.general, type: .error)

        case kAudioUnitErr_NoConnection:
            AudioKit_Log("kAudioUnitErr_NoConnection", log: OSLog.general, type: .error)

        case kAudioUnitErr_FailedInitialization:
            AudioKit_Log("kAudioUnitErr_FailedInitialization", log: OSLog.general, type: .error)

        case kAudioUnitErr_TooManyFramesToProcess:
            AudioKit_Log("kAudioUnitErr_TooManyFramesToProcess", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidFile:
            AudioKit_Log("kAudioUnitErr_InvalidFile", log: OSLog.general, type: .error)

        case kAudioUnitErr_FormatNotSupported:
            AudioKit_Log("kAudioUnitErr_FormatNotSupported", log: OSLog.general, type: .error)

        case kAudioUnitErr_Uninitialized:
            AudioKit_Log("kAudioUnitErr_Uninitialized", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidScope:
            AudioKit_Log("kAudioUnitErr_InvalidScope", log: OSLog.general, type: .error)

        case kAudioUnitErr_PropertyNotWritable:
            AudioKit_Log("kAudioUnitErr_PropertyNotWritable", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidPropertyValue:
            AudioKit_Log("kAudioUnitErr_InvalidPropertyValue", log: OSLog.general, type: .error)

        case kAudioUnitErr_PropertyNotInUse:
            AudioKit_Log("kAudioUnitErr_PropertyNotInUse", log: OSLog.general, type: .error)

        case kAudioUnitErr_Initialized:
            AudioKit_Log("kAudioUnitErr_Initialized", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidOfflineRender:
            AudioKit_Log("kAudioUnitErr_InvalidOfflineRender", log: OSLog.general, type: .error)

        case kAudioUnitErr_Unauthorized:
            AudioKit_Log("kAudioUnitErr_Unauthorized", log: OSLog.general, type: .error)

        default:
            AudioKit_Log("\(error)", log: OSLog.general, type: .error)
        }
    #else
        switch error {
        case noErr:
            return
        case kAudio_ParamError:
            AudioKit_Log("kAudio_ParamError", log: OSLog.general, type: .error)

        case kAUGraphErr_NodeNotFound:
            AudioKit_Log("kAUGraphErr_NodeNotFound", log: OSLog.general, type: .error)

        case kAUGraphErr_OutputNodeErr:
            AudioKit_Log("kAUGraphErr_OutputNodeErr", log: OSLog.general, type: .error)

        case kAUGraphErr_InvalidConnection:
            AudioKit_Log("kAUGraphErr_InvalidConnection", log: OSLog.general, type: .error)

        case kAUGraphErr_CannotDoInCurrentContext:
            AudioKit_Log("kAUGraphErr_CannotDoInCurrentContext", log: OSLog.general, type: .error)

        case kAUGraphErr_InvalidAudioUnit:
            AudioKit_Log("kAUGraphErr_InvalidAudioUnit", log: OSLog.general, type: .error)

        case kMIDIInvalidClient:
            AudioKit_Log("kMIDIInvalidClient", log: OSLog.midi, type: .error)

        case kMIDIInvalidPort:
            AudioKit_Log("kMIDIInvalidPort", log: OSLog.midi, type: .error)

        case kMIDIWrongEndpointType:
            AudioKit_Log("kMIDIWrongEndpointType", log: OSLog.midi, type: .error)

        case kMIDINoConnection:
            AudioKit_Log("kMIDINoConnection", log: OSLog.midi, type: .error)

        case kMIDIUnknownEndpoint:
            AudioKit_Log("kMIDIUnknownEndpoint", log: OSLog.midi, type: .error)

        case kMIDIUnknownProperty:
            AudioKit_Log("kMIDIUnknownProperty", log: OSLog.midi, type: .error)

        case kMIDIWrongPropertyType:
            AudioKit_Log("kMIDIWrongPropertyType", log: OSLog.midi, type: .error)

        case kMIDINoCurrentSetup:
            AudioKit_Log("kMIDINoCurrentSetup", log: OSLog.midi, type: .error)

        case kMIDIMessageSendErr:
            AudioKit_Log("kMIDIMessageSendErr", log: OSLog.midi, type: .error)

        case kMIDIServerStartErr:
            AudioKit_Log("kMIDIServerStartErr", log: OSLog.midi, type: .error)

        case kMIDISetupFormatErr:
            AudioKit_Log("kMIDISetupFormatErr", log: OSLog.midi, type: .error)

        case kMIDIWrongThread:
            AudioKit_Log("kMIDIWrongThread", log: OSLog.midi, type: .error)

        case kMIDIObjectNotFound:
            AudioKit_Log("kMIDIObjectNotFound", log: OSLog.midi, type: .error)

        case kMIDIIDNotUnique:
            AudioKit_Log("kMIDIIDNotUnique", log: OSLog.midi, type: .error)

        case kMIDINotPermitted:
            AudioKit_Log("kMIDINotPermitted: Have you enabled the audio background mode in your ios app?",
                  log: OSLog.midi,
                  type: .error)

        case kAudioToolboxErr_InvalidSequenceType:
            AudioKit_Log("kAudioToolboxErr_InvalidSequenceType", log: OSLog.general, type: .error)

        case kAudioToolboxErr_TrackIndexError:
            AudioKit_Log("kAudioToolboxErr_TrackIndexError", log: OSLog.general, type: .error)

        case kAudioToolboxErr_TrackNotFound:
            AudioKit_Log("kAudioToolboxErr_TrackNotFound", log: OSLog.general, type: .error)

        case kAudioToolboxErr_EndOfTrack:
            AudioKit_Log("kAudioToolboxErr_EndOfTrack", log: OSLog.general, type: .error)

        case kAudioToolboxErr_StartOfTrack:
            AudioKit_Log("kAudioToolboxErr_StartOfTrack", log: OSLog.general, type: .error)

        case kAudioToolboxErr_IllegalTrackDestination:
            AudioKit_Log("kAudioToolboxErr_IllegalTrackDestination", log: OSLog.general, type: .error)

        case kAudioToolboxErr_NoSequence:
            AudioKit_Log("kAudioToolboxErr_NoSequence", log: OSLog.general, type: .error)

        case kAudioToolboxErr_InvalidEventType:
            AudioKit_Log("kAudioToolboxErr_InvalidEventType", log: OSLog.general, type: .error)

        case kAudioToolboxErr_InvalidPlayerState:
            AudioKit_Log("kAudioToolboxErr_InvalidPlayerState", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidProperty:
            AudioKit_Log("kAudioUnitErr_InvalidProperty", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidParameter:
            AudioKit_Log("kAudioUnitErr_InvalidParameter", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidElement:
            AudioKit_Log("kAudioUnitErr_InvalidElement", log: OSLog.general, type: .error)

        case kAudioUnitErr_NoConnection:
            AudioKit_Log("kAudioUnitErr_NoConnection", log: OSLog.general, type: .error)

        case kAudioUnitErr_FailedInitialization:
            AudioKit_Log("kAudioUnitErr_FailedInitialization", log: OSLog.general, type: .error)

        case kAudioUnitErr_TooManyFramesToProcess:
            AudioKit_Log("kAudioUnitErr_TooManyFramesToProcess", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidFile:
            AudioKit_Log("kAudioUnitErr_InvalidFile", log: OSLog.general, type: .error)

        case kAudioUnitErr_FormatNotSupported:
            AudioKit_Log("kAudioUnitErr_FormatNotSupported", log: OSLog.general, type: .error)

        case kAudioUnitErr_Uninitialized:
            AudioKit_Log("kAudioUnitErr_Uninitialized", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidScope:
            AudioKit_Log("kAudioUnitErr_InvalidScope", log: OSLog.general, type: .error)

        case kAudioUnitErr_PropertyNotWritable:
            AudioKit_Log("kAudioUnitErr_PropertyNotWritable", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidPropertyValue:
            AudioKit_Log("kAudioUnitErr_InvalidPropertyValue", log: OSLog.general, type: .error)

        case kAudioUnitErr_PropertyNotInUse:
            AudioKit_Log("kAudioUnitErr_PropertyNotInUse", log: OSLog.general, type: .error)

        case kAudioUnitErr_Initialized:
            AudioKit_Log("kAudioUnitErr_Initialized", log: OSLog.general, type: .error)

        case kAudioUnitErr_InvalidOfflineRender:
            AudioKit_Log("kAudioUnitErr_InvalidOfflineRender", log: OSLog.general, type: .error)

        case kAudioUnitErr_Unauthorized:
            AudioKit_Log("kAudioUnitErr_Unauthorized", log: OSLog.general, type: .error)

        default:
            AudioKit_Log("\(error)", log: OSLog.general, type: .error)
        }
    #endif
}

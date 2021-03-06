// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
//import CAudioKit

/// Implements the DC blocking filter Y[i] = X[i] - X[i-1] + (igain * Y[i-1])  
/// Based on work by Perry Cook.
/// 
public class DCBlock: Node, AudioUnitContainer, Tappable, Toggleable {

    /// Unique four-letter identifier "dcbk"
    public static let ComponentDescription = AudioComponentDescription(effect: "dcbk")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    // MARK: - Audio Unit

    /// Internal Audio Unit for DCBlock
    public class InternalAU: AudioUnitBase {

        /// Create the DSP Refence for this node
        /// - Returns: DSP Reference
        public override func createDSP() -> DSPRef {
            akCreateDSP("DCBlockDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///
    public init(
        _ input: Node
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

        }
        connections.append(input)
    }
}

// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
//import CAudioKit

/// Moog Ladder is an new digital implementation of the Moog ladder filter 
/// based on the work of Antti Huovilainen, described in the paper 
/// "Non-Linear Digital Implementation of the Moog Ladder Filter" (Proceedings of DaFX04, Univ of Napoli).
/// This implementation is probably a more accurate digital representation of the original analogue filter.
/// 
public class MoogLadder: Node, AudioUnitContainer, Tappable, Toggleable {

    /// Unique four-letter identifier "mgld"
    public static let ComponentDescription = AudioComponentDescription(effect: "mgld")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for cutoffFrequency
    public static let cutoffFrequencyDef = NodeParameterDef(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency (Hz)",
        address: akGetParameterAddress("MoogLadderParameterCutoffFrequency"),
        range: 12.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Filter cutoff frequency.
    @Parameter public var cutoffFrequency: AUValue

    /// Specification details for resonance
    public static let resonanceDef = NodeParameterDef(
        identifier: "resonance",
        name: "Resonance (%)",
        address: akGetParameterAddress("MoogLadderParameterResonance"),
        range: 0.0 ... 2.0,
        unit: .percent,
        flags: .default)

    /// Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1.
    @Parameter public var resonance: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for MoogLadder
    public class InternalAU: AudioUnitBase {
        /// Get an array of the parameter definitions
        /// - Returns: Array of parameter definitions
        public override func getParameterDefs() -> [NodeParameterDef] {
            [MoogLadder.cutoffFrequencyDef,
             MoogLadder.resonanceDef]
        }

        /// Create the DSP Refence for this node
        /// - Returns: DSP Reference
        public override func createDSP() -> DSPRef {
            akCreateDSP("MoogLadderDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - cutoffFrequency: Filter cutoff frequency.
    ///   - resonance: Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1.
    ///
    public init(
        _ input: Node,
        cutoffFrequency: AUValue = 1_000,
        resonance: AUValue = 0.5
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.cutoffFrequency = cutoffFrequency
            self.resonance = resonance
        }
        connections.append(input)
    }
}

//
//  CardiovascularArticleView.swift
//  AQI
//
//  Dedicated content view for the cardiovascular article.
//

import SwiftUI
import Combine

struct CardiovascularArticleView: View {
    @State private var showAR = false
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ArticleSectionView(
                title: "What Exactly Is PM2.5?",
                bodyText: "Every time you take a breath, you inhale a mixture of gases and tiny particles suspended in the air. Among them is PM2.5 particulate matter that measures 2.5 micrometers or smaller in diameter.\n\nTo understand how small that is, consider this: a human hair is about 70 micrometers wide. PM2.5 is nearly thirty times smaller. These particles are invisible under normal conditions, yet they are present in the air around us especially in urban environments.\n\nBecause of their size, PM2.5 particles behave differently from larger dust. They remain suspended in the air for longer periods and travel greater distances."
            )

            // INTERACTION INSERT POINT — Scale Explorer
            // Add ScaleExplorerView() here.
            // Purpose: After explaining "PM2.5 is nearly thirty times smaller", this interaction should allow the user
            // to zoom into a human hair and gradually reveal floating PM2.5 particles.
            // This builds intuitive understanding of microscopic scale and size comparison.
            ScaleExplorerView()

            // ILLUSTRATION INSERT POINT — Particle Suspension Animation
            // Add ParticleSuspensionAnimationView() here.
            // Purpose: After explaining that PM2.5 remains suspended longer, show an animated comparison where
            // a large dust particle falls quickly and a PM2.5 particle floats slowly and drifts.
            // This reinforces behavioral differences visually.
            ParticleSuspensionAnimationView()

            ArticleSectionView(
                title: "Why Size Makes It Dangerous",
                bodyText: "The danger of PM2.5 lies in its scale.\n\nLarger particles are usually trapped by the nose or throat. PM2.5 bypasses these defenses. It travels deep into the lungs and may enter the bloodstream. Over time, repeated exposure can increase the risk of respiratory illness, cardiovascular disease, and stroke.\n\nThe World Health Organization reports that air pollution contributes to millions of premature deaths each year, and fine particulate matter is one of the primary causes.\n\nThe effects are not immediate. They accumulate gradually through long-term exposure."
            )

            // ILLUSTRATION INSERT POINT — Lung Penetration Visualization
            // Add LungPenetrationAnimationView() here.
            // Purpose: After explaining that PM2.5 travels deep into the lungs and bloodstream,
            // animate airflow entering the lungs where larger particles stop early and PM2.5 penetrates deeper.
            // This helps users understand the biological danger visually.
            LungPenetrationAnimationView()

            ArticleSectionView(
                title: "Where Does PM2.5 Come From?",
                bodyText: "PM2.5 is produced by both human activity and natural processes.\n\nIn cities, common sources include vehicle exhaust, power plants, industrial emissions, construction activity, and burning of fuels. Natural sources such as wildfires and dust storms can also increase particle levels.\n\nBecause these particles are extremely small, they can travel across cities and even between countries. This makes air pollution a regional and global issue not just a local one.\n\nThe United Nations Environment Programme emphasizes that understanding air pollution is the first step toward reducing its impact."
            )

            // ILLUSTRATION INSERT POINT — Pollution Source Visualization
            // Add PM25SourceIllustrationView() here.
            // Purpose: Show a simple animated city scene with cars, factories, and construction emitting particles.
            // This connects real-world pollution sources to PM2.5 visually.
            PM25SourceIllustrationView()

            ArticleSectionView(
                title: "Why You May Not Notice It",
                bodyText: "One of the most challenging aspects of PM2.5 is that it is often invisible.\n\nWhile heavy pollution can appear as smog, harmful levels may still exist even when the sky looks clear. Human perception is not a reliable tool for detecting fine particles.\n\nThis is why monitoring systems measure air quality scientifically. The Air Quality Index (AQI) translates these measurements into understandable categories, helping individuals make informed decisions.\n\nRelying on AQI data is far more accurate than judging air quality visually."
            )

            // INTERACTION INSERT POINT — Invisible Pollution Reveal
            // Add AQIRevealInteractionView() here.
            // Purpose: Show a clean scene initially, then allow the user to tap "Reveal Particles"
            // to visualize hidden PM2.5 and display an AQI label.
            // This teaches that harmful pollution can exist even when air appears clean.
            AQIRevealInteractionView()

            // CAPSTONE INTERACTION — AR Visualization
            // The AR experience below serves as the final immersive learning step.
            // No additional components needed here, but maintain this as the climax of the learning flow.

            ArticleARSection(
                title: "Seeing the Invisible: AR Visualization",
                bodyText: "Understanding microscopic particles through text alone can be abstract. To make this concept easier to grasp, this app includes an augmented reality (AR) visualization.\n\nWhen you tap Open AR, a visual model of floating particles will appear in your physical space. This experience is designed to support learning by helping you visualize how fine particulate matter may exist around you.\n\nThe AR particles are educational representations. They are not to scale and do not reflect the real-time concentration of PM2.5 in your surroundings. For accurate air quality information, always consult official AQI sources such as the United States Environmental Protection Agency or other government monitoring agencies.\n\nThe purpose of this feature is simple: to transform an invisible scientific concept into something understandable.",
                buttonTitle: "Open AR"
            ) {
                showAR = true
            }

            ReferenceLinksSection(
                title: "References",
                buttonTitle: "Reference Link",
                references: [
                    ReferenceLink(
                        title: "United Nations Environment Programme – Air pollution: Know your enemy",
                        url: URL(string: "https://www.unep.org/news-and-stories/story/air-pollution-know-your-enemy")!
                    ),
                    ReferenceLink(
                        title: "World Health Organization – Air Pollution Overview",
                        url: URL(string: "https://www.who.int/health-topics/air-pollution")!
                    ),
                    ReferenceLink(
                        title: "United States Environmental Protection Agency – Particulate Matter (PM) Basics",
                        url: URL(string: "https://www.epa.gov/pm-pollution")!
                    )
                ]
            )
        }
        .fullScreenCover(isPresented: $showAR) {
            PM25OverlayView()
        }
    }
}

private struct ScaleExplorerView: View {
    @State private var zoomLevel: Double = 0.0

    private let particleOffsets: [CGPoint] = [
        CGPoint(x: 0.18, y: 0.28),
        CGPoint(x: 0.31, y: 0.62),
        CGPoint(x: 0.44, y: 0.40),
        CGPoint(x: 0.58, y: 0.70),
        CGPoint(x: 0.69, y: 0.33),
        CGPoint(x: 0.78, y: 0.57),
        CGPoint(x: 0.24, y: 0.78),
        CGPoint(x: 0.52, y: 0.18)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scale Explorer")
                .font(.headline)

            Text("Drag to zoom from a human hair to PM2.5-sized particles.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let reveal = zoomLevel
                let baseHairWidth = width * 0.22
                let baseHairHeight: CGFloat = 8
                let minHairScale: CGFloat = 0.65
                let desiredMaxScale: CGFloat = 3.2
                let maxScaleByWidth = (width * 0.86) / baseHairWidth
                let maxScaleByHeight = (height * 0.42) / baseHairHeight
                let maxHairScale = max(minHairScale, min(desiredMaxScale, maxScaleByWidth, maxScaleByHeight))
                let hairScale = minHairScale + (maxHairScale - minHairScale) * CGFloat(zoomLevel)
                let renderedHairWidth = baseHairWidth * hairScale
                // Preserve the educational 30:1 visual comparison during zoom (hair : PM2.5).
                let particleDiameter = renderedHairWidth / 30
                let particleRevealScale = reveal > 0.45 ? (0.6 + (reveal - 0.45) * 0.8) : 0.2

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.08), Color.cyan.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    ForEach(Array(particleOffsets.enumerated()), id: \.offset) { _, point in
                        Circle()
                            .fill(Color.orange.opacity(0.8))
                            .frame(width: particleDiameter, height: particleDiameter)
                            .position(x: point.x * width, y: point.y * geo.size.height)
                            .opacity(reveal > 0.45 ? min(1, (reveal - 0.45) * 2) : 0)
                            .scaleEffect(particleRevealScale)
                            .animation(.easeInOut(duration: 0.2), value: particleDiameter)
                    }

                    ZStack {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.brown.opacity(0.4), Color.brown.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                            )

                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: baseHairWidth * 0.78, height: baseHairHeight * 0.22)
                            .offset(y: -baseHairHeight * 0.12)

                        Capsule()
                            .fill(Color.black.opacity(0.08))
                            .frame(width: baseHairWidth * 0.9, height: baseHairHeight * 0.18)
                            .offset(y: baseHairHeight * 0.16)
                    }
                    .frame(width: baseHairWidth, height: baseHairHeight)
                    .scaleEffect(hairScale, anchor: .center)
                    .animation(.easeInOut(duration: 0.2), value: hairScale)

                    VStack {
                        Spacer()
                        HStack {
                            Text("Human hair")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                            Spacer()
                            if reveal > 0.45 {
                                Text("PM2.5 appears")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .transition(.opacity)
                            }
                        }
                        .padding(10)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: 170)

            HStack {
                Text("Zoom")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Slider(value: $zoomLevel, in: 0...1)
                Text("\(Int(zoomLevel * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(width: 42, alignment: .trailing)
            }

            Text(zoomLevel < 0.45 ? "At this scale, the hair dominates the frame." : "As you zoom further, PM2.5 particles become visible relative to the hair.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

private struct ParticleSuspensionAnimationView: View {
    @State private var simulation = ParticleSuspensionSimulation.makeDefault()
    @State private var lastTickDate: Date?
    private let simulationTimer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Particle Suspension Comparison")
                .font(.headline)

            Text("Larger dust settles quickly, while PM2.5 drifts and remains suspended.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let width = geo.size.width
                let laneWidth = (width - 24) / 2

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.08))

                    HStack(spacing: 12) {
                        ParticleSuspensionLaneView(
                            title: "Large Dust",
                            subtitle: "Falls quickly",
                            accentColor: .brown,
                            laneStyle: .heavy,
                            particles: simulation.heavyLane.particles,
                            airPulseStrength: simulation.heavyLane.airPulseStrength,
                            laneWidth: laneWidth
                        )

                        ParticleSuspensionLaneView(
                            title: "PM2.5",
                            subtitle: "Stays suspended longer",
                            accentColor: .orange,
                            laneStyle: .fine,
                            particles: simulation.fineLane.particles,
                            airPulseStrength: simulation.fineLane.airPulseStrength,
                            laneWidth: laneWidth
                        )
                    }
                    .padding(6)
                }
            }
            .frame(height: 240)

            HStack(spacing: 10) {
                Button("Air Pulse") {
                    simulation.triggerAirPulse()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                Text("Heavy particles lift slightly and settle fast; PM2.5 rises and drifts longer.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
        .onReceive(simulationTimer) { now in
            let delta = min(max(now.timeIntervalSince(lastTickDate ?? now), 0), 1.0 / 20.0)
            lastTickDate = now
            simulation.step(deltaTime: delta)
        }
        .onAppear {
            lastTickDate = Date()
        }
    }
}

private struct ParticleSuspensionLaneView: View {
    let title: String
    let subtitle: String
    let accentColor: Color
    let laneStyle: ParticleSuspensionLaneStyle
    let particles: [SuspensionParticle]
    let airPulseStrength: CGFloat
    let laneWidth: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.62))

            GeometryReader { geo in
                let laneHeight = geo.size.height
                let floorHeight = laneHeight * 0.11
                let topInset: CGFloat = 30
                let sideInset: CGFloat = 10
                let usableHeight = max(1, laneHeight - floorHeight - topInset - 6)
                let usableWidth = max(1, geo.size.width - (sideInset * 2))

                ZStack(alignment: .bottom) {
                    // Airflow visualization that brightens during the pulse.
                    LinearGradient(
                        colors: [
                            accentColor.opacity(Double(airPulseStrength) * 0.26),
                            accentColor.opacity(Double(airPulseStrength) * 0.10),
                            Color.clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.14), Color.gray.opacity(0.24)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: floorHeight)
                            .overlay(alignment: .top) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.55))
                                    .frame(height: 1)
                            }
                    }

                    ForEach(particles) { particle in
                        let particleDiameter = usableWidth * particle.sizeRatio
                        Circle()
                            .fill(accentColor.opacity(particle.opacity))
                            .frame(
                                width: particleDiameter,
                                height: particleDiameter
                            )
                            .shadow(color: accentColor.opacity(0.18), radius: laneStyle == .fine ? 2 : 1)
                            .position(
                                x: sideInset + (particle.position.x * usableWidth),
                                y: laneHeight - floorHeight - (particle.position.y * usableHeight) - (particleDiameter / 2)
                            )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 24)
            .padding(.horizontal, 6)
            .padding(.bottom, 6)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption.weight(.semibold))
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
        }
        .frame(width: laneWidth)
    }
}

private enum ParticleSuspensionLaneStyle: Equatable {
    case heavy
    case fine
}

private struct SuspensionParticle: Identifiable {
    let id: Int
    var position: CGPoint // Normalized lane coordinates: x in [0,1], y = height above floor in [0,1]
    var velocity: CGVector // Normalized units / second
    let sizeRatio: CGFloat // Relative to lane width
    let opacity: Double
    let driftPhase: CGFloat
    let driftFrequency: CGFloat
    let pulseResponse: CGFloat
}

private struct SuspensionPhysicsConfiguration {
    let gravity: CGFloat
    let verticalDrag: CGFloat
    let lateralDrag: CGFloat
    let driftStrength: CGFloat
    let secondaryDriftStrength: CGFloat
    let verticalFlutterStrength: CGFloat
    let ambientLift: CGFloat
    let airPulseAcceleration: CGFloat
    let pulseDecayRate: CGFloat
    let floorBounceDamping: CGFloat
    let floorStickVelocity: CGFloat
    let maxHeight: CGFloat
    let maxHorizontalSpeed: CGFloat
    let maxVerticalSpeed: CGFloat
}

private struct ParticleSuspensionLaneSimulation {
    var particles: [SuspensionParticle]
    var airPulseStrength: CGFloat
    let physics: SuspensionPhysicsConfiguration

    mutating func triggerAirPulse() {
        // Build airflow over repeated taps so fine particles rise progressively instead of spiking to the top.
        airPulseStrength = min(1.0, airPulseStrength + 0.50)
    }

    mutating func step(deltaTime dt: CGFloat, elapsedTime: CGFloat) {
        guard dt > 0 else { return }

        airPulseStrength = max(0, airPulseStrength - physics.pulseDecayRate * dt)
        let upwardFlow = physics.airPulseAcceleration * airPulseStrength
        let minX: CGFloat = 0.02
        let maxX: CGFloat = 0.98

        for index in particles.indices {
            var particle = particles[index]

            let airborneFactor = max(0, min(1, particle.position.y + 0.12))
            let driftWave = sin((elapsedTime * particle.driftFrequency) + particle.driftPhase)
            let secondaryDriftWave = sin((elapsedTime * (particle.driftFrequency * 1.87)) + (particle.driftPhase * 0.73))
            let flutterWave = sin((elapsedTime * (particle.driftFrequency * 2.35)) + (particle.driftPhase * 1.21))
            let pulseTurbulence = airPulseStrength * (0.82 + (0.18 * sin((elapsedTime * 6.0) + (particle.position.x * .pi * 2.2))))

            let horizontalAcceleration =
                (driftWave * physics.driftStrength * airborneFactor) +
                (secondaryDriftWave * physics.secondaryDriftStrength * (0.35 + airborneFactor)) -
                (particle.velocity.dx * physics.lateralDrag)

            // Gravity pulls particles down; drag and the pulse-driven airflow can keep lighter particles suspended.
            let verticalAcceleration =
                (upwardFlow * particle.pulseResponse * pulseTurbulence) +
                ((upwardFlow - particle.velocity.dy) * physics.verticalDrag) -
                (flutterWave * physics.verticalFlutterStrength * (0.2 + airborneFactor)) +
                (physics.ambientLift * airborneFactor) -
                physics.gravity

            particle.velocity.dx += horizontalAcceleration * dt
            particle.velocity.dy += verticalAcceleration * dt
            particle.velocity.dx = min(max(particle.velocity.dx, -physics.maxHorizontalSpeed), physics.maxHorizontalSpeed)
            particle.velocity.dy = min(max(particle.velocity.dy, -physics.maxVerticalSpeed), physics.maxVerticalSpeed)

            particle.position.x += particle.velocity.dx * dt
            particle.position.y += particle.velocity.dy * dt

            if particle.position.x < minX {
                particle.position.x = minX
                particle.velocity.dx *= -0.25
            } else if particle.position.x > maxX {
                particle.position.x = maxX
                particle.velocity.dx *= -0.25
            }

            if particle.position.y < 0 {
                particle.position.y = 0
                if abs(particle.velocity.dy) <= physics.floorStickVelocity {
                    particle.velocity.dy = 0
                    particle.velocity.dx *= 0.45
                } else {
                    particle.velocity.dy = -particle.velocity.dy * physics.floorBounceDamping
                    particle.velocity.dx *= 0.75
                }
            } else if particle.position.y > physics.maxHeight {
                particle.position.y = physics.maxHeight
                particle.velocity.dy *= -0.12
            }

            if particle.position.y == 0 && airPulseStrength < 0.02 {
                particle.velocity.dx *= max(0, 1 - (3.5 * dt))
                particle.velocity.dy = 0
            }

            particles[index] = particle
        }
    }
}

private struct ParticleSuspensionSimulation {
    var heavyLane: ParticleSuspensionLaneSimulation
    var fineLane: ParticleSuspensionLaneSimulation
    var elapsedTime: CGFloat = 0

    mutating func triggerAirPulse() {
        heavyLane.triggerAirPulse()
        fineLane.triggerAirPulse()
    }

    mutating func step(deltaTime: TimeInterval) {
        let dt = CGFloat(deltaTime)
        guard dt > 0 else { return }
        elapsedTime += dt
        heavyLane.step(deltaTime: dt, elapsedTime: elapsedTime)
        fineLane.step(deltaTime: dt, elapsedTime: elapsedTime)
    }

    static func makeDefault() -> ParticleSuspensionSimulation {
        ParticleSuspensionSimulation(
            heavyLane: .init(
                particles: makeParticles(
                    count: 12,
                    startID: 0,
                    sizeRange: 0.046...0.065,
                    opacityRange: 0.65...0.9,
                    pulseResponseRange: 1.08...1.22,
                    driftFrequencyRange: 0.7...1.25,
                    driftPhaseOffset: 0
                ),
                airPulseStrength: 0,
                physics: SuspensionPhysicsConfiguration(
                    gravity: 3.05,
                    verticalDrag: 0.78,
                    lateralDrag: 3.2,
                    driftStrength: 0.20,
                    secondaryDriftStrength: 0.10,
                    verticalFlutterStrength: 0.07,
                    ambientLift: 0.05,
                    airPulseAcceleration: 4.25,
                    pulseDecayRate: 2.0,
                    floorBounceDamping: 0.10,
                    floorStickVelocity: 0.20,
                    maxHeight: 0.90,
                    maxHorizontalSpeed: 0.55,
                    maxVerticalSpeed: 1.45
                )
            ),
            fineLane: .init(
                particles: makeParticles(
                    count: 20,
                    startID: 1000,
                    sizeRange: 0.014...0.022,
                    opacityRange: 0.45...0.75,
                    pulseResponseRange: 1.14...1.30,
                    driftFrequencyRange: 1.0...2.1,
                    driftPhaseOffset: 1.2
                ),
                airPulseStrength: 0,
                physics: SuspensionPhysicsConfiguration(
                    gravity: 1.06,
                    verticalDrag: 1.88,
                    lateralDrag: 1.05,
                    driftStrength: 0.58,
                    secondaryDriftStrength: 0.26,
                    verticalFlutterStrength: 0.16,
                    ambientLift: 0.12,
                    airPulseAcceleration: 3.15,
                    pulseDecayRate: 0.94,
                    floorBounceDamping: 0.03,
                    floorStickVelocity: 0.08,
                    maxHeight: 0.96,
                    maxHorizontalSpeed: 0.95,
                    maxVerticalSpeed: 1.22
                )
            )
        )
    }

    private static func makeParticles(
        count: Int,
        startID: Int,
        sizeRange: ClosedRange<CGFloat>,
        opacityRange: ClosedRange<Double>,
        pulseResponseRange: ClosedRange<CGFloat>,
        driftFrequencyRange: ClosedRange<CGFloat>,
        driftPhaseOffset: CGFloat
    ) -> [SuspensionParticle] {
        guard count > 0 else { return [] }

        return (0..<count).map { index in
            let t = CGFloat(index) / CGFloat(max(count - 1, 1))
            let jitter = pseudoRandom01(seed: startID + index)
            let jitter2 = pseudoRandom01(seed: (startID + index) * 17)
            let jitter3 = pseudoRandom01(seed: (startID + index) * 31)

            return SuspensionParticle(
                id: startID + index,
                position: CGPoint(
                    x: max(0.04, min(0.96, (0.08 + (0.84 * t)) + ((jitter - 0.5) * 0.10))),
                    y: 0
                ),
                velocity: CGVector(dx: 0, dy: 0),
                sizeRatio: lerp(sizeRange.lowerBound, sizeRange.upperBound, t: jitter),
                opacity: lerp(opacityRange.lowerBound, opacityRange.upperBound, t: Double(jitter2)),
                driftPhase: (jitter3 * .pi * 2) + driftPhaseOffset,
                driftFrequency: lerp(driftFrequencyRange.lowerBound, driftFrequencyRange.upperBound, t: jitter2),
                pulseResponse: lerp(pulseResponseRange.lowerBound, pulseResponseRange.upperBound, t: jitter3)
            )
        }
    }

    private static func pseudoRandom01(seed: Int) -> CGFloat {
        let x = sin((Double(seed) * 12.9898) + 78.233) * 43758.5453
        return CGFloat(x - floor(x))
    }

    private static func lerp(_ a: CGFloat, _ b: CGFloat, t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    private static func lerp(_ a: Double, _ b: Double, t: Double) -> Double {
        a + (b - a) * t
    }
}

private struct LungPenetrationAnimationView: View {
    @State private var flow = false

    private let pmPathPoints: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.12),
        CGPoint(x: 0.50, y: 0.26),
        CGPoint(x: 0.54, y: 0.38),
        CGPoint(x: 0.60, y: 0.52),
        CGPoint(x: 0.66, y: 0.66)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Lung Penetration Visualization")
                .font(.headline)

            Text("Larger particles tend to stop earlier, while PM2.5 can travel deeper into the lungs.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.06))

                    Path { path in
                        path.move(to: CGPoint(x: w * 0.5, y: h * 0.08))
                        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.28))
                        path.addLine(to: CGPoint(x: w * 0.38, y: h * 0.45))
                        path.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
                        path.addLine(to: CGPoint(x: w * 0.62, y: h * 0.45))
                    }
                    .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))

                    Ellipse()
                        .fill(Color.pink.opacity(0.18))
                        .frame(width: w * 0.28, height: h * 0.46)
                        .position(x: w * 0.38, y: h * 0.6)
                    Ellipse()
                        .fill(Color.pink.opacity(0.18))
                        .frame(width: w * 0.28, height: h * 0.46)
                        .position(x: w * 0.62, y: h * 0.6)

                    Circle()
                        .fill(Color.brown)
                        .frame(width: 14, height: 14)
                        .position(
                            x: w * (flow ? 0.42 : 0.50),
                            y: h * (flow ? 0.36 : 0.18)
                        )
                        .overlay(
                            Text("X")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white)
                        )

                    ForEach(Array(pmPathPoints.enumerated()), id: \.offset) { index, point in
                        Circle()
                            .fill(Color.orange.opacity(0.8))
                            .frame(width: 7, height: 7)
                            .position(
                                x: w * ((flow ? point.x : 0.5) + (flow ? 0 : 0)),
                                y: h * (flow ? point.y : 0.12)
                            )
                            .opacity(flow ? 1 : (index == 0 ? 1 : 0))
                            .animation(
                                .easeInOut(duration: 1.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.12),
                                value: flow
                            )
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Text("Large particle: stops early")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                            Spacer()
                            Text("PM2.5: penetrates deeper")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                        .padding(10)
                    }
                }
            }
            .frame(height: 210)
            .onAppear {
                flow = true
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

private struct PM25SourceIllustrationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PM2.5 Source Illustration")
                .font(.headline)

            Text("Common urban sources include traffic, industry, and construction activity.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)

                    // Force a white canvas so transparent pixels in the source image never inherit parent backgrounds.
                    Color.white

                    Image("pm2.5source")
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .padding(10)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(height: 200)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

private struct AQIRevealInteractionView: View {
    @State private var showParticles = false
    @State private var pulse = false

    private let hiddenParticlePoints: [CGPoint] = [
        CGPoint(x: 0.12, y: 0.28),
        CGPoint(x: 0.20, y: 0.43),
        CGPoint(x: 0.29, y: 0.62),
        CGPoint(x: 0.36, y: 0.35),
        CGPoint(x: 0.47, y: 0.52),
        CGPoint(x: 0.55, y: 0.30),
        CGPoint(x: 0.64, y: 0.44),
        CGPoint(x: 0.72, y: 0.57),
        CGPoint(x: 0.82, y: 0.37),
        CGPoint(x: 0.88, y: 0.50)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Invisible Pollution Reveal")
                .font(.headline)

            Text("A clear-looking scene can still contain harmful PM2.5.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.14), Color.white],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Circle()
                        .fill(Color.yellow.opacity(0.5))
                        .frame(width: 42, height: 42)
                        .blur(radius: 1)
                        .offset(x: -14, y: 14)

                    Rectangle()
                        .fill(Color.green.opacity(0.2))
                        .frame(height: h * 0.2)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .offset(y: h * 0.4)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.65))
                        .frame(width: w * 0.14, height: h * 0.26)
                        .offset(x: -w * 0.28, y: h * 0.1)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.55))
                        .frame(width: w * 0.1, height: h * 0.2)
                        .offset(x: -w * 0.16, y: h * 0.16)

                    ForEach(Array(hiddenParticlePoints.enumerated()), id: \.offset) { index, point in
                        Circle()
                            .fill(Color.orange.opacity(showParticles ? 0.65 : 0))
                            .frame(width: 5, height: 5)
                            .position(
                                x: point.x * w + (pulse && showParticles ? CGFloat((index % 3) - 1) * 2 : 0),
                                y: point.y * h + (pulse && showParticles ? CGFloat((index % 2 == 0) ? -2 : 2) : 0)
                            )
                            .animation(
                                .easeInOut(duration: 1.1)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.05),
                                value: showParticles
                            )
                    }

                    if showParticles {
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("AQI 136")
                                .font(.caption.weight(.bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.orange.opacity(0.9), in: Capsule())
                                .foregroundStyle(.white)

                            Text("Unhealthy for Sensitive Groups")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                        .padding(10)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
            .frame(height: 180)

            Button(showParticles ? "Hide Particles" : "Reveal Particles") {
                withAnimation(.easeInOut(duration: 0.35)) {
                    showParticles.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(showParticles ? .gray : .blue)

            Text(showParticles ? "Even when the sky looks clear, AQI monitoring may detect dangerous fine particles." : "Tap to reveal hidden particles and an AQI category.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
        .onAppear {
            pulse = true
        }
    }
}

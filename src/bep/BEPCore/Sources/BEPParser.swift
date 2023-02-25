import Foundation
import src_main_java_com_google_devtools_build_lib_buildeventstream_proto_build_event_stream_proto
import SwiftProtobuf

public protocol BEPParser {

    func readEvents(bepPath: String) throws -> [BuildEventStream_BuildEvent]
}

public final class BEPParserImp: BEPParser {

    enum Error: Swift.Error, CustomStringConvertible {
        case missingBEPFile(path: String)
        case bepParsingFailed(errors: [Swift.Error])

        var description: String {
            switch self {
            case let .missingBEPFile(path: path):
                return "Missing BEP file at path: \(path)"
            case let .bepParsingFailed(errors: errors):
                let errorString: String = errors.map { "- \($0)" }.joined(separator: "\n")
                return """
                BEP parsing failed with the following errors:
                \(errorString)
                """
            }
        }
    }

    public init() {}

    // [CW] 2/18/23 - Adapted from:
    // https://github.com/target/XCBBuildServiceProxy/blob/99392b04696f710be47b2c6297ea362c0a33d30c/Examples/BazelXCBBuildService/Sources/BazelBuildProcess.swift#L81
    public func readEvents(bepPath: String) throws -> [BuildEventStream_BuildEvent] {
        guard let bepFileHandle: FileHandle = .init(forReadingAtPath: bepPath) else {
            throw Error.missingBEPFile(path: bepPath)
        }
        let semaphore: DispatchSemaphore = .init(value: 0)
        var buildEvents: [BuildEventStream_BuildEvent] = []
        var errors: [Swift.Error] = []
        bepFileHandle.readabilityHandler = { fileHandle in
            let data: Data = fileHandle.availableData
            guard !data.isEmpty else {
                return
            }
            let input: InputStream = .init(data: data)
            input.open()
            while input.hasBytesAvailable {
                do {
                    let event: BuildEventStream_BuildEvent = try BinaryDelimited.parse(
                        messageType: BuildEventStream_BuildEvent.self,
                        from: input)
                    buildEvents.append(event)
                    if event.lastMessage {
                        fileHandle.closeFile()
                        fileHandle.readabilityHandler = nil
                        semaphore.signal()
                    }
                } catch {
                    errors.append(error)
                    return
                }
            }
        }
        _ = semaphore.wait(timeout: .now() + 30)
        guard errors.isEmpty else {
            throw Error.bepParsingFailed(errors: errors)
        }
        return buildEvents
    }
}

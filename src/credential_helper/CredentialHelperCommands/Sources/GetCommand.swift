import ArgumentParser
import Foundation
import PathKit

internal final class GetCommand: ParsableCommand {

    private struct GetInput: Codable {
        internal let uri: String
    }

    private struct GetOutput: Codable {
        internal let headers: [String: [String]]
    }

    internal static let configuration: CommandConfiguration = .init(
        commandName: "get",
        abstract: "A tool for obtaining credentials, per https://github.com/bazelbuild/proposals/blob/main/designs/2022-06-07-bazel-credential-helpers.md.")

    internal func run() throws {
        let accessToken: String = try makeAccessToken().trimmingCharacters(in: .whitespacesAndNewlines)
        let output: GetOutput = .init(
            headers: [
                "Authorization": [
                    "token \(accessToken)"
                ],
            ]
        )
        print(
            String(
                decoding: try JSONEncoder().encode(output),
                as: UTF8.self
            )
        )
    }

    private func makeAccessToken() throws -> String {
        let path: Path = .current + "demo" + "credentials.txt"
        return try path.read()
    }
}

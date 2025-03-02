import Stencil

internal protocol RenderService {

    func render(
        template: String,
        context: [String: Any ]
    ) throws -> String
}

internal final class RenderServiceImp: RenderService {

    internal func render(
        template: String,
        context: [String: Any ]
    ) throws -> String {
        try Environment().renderTemplate(
            string: template,
            context: context
        )
    }
}

import Foundation
import SwiftSyntax

func main() throws {
    let args = Array<String>(CommandLine.arguments.dropFirst())
    
    if args.count < 1 {
        fatalError("not specified file")
    }
    
    let path = args[0]

  let source = try Syntax.parse(URL(fileURLWithPath: path))

    print(source)
}


try main()

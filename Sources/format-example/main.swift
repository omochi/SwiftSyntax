import Foundation
import SwiftSyntax

struct Error : Swift.Error, CustomStringConvertible {
    init(_ message: String) {
        self.message = message
    }
    var message: String
    var description: String {
        return "Error(\(message))"
    }
}

class ClassDecl : CustomStringConvertible {
    init(token: Syntax,
         visibilityIndex: Int?,
         classKeywordIndex: Int,
         nameIndex: Int)
    {
        self.token = token
        self.visibilityIndex = visibilityIndex
        self.classKeywordIndex = classKeywordIndex
        self.nameIndex = nameIndex
    }
    
    var token: Syntax
    var visibilityIndex: Int?
    var visibilityToken: TokenSyntax? {
        return visibilityIndex.map {
            token.child(at: $0) as! TokenSyntax
        }
    }
    
    var classKeywordIndex: Int
    var classKeywordToken: TokenSyntax {
        return token.child(at: classKeywordIndex) as! TokenSyntax
    }
    
    var nameIndex: Int
    var nameToken: TokenSyntax {
        return token.child(at: nameIndex) as! TokenSyntax
    }
    
    var description: String {
        return "ClassDecl(\(visibilityToken?.text ?? "--"), \(nameToken.text))"
    }
    
    func updateVisibility(kind: TokenKind) {
        var newTokens = Array<TokenSyntax>(token.children.map { $0 as! TokenSyntax })
        
        var newVisibilityToken = SyntaxFactory.makeToken(kind, presence: .present)
            .withTrailingTrivia(Trivia.spaces(1))
        if let vt = visibilityToken {
            newVisibilityToken = newVisibilityToken
                .withLeadingTrivia(vt.leadingTrivia)
                .withTrailingTrivia(vt.trailingTrivia)
            newTokens.remove(at: vt.indexInParent)
            classKeywordIndex -= 1
            nameIndex -= 1
        }
        
        var classKeywordToken = self.classKeywordToken
        newVisibilityToken = newVisibilityToken.withLeadingTrivia(classKeywordToken.leadingTrivia)
        classKeywordToken = classKeywordToken.withoutLeadingTrivia()
        
        newTokens[classKeywordIndex] = classKeywordToken
        
        newTokens.insert(newVisibilityToken, at: classKeywordIndex)
        classKeywordIndex += 1
        nameIndex += 1
        visibilityIndex = classKeywordIndex - 1
        
        token = SyntaxFactory.makeUnknownSyntax(tokens: newTokens)
    }
}

class Processor {
    func process(source: SourceFileSyntax) throws {
        for decl in source.topLevelDecls {
            if let unk = decl as? UnknownDeclSyntax {
                let obj = try parseTopLevel(unknownDecl: unk)
                switch obj {
                case let cls as ClassDecl:
                    cls.updateVisibility(kind: .fileprivateKeyword)
                    print(cls.token, terminator: "")
                    break
                default:
                    break
                }
            }
        }
        print("")
        
        print("-- debug --")
        indent = 0
        process(node: source)
    }
    
    private func parseTopLevel(unknownDecl: UnknownDeclSyntax) throws -> AnyObject? {
        let children = Array<Syntax>(unknownDecl.children)
        var i = 0
        while i < children.count {
            let child = children[i]
            i += 1
            if let token = child as? TokenSyntax {
                if token.text == "class" {
                    return try parse(classDecl: unknownDecl)
                } else if token.text == "{" {
                    break
                }
            }
        }
        return nil
    }
    
    private func parse(classDecl: UnknownDeclSyntax) throws -> ClassDecl {
        var visibilityToken: TokenSyntax?
        var classKeywordTokenOpt: TokenSyntax?
        var nameTokenOpt: TokenSyntax?
        
        let children = Array<TokenSyntax>(classDecl.children.map { $0 as! TokenSyntax })
        var i = 0
        while i < children.count {
            let child = children[i]
            i += 1
            let token: TokenSyntax = child
            let text = token.text
            if text == "public" || text == "internal" || text == "fileprivate" || text == "private" {
                visibilityToken = token
            }
            if text == "class" {
                classKeywordTokenOpt = token
                break
            }
        }
        guard let classKeywordToken = classKeywordTokenOpt else {
            throw Error("no class keyword")
        }
        while i < children.count {
            let child = children[i]
            i += 1
            let token: TokenSyntax = child
            nameTokenOpt = token
            break
        }
        guard let nameToken = nameTokenOpt else {
            throw Error("no class name")
        }

        return ClassDecl(token: classDecl,
                         visibilityIndex: visibilityToken?.indexInParent,
                         classKeywordIndex: classKeywordToken.indexInParent,
                         nameIndex: nameToken.indexInParent)
    }
    
    private func process(node: Syntax) {
        print("[\(indent)] process type: \(type(of: node))")
        if let token = node as? TokenSyntax {
            print("  text: \(token.text)")
            print("  leading: \(token.leadingTrivia)")
            print("  trailing: \(token.trailingTrivia)")
        }
        
        indent += 1
        for child in node.children {
            process(node: child)
        }
        indent -= 1
    }
    
    private var indent: Int = 0
}

func main() throws {
    let args = Array<String>(CommandLine.arguments.dropFirst())
    
    if args.count < 1 {
        fatalError("not specified file")
    }
    
    let path = args[0]
    
    let source = try Syntax.parse(URL(fileURLWithPath: path))
    let processor = Processor()
    try processor.process(source: source)
}

try main()

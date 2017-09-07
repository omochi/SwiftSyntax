# SwiftSyntax

This repository is separated package of SwiftSyntax.

SwiftSyntax: https://github.com/apple/swift/tree/master/tools/SwiftSyntax

This package can be use from SwiftPM.

# Requirement

Install new swift which supports libSyntax API.
2017-09-07 snapshot is ok.

https://swift.org/download/#snapshots

And select it in Xcode > Preference > Components > Toolchains.

# Example

```
$ swift run format-example foo.swift
```

This is passingthrough with parse and print example.

```swift
    let source = try Syntax.parse(URL(fileURLWithPath: path))
    print(source)
```

# License

This repository is fork of apple/swift.
This is Apache License.

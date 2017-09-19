# SwiftSyntax

This repository is separated package of SwiftSyntax.

SwiftSyntax: https://github.com/apple/swift/tree/master/tools/SwiftSyntax

This package can be use from SwiftPM.

# Requirement

Install newer swift which supports libSyntax API.
2017-09-18 snapshot is ok.

https://swift.org/download/#snapshots

And specify it via `TOOLCHAINS` environment variable.

example

```
$ export TOOLCHAINS=org.swift.3020170918a
$ swift build
```

# Using example

See SwiftPack code using SwiftSyntax.

https://github.com/omochi/SwiftPack.git

# License

This repository is fork of apple/swift.
This is Apache License.

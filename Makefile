SDK="`xcrun --sdk iphonesimulator --show-sdk-path`"
TARGET="arm64-apple-ios12.0-simulator"

clean:
	rm -rf Sources/.build

build:
	(cd Sources && swift build -Xswiftc "-sdk" -Xswiftc $(SDK) -Xswiftc "-target" -Xswiftc $(TARGET))

test:
	(cd Sources && swift test -Xswiftc "-sdk" -Xswiftc $(SDK) -Xswiftc "-target" -Xswiftc $(TARGET))

genstrings:
	(cd Sources && swift run -c release genstrings)

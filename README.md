# Development Aliases

`alias eventpanel-dev="$(find ~/Library/Developer/Xcode/DerivedData -name eventpanel -type f -path "*/Debug/eventpanel" | head -n 1)"`

The `eventpanel-dev` alias provides quick access to the debug build of the eventpanel executable. This alias automatically finds the most recently built debug version in your Xcode DerivedData directory, making it easier to run and test the application during development.

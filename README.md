# Development Aliases

alias eventpanel-dev="$(find ~/Library/Developer/Xcode/DerivedData -name eventpanel -type f -path "*/Debug/eventpanel" | head -n 1)"

The `eventpanel-dev` alias provides quick access to the debug build of the eventpanel executable. This alias automatically finds the most recently built debug version in your Xcode DerivedData directory, making it easier to run and test the application during development.

```
# Usage

    $ eventpanel COMMAND

    EventPanel, the event management system.

Commands:
    + add            Add event to EventPanel.yaml
    + deintegrate    Deintegrate EventPanel from your project
    + generate       Generate events according to versions from a EventPanel.yaml
    + help           Show this help message
    + init           Initializes EventPanel in the project by creating the necessary configuration files
    + install        Install events from the configuration file
    + list           List events (use --target to filter by target, --page-size to set items per page)
    + outdated       Show outdated events
    + pull           Fetch and store the latest scheme from the server
    + update         Update outdated events

Options:
    --verbose      Show more debugging information
    --help        Show help banner of specified command
```
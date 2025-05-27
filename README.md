# eventpanel

```
OVERVIEW: EventPanel, the event management system.

USAGE: eventpanel [--config <config>] [--verbose] <subcommand>

OPTIONS:
  --config <config>       Path to EventPanel.yaml configuration file
  --verbose               Enable verbose output
  -h, --help              Show help information.

SUBCOMMANDS:
  add                     Add event to EventPanel.yaml
  deintegrate             Deintegrate EventPanel from your project
  generate                Generate events according to versions from a EventPanel.yaml
  help                    Show this help message
  init                    Initializes EventPanel in the project by creating the necessary configuration files
  list                    List events
  outdated                Show outdated events
  pull                    Fetch and store the latest scheme from the server
  update                  Update events to their latest versions

AUTH SUBCOMMANDS:
  set-token               Set API token
  remove-token            Remove stored API token

  See 'eventpanel help <subcommand>' for detailed help.
```

# Installation

```bash
# Add the tap
brew tap eventpanel/eventpanel

export HOMEBREW_GITHUB_API_TOKEN=xxx

# Install EventPanel
brew install eventpanel
```

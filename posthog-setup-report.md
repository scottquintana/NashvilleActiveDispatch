<wizard-report>
# PostHog post-wizard report

The wizard has completed a deep integration of PostHog analytics into the Active Dispatch iOS app. The integration adds the posthog-ios SDK (v3.59.1) alongside the existing Firebase Analytics setup, capturing 8 new events that complement — without duplicating — the Firebase event set. PostHog is initialized in `AppDelegate` with lifecycle event capture enabled, and environment variables for the project token and host are set in the Xcode scheme.

| Event Name | Description | File |
|---|---|---|
| `city_selected` | User picks a city for the first time at app launch | `Controllers/CitySelectionViewController.swift` |
| `city_changed` | User changes their city mid-session from Settings | `Controllers/CitySelectionViewController.swift` |
| `settings_opened` | User opens the Settings screen via the gear button | `Controllers/ViewController.swift` |
| `filter_toggled` | User toggles the "Show all incident types" filter switch | `Controllers/SettingsViewController.swift` |
| `time_window_changed` | User adjusts the time window slider in Settings | `Controllers/SettingsViewController.swift` |
| `map_annotation_tapped` | User taps a specific incident pin on the map | `Controllers/MapViewController.swift` |
| `map_navigated` | User taps previous/next arrows to cycle map incidents | `Controllers/MapViewController.swift` |
| `incidents_loaded` | Initial feed loads successfully; includes raw incident count | `Controllers/ViewController.swift` |

## Next steps

We've built some insights and a dashboard for you to keep an eye on user behavior, based on the events we just instrumented:

- [Analytics basics dashboard](/dashboard/1638141)
- [City Popularity](/insights/eKhQP3J5) — which cities users choose at first launch, broken down by city
- [Map Engagement](/insights/eylfUzpy) — annotation taps vs. arrow navigation over time
- [Settings Usage](/insights/UnpdmSyl) — how often users open settings, toggle filters, and change the time window
- [Incidents Loaded per Session](/insights/hh16A7bL) — average incident count returned by the feed per app launch
- [City Switching Rate](/insights/6MWFkhsk) — first-time city selections vs. mid-session city changes

### Agent skill

We've left an agent skill folder in your project at `.claude/skills/integration-swift/`. You can use this context for further agent development when using Claude Code. This will help ensure the model provides the most up-to-date approaches for integrating PostHog.

</wizard-report>

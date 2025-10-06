# Bigger Notes

A very basic note-writing app, designed to help facilitate communication between Deaf and hearing people.

## Why this app exists

As a Deaf person, I often use my phone to type out what I want to say to someone. I noticed that some folks were having a hard time reading the small text of Apple’s Notes app. The Notes app has an option to format text as a title to make it bigger; however, the app resets the text to normal after hitting Return, forcing me to reformat every line I type. And even the title-formatted text wasn’t big enough in some cases: some people still squinted to read it! I couldn't find an existing app that had the exact features and level of usability that I was looking for, so I set out to create Bigger Notes to satisfy my own needs.

## Feedback

Please open an issue here on GitHub to report bugs or request new features. You can also email me at [biggernotes@jeff.ejeff.org](mailto:biggernotes@jeff.ejeff.org).

## Privacy

The app protects your privacy. Please see the [privacy policy](PRIVACY.md) for full details.

## Development

### Test deployment

To deploy a version to TestFlight, open a PR from a feature branch targeting the `main` branch. Xcode Cloud will automatically build and release to TestFlight. The title of the PR will be incorporated into the release notes later.

### App Store deployment

To deploy the contents of the `main` branch to the App Store, [draft a new release](https://github.com/jfredrickson/BiggerNotes/releases/new). Create a new tag following semantic versioning, like `v3.2.1`. Use the "Generate release notes" option. The title should be populated with the tag name, and the release description should be a list of all the PR titles since the last release. Xcode Cloud will automatically create a build, which can be submitted on App Store Connect (still a manual process).

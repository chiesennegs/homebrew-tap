# delta-wifi Homebrew tap

This tap installs published releases of [delta-wifi](https://github.com/chiesennegs/delta-wifi).

Once the first release has been published and the update workflow has populated the recipe:

```sh
brew install chiesennegs/tap/delta-wifi
delta-wifi wifi-perms
delta-wifi login
```

Upgrade:

```sh
brew update
brew upgrade delta-wifi
```

The default install is HTTP-only, with precompiled native helpers. Homebrew manages Python; users do not activate a virtual environment. App data and Keychain credentials remain separate from the installation. The initial helpers use development signing; stable Developer ID signing/notarization is not yet configured, so helper upgrades may require permission reauthorization.

Maintainers update the recipe from a published app release:

```sh
gh workflow run update.yml --repo chiesennegs/homebrew-tap -f version=0.3.0
```

The workflow checks the asset checksum, formula URL, version, and universal architectures before committing `Formula/delta-wifi.rb`. Draft releases cannot be installed by anonymous Homebrew users and are rejected by this workflow.

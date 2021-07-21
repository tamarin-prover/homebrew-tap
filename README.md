# Tamarin Prover Homebrew tap

This is a [Homebrew](https://brew.sh/) [tap](https://docs.brew.sh/Taps) for the [Tamarin prover](https://tamarin-prover.github.io).

## Installing

Install Homebrew and run

```
brew install tamarin-prover/tap/tamarin-prover
```

## Building bottles
Homebrew formulae can include compiled binaries, which it calls "bottles". To build a new bottle (perhaps for a new operating system or Tamarin release):

1. `brew install --build-bottle tamarin-prover/tap/tamarin-prover`
1. `brew bottle tamarin-prover --keep-old --root-url=https://dl.bintray.com/tamarin-prover-org/tamarin-prover` and note the output it gives you with the bottle SHA and tag
1. Rename the bottle to use a single hyphen (e.g., `tamarin-prover--1.4.1.mojave.bottle.tar.gz` to `tamarin-prover-1.4.1.mojave.bottle.tar.gz`). Homebrew should give you the relevant output on the command line to update in the `tamarin-prover.rb` formula. If not, on Linux, run sha256sum on the renamed file, and use the result to replace the bottle hash from previous item. On macOS, use `shasum -a 256 <filename>`.
1. Submit a separate pull request for https://github.com/tamarin-prover/binaries/ containing the new binaries.
1. Update the `tamarin-prover.rb` formula with the bottle SHA and tag, in the bottle section.

New installs will then use this bottle.

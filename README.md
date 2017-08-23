[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://travis-ci.org/onyxpoint/rubygem-sync_github_forks.svg?branch=master)](https://travis-ci.org/onyxpoint/rubygem-sync_github_forks)
[![Gem](https://img.shields.io/gem/v/sync_github_forks.svg)](https://rubygems.org/gems/sync_github_forks)
[![Gem_Downloads](https://img.shields.io/gem/dt/sync_github_forks.svg)](https://rubygems.org/gems/sync_github_forks)

# sync_github_forks

A simple application to synchronize forks of GitHub repositories.

## Installation

Running `gem install sync_github_forks` will provide the `sync_github_forks`
command

### Prerequisites

The script uses the command line `git` utility as provided by the underlying
operating system

## Configuration

The application will look for a file named `sync_github_forks.yaml` in the
following locations by default. This can be overridden using the
`SYNC_GITHUB_FORKS` environment variable.

  * $CWD/sync_github_forks.yaml
  * $CWD/.sync_github_forks.yaml
  * $HOME/.sync_github_forks.yaml
  * $HOME/.sync_github_forks/config.yaml

## Usage

For command usage, run `sync_github_forks -h`

## Feedback

Issues can be reported via the
[GitHub Issue Tracker](http://github.com/onyxpoint/rubygem-sync_github_forks)


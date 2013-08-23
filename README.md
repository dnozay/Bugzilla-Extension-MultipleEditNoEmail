# Bugzilla-Extension-MultipleEditNoEmail

This extension adds a checkbox when doing 
[bulk edit to not send an email](https://bugzilla.mozilla.org/show_bug.cgi?id=23924).
The rationale is that on some setups, too many emails is considered spam,
in particular when doing uninteresting changes that are for tracking
purposes only (e.g. keyword tagging, etc).

# Installation

Copy this directory into the `extensions` directory of your Bugzilla installation.
Then rename it to `MultipleEditNoEmail`.

# Git submodule

If you have your bugzilla code in git, you may add this extension as a submodule.

# Notes

The hook `bugmail_recipients` needs to run last.

- you can prefix the directory name with `z99_` (as well as the package name in the code), or
- you can patch your bugzilla installation with [this commit](https://github.com/dnozay/bugzilla/commit/b6c58fc7be71d36e788803e027f8c60f91c744b8).
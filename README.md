# Bugzilla-Extension-MultipleEditNoEmail

This extension adds a checkbox when doing 
[bulk edit to not send an email](https://bugzilla.mozilla.org/show_bug.cgi?id=23924).
The rationale is that on some setups, too many emails is considered spam,
in particular when doing uninteresting changes that are for tracking
purposes only (e.g. keyword tagging, etc).

# Installation

Copy the `z99_MultipleEditNoEmail` directory into the `extensions` directory
of your Bugzilla installation.

# Notes

The directory starts with `z99_` in order to have its `bugmail_recipients`
hook run last.
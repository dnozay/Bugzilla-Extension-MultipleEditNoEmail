# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

package Bugzilla::Extension::MultipleEditNoEmail;

use strict;
use Bugzilla::User;
use base qw(Bugzilla::Extension);
our $VERSION = '1';

sub bugmail_recipients {
    my ($self, $args) = @_;
    my ($recipients, $user_cache) = @$args{qw(recipients users)};

    my $cgi = Bugzilla->cgi;
    if ($cgi->param('no_mass_mail')) {
        # Make sure %user_cache has every user in it so far referenced
        foreach my $user_id (keys %$recipients) {
            $user_cache->{$user_id} ||= new Bugzilla::User($user_id);
        }

        # add global watchers to the cache
        my @watchers = split(/[,\s]+/, Bugzilla->params->{'globalwatchers'});
        foreach (@watchers) {
            my $watcher_id = login_to_id($_);
            next unless $watcher_id;
            my $user = $user_cache->{$watcher_id} ||= new Bugzilla::User($watcher_id);
        }

        # disable email for the users
        foreach my $user_id (keys %$user_cache) {
            $user_cache->{$user_id}->{disable_mail} = 1;
        }
    }
}

__PACKAGE__->NAME;
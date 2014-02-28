# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

package Bugzilla::Extension::MultipleEditNoEmail;

use 5.10.1;
use strict;
use Bugzilla::User;
use base qw(Bugzilla::Extension);
our $VERSION = '1';

=over

=item bugmail_recipients()

The hook that will mark all users in the user cache as having
their bugmail disabled. In effect, that means we should not
email them; and they will still show up in the C<excluding:>
section.

=back

=cut

sub bugmail_recipients {
    my ($self, $args) = @_;
    my ($recipients, $user_cache) = @$args{qw(recipients users)};

    my $cgi = Bugzilla->cgi;
    my $dbh = Bugzilla->dbh;
    if ($cgi->param('no_mass_mail')) {
        # Make sure %user_cache has every user in it so far referenced
        foreach my $user_id (keys %$recipients) {
            $user_cache->{$user_id} ||= new Bugzilla::User($user_id);
        }

        # add user-watching users to the %user_cache
        if (scalar keys %recipients) {
            # find users watching other folks.
            my $involved = join(",", keys %recipients);
            my $userwatchers =
                $dbh->selectall_arrayref("SELECT watcher FROM watch
                                          WHERE watched IN ($involved)");
            # Put them in the cache
            foreach my $watch (@$userwatchers) {
                my $user_id = $watch->[0];
                $user_cache->{$user_id} ||= new Bugzilla::User($user_id);
            }
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
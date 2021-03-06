#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Theme::Stanford;

use strict;
use warnings;

use FB::Theme;
our @ISA = qw(FB::Theme);

##############################################################################
# Usage       : $theme = FB::Theme->new()
# Purpose     : Creates a new Theme object
# Returns     : A FB::Theme object
# Parameters  : Can take no parameters, or some initial values
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub new {
    my ($class, %args) = @_;
    my $self = {
        _template    => "stanford_form.tt",
        _css         => "stanford_form.css",
    };
    bless $self, $class;
    return $self;
}

1;

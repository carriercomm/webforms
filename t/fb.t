#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';
use_ok('FB');

my $fb = FB->new();

my %form_name_tests = (
    "http://www.stanford.edu/test.fb" => 1,
    "http://www.stanford.edu/_.fb" => 1,
    "http://www.stanford.edu/test123.fb" => 1,
    "http://www.stanford.edu/123test.fb" => 1,
    "http://www.stanford.edu/my-test.fb" => 1,
    "http://www.stanford.edu/my_test.fb" => 1,
    "http://www.stanford.edu/my test.fb" => 0,
    "http://www.stanford.edu/~mrmarco/test.fb" => 1,
    "http://www.stanford.edu/~mrmarco/a/test.FB" => 1,
    "http://www.stanford.edu/~mrmarco/a/test.F" => 0,
    "http://www.stanford.edu/~mrmarco/a/.F" => 0,
    "http://www.stanford.edu/~mrmarco/a/" => 0,
    "http://www.stanford.edu/~mrmarco/a" => 0,
    "http://www.stanford.edu/~mrmarco/a/test.fb/a" => 0,
    "http://www.stanford.edu/~mrmarco/a/test.fb/" => 0,
    "http://www.stanford.edu/~mrmarco/a/test.fbt" => 0,
    "http://www.stanford.edu/~mrmarco/a/test.tfb" => 0,
    "http://www.stanford.edu/~mrmarco/a/test..fb" => 0,
    "http://www.stanford.edu/~mrmarco/a/test.fb.fb" => 0,
    "/test.fb" => 0,
    "test.fb" => 0,
    
);

print "Form Name Checks...\n";
foreach (keys %form_name_tests) {
    is( FB::form_name_check($_), 
        $form_name_tests{$_}, 
        "$_ => " . $form_name_tests{$_}
      );
}

my %host_name_tests = (
    "http://www.stanford.edu/test.fb" => 1,
    "http://ww.stanford.edu/test.fb" => 0,
    "http://w.stanford.edu/test.fb" => 0,
    "http://stanford.edu/test.fb" => 0,
    "http://it-services.stanford.edu/test.fb" => 0,
    "http://vanity.stanford.edu/test.fb" => 0,
    "http://www/test.fb" => 0,
    "http://www1.stanford.edu/test.fb" => 0,
    "http://www.new.stanford.edu/test.fb" => 0,
    "http://www.new.stanford.org/test.fb" => 0,
    "http://www.new.stanfrd.edu/test.fb" => 0,
    "http://www.new.stanford.ed/test.fb" => 0,
    "http://www.stanford/test.fb" => 0,
    "http://www.stanford..edu/test.fb" => 0,
);

print "Host Name Checks...\n";
foreach (keys %host_name_tests) {
    is( FB::host_name_check($_),
        $host_name_tests{$_},
        "$_ => " . $host_name_tests{$_}
    );
}

print "URL to File Checks...\n";
my %url_to_file_tests = (
    # HTTP - WWW
    
    "WWW.STANFORD.EDU" => { file => "/afs/.ir/group/homepage/docs" },
    "www.stanford.edu" => { file => "/afs/.ir/group/homepage/docs" },
    "www.stanford.edu/group/foo"
        => { file => "/afs/ir/group/foo/WWW" },
    "www.stanford.edu/dept/foo"
        => { file => "/afs/ir/dept/foo/WWW",  rest => "" },
    "www.stanford.edu/class/foo"
        => { file => "/afs/ir/class/foo/WWW" },
    "www.stanford.edu/people/foo"
        => { file => "/afs/ir/users/f/o/foo/WWW"},
    "www.stanford.edu/~foo"
        => { file => "/afs/ir/users/f/o/foo/WWW"},
    "www.stanford.edu/services/foo"
        => { file => "/afs/.ir/dist/web/services/foo"},
#    "www.stanford.edu/services"
#        => { file => ""},
    
    # HTTP - CGI-BIN

    "WWW.STANFORD.EDU/cgi-bin"
        => { file => "/afs/.ir/group/homepage/cgi-bin" },
    "www.stanford.edu/cgi-bin"
        => { file => "/afs/.ir/group/homepage/cgi-bin" },
    "www.stanford.edu/group/foo/cgi-bin"
        => { file => "/afs/ir/group/foo/cgi-bin" },
    "www.stanford.edu/dept/foo/cgi-bin"
        => { file => "/afs/ir/dept/foo/cgi-bin"},
    "www.stanford.edu/class/foo/cgi-bin"
        => { file => "/afs/ir/class/foo/cgi-bin" },
    "www.stanford.edu/people/foo/cgi-bin"
        => { file => "/afs/ir/users/f/o/foo/cgi-bin"},
    "www.stanford.edu/~foo/cgi-bin"
        => { file => "/afs/ir/users/f/o/foo/cgi-bin"},
    "www.stanford.edu/services/foo/cgi-bin"
        => { file => "/afs/.ir/dist/web/services/foo/cgi-bin"},    

);

foreach (keys %url_to_file_tests) {

    # Test with http:// and no /
    my $url = "http://$_";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'}, "file for $url");
    
    # Test with https:// and no /
    $url = "https://$_";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'}, "file for $url");

    # Test with http:// and /
    $url = "http://$_/";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'}, "file for $url");

    # Test with https:// and /
    $url = "https://$_/";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'}, "file for $url");
    
    # Test with https:// and /bar
    $url = "https://$_/bar";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'} . '/bar', "file for $url");

    # Test with https:// and /bar/baz
    $url = "https://$_/bar/baz";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'} . '/bar/baz', "file for $url");

    # Test with https:// and /bar/baz
    $url = "https://$_/bar/baz/foo.fb";
    my $file = FB::url_to_file($url);
    is($file, $url_to_file_tests{$_}{'file'} . '/bar/baz/foo.fb', "file for $url");
}
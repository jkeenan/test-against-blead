test-against-blead
==================

Investigate ways to test CPAN distributions against Perl 5 blead

This is Alpha-level code.

Enter your preferred configuration variables in config-test-against-blead.sh.

Enter the CPAN module to be tested as the argument for MODULE in
test-against-blead.sh.  Use the '::' spelling, not the '-' spelling.  Example:
MODULE=List::Compare
... not: MODULE=List-Compare.

From the git checkout directory where you customarily test Perl 5 blead, call:

    sh test-against-blead.sh <Module::ToBeTested>

Note that you should use the '::' spelling, not the '-' spelling.  Example:
List::Compare (not List-Compare).

Calling test-against-blead.sh will update blead, configure and build (but
not test) blead, then install it to the directory which you chose in the
configuration file as the argument to $MODULE_TEST_DIR.

The program will then download a fresh copy of 'cpanm' and place it in
$MODULE_TEST_DIR/bin.  That 'cpanm' will download <Module::ToBeTested> from
CPAN, instruct you how to create its Makefile and switch to a subshell
specific to your MODULE.  In that subshell, you run Makefile.PL, 'make' and
'make test' (or their Module-Build equivalents).

If you wish to test an additional CPAN module against the same version of Perl
5 blead, say:

    sh have_blead_run_cpanm_only.sh <Another::Module::ToBeTested>

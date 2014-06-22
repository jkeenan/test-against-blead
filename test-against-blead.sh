# Set up to debug a CPAN module using a development Perl, such as blead.
# Run this shell script while cd'd to the directory containing the Perl source

set -x
# In case you have this set, it shouldn't be for these purposes
PERL5OPT=
# Set to a suitable number for parallelism on your system
TEST_JOBS=8
USER=jkeenan
MODULE_TEST_SUBDIR=testing/blead
# Set to a suitable directory where you want the
# devel perl installed, for the purpose of testing
MODULE_TEST_DIR=/home/$USER/$MODULE_TEST_SUBDIR

# Add whatever other Configure options you need.  To use gdb, I like to have
# -DDEBUGGING=both
# or "-DDEBUGGING=-g" if the problem doesn't happen on a DEBUGGING build.
# -A'optimize=-O0' 
./Configure -des -Dusedevel -Uversiononly -Dprefix=$MODULE_TEST_DIR -Dman1dir=none -Dman3dir=none

make -j${TEST_JOBS} install

# Install a fresh copy of cpanm under module testing directory
wget --no-check-certificate --output-document=$MODULE_TEST_DIR/bin/cpanm --quiet http://bit.ly/cpanm 


# $module is the module being tested.  I like to just add ones to the end, to
# keep a record of what I've worked on.
# Note: Issues with these modules have not necessarily been resolved.
#module=AnyEvent::Fork
#module=Crypt::OpenSSL::X509
#module=Compress::Bzip2
#module=Wx
#module=CDB_File
#module=IP::World
#module=Text::CSV::Hashify
module=List::Compare

# Get it and its dependencies
chmod 0755 $MODULE_TEST_DIR/bin/cpanm
$MODULE_TEST_DIR/bin/cpanm --installdeps $module

set +x

echo "About to cd a work space directory" >&2
echo "From there, run '$MODULE_TEST_DIR/bin/perl Makefile.PL'" >&2
echo "And then, probably 'make test'" >&2

$MODULE_TEST_DIR/bin/cpanm --look $module

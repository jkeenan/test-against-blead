# Set up to debug a CPAN module using a development Perl, such as blead.
# Run this shell script while cd'd to the directory containing the Perl source

source /home/jkeenan/gitwork/test-against-blead/config-test-against-blead.sh

# Use :: notation rather than -.   Example: MODULE=List::Compare
MODULE=$1
test -z $MODULE && \
    echo "MODULE to be tested against Perl 5 blead is undefined" && \
    exit 1;
echo "Testing $MODULE against Perl 5 blead"

set -x

# Add whatever other Configure options you need.  To use gdb, I like to have
# -DDEBUGGING=both
# or "-DDEBUGGING=-g" if the problem doesn't happen on a DEBUGGING build.
# -A'optimize=-O0' 
./Configure -des -Dusedevel -Uversiononly -Dprefix=$MODULE_TEST_DIR -Dman1dir=none -Dman3dir=none

make -j${TEST_JOBS} install

# Install a fresh copy of cpanm under module testing directory
wget --no-check-certificate --output-document=$MODULE_TEST_DIR/bin/cpanm --quiet http://bit.ly/cpanm 


# Get $MODULE  and its dependencies
chmod 0755 $MODULE_TEST_DIR/bin/cpanm
$MODULE_TEST_DIR/bin/cpanm --installdeps $MODULE

set +x

echo "About to cd a work space directory" >&2
echo "From there, run '$MODULE_TEST_DIR/bin/perl Makefile.PL'" >&2
echo "And then, probably 'make test'" >&2

$MODULE_TEST_DIR/bin/cpanm --look $MODULE

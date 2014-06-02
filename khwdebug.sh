# Set up to debug a CPAN module using a development Perl, such as blead.
# Run this shell script while cd'd to the directory containing the Perl source

set -x
PERL5OPT=       # In case you have this set, it shouldn't be for these purposes
test_jobs=8    # Set to a suitable number for parallelism on your system
dir=/home/jkeenan/testing/blead    # Set to a suitable directory where you want the
                            # devel perl installed, for the purpose of testing

# Add whatever other Configure options you need.  To use gdb, I like to have
# -DDEBUGGING=both
# or "-DDEBUGGING=-g" if the problem doesn't happen on a DEBUGGING build.
# -A'optimize=-O0' 
./Configure -des -Dusedevel -Uversiononly -Dprefix=$dir -Dman1dir=none -Dman3dir=none

make -j$test_jobs install

# Get cpanm
wget --no-check-certificate -O- -q http://bit.ly/cpanm |$dir/bin/perl - -v App::cpanminus

# $module is the module being tested.  I like to just add ones to the end, to
# keep a record of what I've worked on.
# Note: Issues with these modules have not necessarily been resolved.
#module=AnyEvent::Fork
#module=Crypt::OpenSSL::X509
#module=Compress::Bzip2
#module=Wx
#module=CDB_File
#module=IP::World

# Get it and its dependencies
$dir/bin/cpanm --installdeps $module

set +x

echo "About to cd a work space directory" >&2
echo "From there, run '$dir/bin/perl Makefile.PL'" >&2
echo "And then, probably 'make test'" >&2

$dir/bin/cpanm --look $module

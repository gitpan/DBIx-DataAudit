# A template for Makefile.PL.
# - Set the $PACKAGE variable to the name of your module.
# - Set $LAST_API_CHANGE to reflect the last version you changed the API
#   of your module.
# - Fill in your dependencies in PREREQ_PM
# Alternatively, you can say the hell with this and use h2xs.

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'DBIx::DataAudit',
    VERSION_FROM    => "lib/DBIx/DataAudit.pm", # finds $VERSION
    EXE_FILES       => ['bin/dbix-dataaudit.pl'],
    PREREQ_PM       => {
                         DBI => 1.38,      # for ->column_info
                         'parent'      => 0.222,
                         'Class::Accessor' => 0,
                         'Text::Table' => 0,
                         'Test::More'  => 0, # for testing, duh
                       },
);


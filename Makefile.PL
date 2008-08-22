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


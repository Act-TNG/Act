package Act::Schema::Result::Schema;
use utf8;
use Act::Schema::Candy;

table "schema";

column "current_version" => {
    data_type          => 'integer',
};

1;

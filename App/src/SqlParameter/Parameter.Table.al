table 50103 "jdi Sql Parameter"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sql Script No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "jdi Sql Script"."No.";
        }
        field(2; Name; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; Value; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PrimaryKey; "Sql Script No.", Name)
        {
            Clustered = true;
        }
    }
}
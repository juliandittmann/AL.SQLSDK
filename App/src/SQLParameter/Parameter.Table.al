table 50103 "jdi SQL Parameter"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "SQL Script No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "jdi SQL Script"."No.";
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
        key(PrimaryKey; "SQL Script No.", Name)
        {
            Clustered = true;
        }
    }
}
table 50200 "jdi SQL Demo sampleview"
{
    Caption = 'sampleview';
    DataClassification = CustomerContent;

    TableType = ExternalSQL;
    ExternalName = 'sampleview';
    ExternalSchema = 'dbo';

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = CustomerContent;
            ExternalName = 'No_';

        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
            ExternalName = 'Name';
        }
        field(3; Address; Text[50])
        {
            DataClassification = CustomerContent;
            ExternalName = 'Address';
        }
    }

    keys
    {
        key(PrimaryKey; "No")
        {
            Clustered = true;
        }
    }
}
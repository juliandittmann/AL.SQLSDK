table 50106 "jdi Sql Script Exec Entry"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }

        field(2; "Sql Connection No."; Code[20])
        {
            Caption = 'Sql Connection No.';
            DataClassification = CustomerContent;
            TableRelation = "jdi Sql Connection";
            NotBlank = true;
            Editable = false;
        }

        field(3; "Sql Script No."; Code[20])
        {
            Caption = 'Sql Script No,';
            DataClassification = CustomerContent;
            TableRelation = "jdi Sql Script"."No.";
            NotBlank = true;
            Editable = false;
        }

        field(4; "Hash Code (SHA256)"; Text[64])
        {
            Caption = 'Script Hash Code';
            DataClassification = SystemMetadata;

        }

        field(5; "File Name"; Text[250])
        {
            Caption = 'File name';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(10; "Last Execution Date"; DateTime)
        {
            Caption = 'Last Execution';
            Editable = false;
        }

        field(11; "Executed by"; Guid)
        {
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }

        field(12; "Last Execution by"; Code[50])
        {
            Caption = 'Last Execution by';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Executed by")));
        }

        field(20; "Executed with Parameter"; Boolean)
        {
            Caption = 'Executed with Parameter';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("jdi Sql Script ExecParam Entry" where("Execution Entry No." = field("Entry No.")));
        }
    }

    keys
    {
        key(PrimaryKey; "Entry No.")
        {
            Clustered = true;
        }
    }
}
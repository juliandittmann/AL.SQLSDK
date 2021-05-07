table 50106 "jdi SQL Script Exec Entry"
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

        field(2; "SQL Connection No."; Code[20])
        {
            Caption = 'SQL Connection No.';
            DataClassification = CustomerContent;
            TableRelation = "jdi SQL Connection";
            NotBlank = true;
            Editable = false;
        }

        field(3; "SQL Script No."; Code[20])
        {
            Caption = 'SQL Script No,';
            DataClassification = CustomerContent;
            TableRelation = "jdi SQL Script"."No.";
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
            CalcFormula = exist("jdi SQL Script ExecParam Entry" where("Execution Entry No." = field("Entry No.")));
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
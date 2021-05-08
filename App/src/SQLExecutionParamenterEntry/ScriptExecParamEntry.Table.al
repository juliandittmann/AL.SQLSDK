table 50107 "jdi SQL Script ExecParam Entry"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Execution Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(2; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(3; "Parameter Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(4; Value; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PrimaryKey; "Execution Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetNextEntryNo() NextEntryNo: Integer
    var
        SQLScriptExecParameterEntry: Record "jdi SQL Script ExecParam Entry";
    begin
        TestField("Execution Entry No.");
        SQLScriptExecParameterEntry.SetRange("Execution Entry No.", Rec."Execution Entry No.");
        if SQLScriptExecParameterEntry.FindLast() then
            NextEntryNo := SQLScriptExecParameterEntry."Entry No." + 1
        else
            NextEntryNo := 1;
    end;
}
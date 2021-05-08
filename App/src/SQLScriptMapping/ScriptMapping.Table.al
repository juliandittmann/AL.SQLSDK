table 50104 "jdi SQL Script Mapping"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "SQL Connection No."; Code[20])
        {
            TableRelation = "jdi SQL Connection";
        }

        field(2; "SQL Script No."; Code[20])
        {
            TableRelation = "jdi SQL Script";
        }

        field(3; Description; Text[250])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("jdi SQL Script".Description where("No." = field("SQL Script No.")));
        }

        field(10; "Last Execution Date"; DateTime)
        {
            Caption = 'Last Execution';
            Editable = false;
        }

        field(11; "Executed by"; Guid)
        {
            DataClassification = EndUserIdentifiableInformation;
        }

        field(12; "Last Execution by"; Code[50])
        {
            Caption = 'Last Execution by';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Executed by")));
        }

        field(13; "Last Change"; DateTime)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("jdi SQL Script"."Last Change Date" where("No." = field("SQL Script No.")));
        }
    }

    keys
    {
        key(PirmaryKey; "SQL Connection No.", "SQL Script No.")
        {
            Clustered = true;
        }
    }

    procedure Execute()
    var
        SQLScript: Record "jdi SQL Script";
        SQLParameter: Dictionary of [Text, Text];
        SQLScriptText: Text;
        ScalarResponse: Variant;
    begin
        if SQLScript.Get(Rec."SQL Script No.") then
            if SQLScript.GetScript(SQLScriptText) then begin

                SQLParameter := SQLScript.GetSQLParameter();
                case SQLScript."Script Type" of
                    SQLScript."Script Type"::"Non Query":
                        GetSQLConnection().ExecuteNonQuery(SQLScriptText, SQLParameter);
                    SQLScript."Script Type"::Scalar:
                        begin
                            GetSQLConnection().ExecuteScalar(SQLScriptText, SQLParameter, ScalarResponse);
                            Message(Format(ScalarResponse)); //TODO: Evtl. nicht via Message ausgeben
                        end;
                end;

                Rec.Validate("Last Execution Date", CurrentDateTime());
                Rec."Executed by" := UserSecurityId();
                Rec.Modify(false);

                OnAfterSQLScriptExecution(Rec, SQLScript, SQLParameter)
            end;
    end;

    procedure GetSQLConnection() SQLConnection: Record "jdi SQL Connection";
    begin
        if SQLConnection.Get(Rec."SQL Connection No.") then
            exit(SQLConnection);
    end;


    [IntegrationEvent(true, false)]
    local procedure OnAfterSQLScriptExecution(var SQLScriptMapping: Record "jdi SQL Script Mapping"; var SQLScript: Record "jdi SQL Script"; SQLParameter: Dictionary of [Text, Text])
    begin
    end;
}
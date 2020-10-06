table 50104 "jdi Sql Script Mapping"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sql Connection No."; Code[20])
        {
            TableRelation = "jdi Sql Connection";
        }

        field(2; "Sql Script No."; Code[20])
        {
            TableRelation = "jdi Sql Script";
        }

        field(3; Description; Text[250])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("jdi Sql Script".Description where("No." = field("Sql Script No.")));
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
            CalcFormula = lookup("jdi Sql Script"."Last Change Date" where("No." = field("Sql Script No.")));
        }
    }

    keys
    {
        key(PirmaryKey; "Sql Connection No.", "Sql Script No.")
        {
            Clustered = true;
        }
    }


    procedure Execute()
    var
        SqlConnection: Record "jdi Sql Connection";
        SqlScript: Record "jdi Sql Script";
        SqlParamenter: Record "jdi Sql Parameter";
        SqlScriptText: Text;
        ScalarResponse: Variant;
    begin
        if SqlScript.Get("Sql Script No.") then
            if SqlScript.GetScript(SqlScriptText) then begin
                SqlConnection.Get("Sql Connection No.");
                SqlScript.SqlParamenterExist(SqlParamenter);

                case SqlScript."Script Type" of
                    SqlScript."Script Type"::"Non Query":
                        SqlConnection.ExecuteNonQuery(SqlScriptText, SqlParamenter);
                    SqlScript."Script Type"::Scalar:
                        begin
                            SqlConnection.ExecuteScalar(SqlScriptText, SqlParamenter, ScalarResponse);
                            Message(Format(ScalarResponse)); //TODO: Evtl. nicht via Message ausgeben
                        end;
                end;

                Validate("Last Execution Date", CurrentDateTime());
                "Executed by" := UserSecurityId();
                Modify(false);

                OnAfterSqlScriptExecution(Rec, SqlScript, SqlParamenter)
            end;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSqlScriptExecution(var SqlScriptMapping: Record "jdi Sql Script Mapping"; var SqlScript: Record "jdi Sql Script"; var SqlParamenter: Record "jdi Sql Parameter")
    begin
    end;
}
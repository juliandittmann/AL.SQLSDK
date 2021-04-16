codeunit 50104 "jdi Sql Script Exec Mgt"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Table, Database::"jdi Sql Script Mapping", 'OnAfterSqlScriptExecution', '', false, false)]
    local procedure LogScriptExecution(SqlScriptMapping: Record "jdi Sql Script Mapping"; SqlScript: Record "jdi Sql Script"; var SqlParameter: Record "jdi Sql Parameter")
    var
        EntryNo: Integer;
    begin
        EntryNo := CreateSqlScriptExecutionEntry(SqlScriptMapping, SqlScript);
        CreateSqlScriptExecutionParameters(EntryNo, SqlParameter);
    end;

    local procedure CreateSqlScriptExecutionEntry(SqlScriptMapping: Record "jdi Sql Script Mapping"; SqlScript: Record "jdi Sql Script"): Integer
    var
        SqlScriptExecutionEntry: Record "jdi Sql Script Exec Entry";
    begin
        SqlScriptExecutionEntry.Init();
        SqlScriptExecutionEntry."Sql Connection No." := SqlScriptMapping."Sql Connection No.";
        SqlScriptExecutionEntry."Sql Script No." := SqlScriptMapping."Sql Script No.";
        SqlScriptExecutionEntry."Last Execution Date" := SqlScriptMapping."Last Execution Date";
        SqlScriptExecutionEntry."Executed by" := SqlScriptMapping."Executed by";
        SqlScriptExecutionEntry."Hash Code (SHA256)" := SqlScript."Hash Code (SHA256)";
        SqlScriptExecutionEntry."File Name" := SqlScript."File Name";
        SqlScriptExecutionEntry.Insert(true);

        exit(SqlScriptExecutionEntry."Entry No.");
    end;

    local procedure CreateSqlScriptExecutionParameters(pEntryNo: Integer; var SqlScriptParameter: Record "jdi Sql Parameter")
    var
        SqlScriptExecParameterEntry: Record "jdi Sql Script ExecParam Entry";
    begin
        if SqlScriptParameter.FindSet() then
            repeat
                SqlScriptExecParameterEntry.Init();
                SqlScriptExecParameterEntry."Execution Entry No." := pEntryNo;
                SqlScriptExecParameterEntry."Entry No." := SqlScriptExecParameterEntry.GetNextEntryNo();
                SqlScriptExecParameterEntry."Parameter Name" := SqlScriptParameter.Name;
                SqlScriptExecParameterEntry.Value := SqlScriptParameter.Value;
                SqlScriptExecParameterEntry.Insert(true);
            until SqlScriptParameter.Next() = 0;
    end;

    procedure ShowParameterList(SqlScriptExecutionEntry: Record "jdi Sql Script Exec Entry")
    var
        SqlScriptExecParamEntry: Record "jdi Sql Script ExecParam Entry";
        ParamList: Page "jdi Sql Script ExecP EntryList";
    begin
        SqlScriptExecParamEntry.SetRange("Execution Entry No.", SqlScriptExecutionEntry."Entry No.");
        ParamList.SetTableView(SqlScriptExecParamEntry);
        ParamList.RunModal();
    end;

    procedure ShowScriptCode(SqlScriptExecutionEntry: Record "jdi Sql Script Exec Entry")
    var
        SqlScript: Record "jdi Sql Script";
        SqlScriptArchive: Record "jdi Sql Script Archive";
    begin
        SqlScript.SetRange("No.", SqlScriptExecutionEntry."Sql Script No.");
        SqlScript.SetRange("Hash Code (SHA256)", SqlScriptExecutionEntry."Hash Code (SHA256)");
        if SqlScript.FindSet() then begin
            SqlScript.ViewScript();
            exit;
        end;

        SqlScriptArchive.SetRange("Sql Script No.", SqlScriptExecutionEntry."Sql Script No.");
        SqlScriptArchive.SetRange("Hash Code (SHA256)", SqlScriptExecutionEntry."Hash Code (SHA256)");
        if SqlScriptArchive.FindSet() then begin
            SqlScriptArchive.ViewScript();
            exit;
        end;
    end;
}
codeunit 50104 "jdi SQL Script Exec Mgt"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Table, Database::"jdi SQL Script Mapping", 'OnAfterSQLScriptExecution', '', false, false)]
    local procedure LogScriptExecution(SQLScriptMapping: Record "jdi SQL Script Mapping"; SQLScript: Record "jdi SQL Script"; var SQLParameter: Record "jdi SQL Parameter")
    var
        EntryNo: Integer;
    begin
        EntryNo := CreateSQLScriptExecutionEntry(SQLScriptMapping, SQLScript);
        CreateSQLScriptExecutionParameters(EntryNo, SQLParameter);
    end;

    local procedure CreateSQLScriptExecutionEntry(SQLScriptMapping: Record "jdi SQL Script Mapping"; SQLScript: Record "jdi SQL Script"): Integer
    var
        SQLScriptExecutionEntry: Record "jdi SQL Script Exec Entry";
    begin
        SQLScriptExecutionEntry.Init();
        SQLScriptExecutionEntry."SQL Connection No." := SQLScriptMapping."SQL Connection No.";
        SQLScriptExecutionEntry."SQL Script No." := SQLScriptMapping."SQL Script No.";
        SQLScriptExecutionEntry."Last Execution Date" := SQLScriptMapping."Last Execution Date";
        SQLScriptExecutionEntry."Executed by" := SQLScriptMapping."Executed by";
        SQLScriptExecutionEntry."Hash Code (SHA256)" := SQLScript."Hash Code (SHA256)";
        SQLScriptExecutionEntry."File Name" := SQLScript."File Name";
        SQLScriptExecutionEntry.Insert(true);

        exit(SQLScriptExecutionEntry."Entry No.");
    end;

    local procedure CreateSQLScriptExecutionParameters(pEntryNo: Integer; var SQLScriptParameter: Record "jdi SQL Parameter")
    var
        SQLScriptExecParameterEntry: Record "jdi SQL Script ExecParam Entry";
    begin
        if SQLScriptParameter.FindSet() then
            repeat
                SQLScriptExecParameterEntry.Init();
                SQLScriptExecParameterEntry."Execution Entry No." := pEntryNo;
                SQLScriptExecParameterEntry."Entry No." := SQLScriptExecParameterEntry.GetNextEntryNo();
                SQLScriptExecParameterEntry."Parameter Name" := SQLScriptParameter.Name;
                SQLScriptExecParameterEntry.Value := SQLScriptParameter.Value;
                SQLScriptExecParameterEntry.Insert(true);
            until SQLScriptParameter.Next() = 0;
    end;

    procedure ShowParameterList(SQLScriptExecutionEntry: Record "jdi SQL Script Exec Entry")
    var
        SQLScriptExecParamEntry: Record "jdi SQL Script ExecParam Entry";
        ParamList: Page "jdi SQL Script ExecP EntryList";
    begin
        SQLScriptExecParamEntry.SetRange("Execution Entry No.", SQLScriptExecutionEntry."Entry No.");
        ParamList.SetTableView(SQLScriptExecParamEntry);
        ParamList.RunModal();
    end;

    procedure ShowScriptCode(SQLScriptExecutionEntry: Record "jdi SQL Script Exec Entry")
    var
        SQLScript: Record "jdi SQL Script";
        SQLScriptArchive: Record "jdi SQL Script Archive";
    begin
        SQLScript.SetRange("No.", SQLScriptExecutionEntry."SQL Script No.");
        SQLScript.SetRange("Hash Code (SHA256)", SQLScriptExecutionEntry."Hash Code (SHA256)");
        if SQLScript.FindSet() then begin
            SQLScript.ViewScript();
            exit;
        end;

        SQLScriptArchive.SetRange("SQL Script No.", SQLScriptExecutionEntry."SQL Script No.");
        SQLScriptArchive.SetRange("Hash Code (SHA256)", SQLScriptExecutionEntry."Hash Code (SHA256)");
        if SQLScriptArchive.FindSet() then begin
            SQLScriptArchive.ViewScript();
            exit;
        end;
    end;
}
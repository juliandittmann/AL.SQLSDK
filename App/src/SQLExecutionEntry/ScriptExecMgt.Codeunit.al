codeunit 50104 "jdi SQL Script Exec Mgt"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Table, Database::"jdi SQL Script Mapping", 'OnAfterSQLScriptExecution', '', false, false)]
    local procedure LogScriptExecution(SQLScriptMapping: Record "jdi SQL Script Mapping"; SQLScript: Record "jdi SQL Script"; SQLParameter: Dictionary of [Text, Text])
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

    local procedure CreateSQLScriptExecutionParameters(pEntryNo: Integer; SQLParameter: Dictionary of [Text, Text])
    var
        SQLScriptExecParameterEntry: Record "jdi SQL Script ExecParam Entry";
        ParamKeys: List of [Text];
        ParamKey: Text;
    begin
        ParamKeys := SQLParameter.Keys;
        foreach ParamKey in ParamKeys do begin
            SQLScriptExecParameterEntry.Init();
            SQLScriptExecParameterEntry."Execution Entry No." := pEntryNo;
            SQLScriptExecParameterEntry."Entry No." := SQLScriptExecParameterEntry.GetNextEntryNo();
            SQLScriptExecParameterEntry."Parameter Name" := CopyStr(ParamKey, 1, 250);
            SQLScriptExecParameterEntry.Value := CopyStr(SQLParameter.Get(ParamKey), 1, 250);
            SQLScriptExecParameterEntry.Insert(true);
        end;
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
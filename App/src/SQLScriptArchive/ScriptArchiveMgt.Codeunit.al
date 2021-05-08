codeunit 50105 "jdi SQL Script Archive Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"jdi SQL Script", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySQLScriptArchiveSQLScript(var Rec: Record "jdi SQL Script"; var xRec: Record "jdi SQL Script"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if not FindHash(Rec) then
            CreateSQLScriptArchive(Rec);
    end;

    local procedure FindHash(var SQLScript: Record "jdi SQL Script"): Boolean
    var
        SQLScriptArchive: Record "jdi SQL Script Archive";
    begin
        SQLScriptArchive.SetRange("SQL Script No.", SQLScript."No.");
        SQLScriptArchive.SetRange("Hash Code (SHA256)", SQLScript."Hash Code (SHA256)");
        exit(not SQLScriptArchive.IsEmpty());
    end;

    local procedure CreateSQLScriptArchive(var SQLScript: Record "jdi SQL Script")
    var
        SQLScriptArchive: Record "jdi SQL Script Archive";

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        if not SQLScript.File.HasValue() then
            exit;

        SQLScriptArchive.Init();
        SQLScriptArchive."SQL Script No." := SQLScript."No.";
        SQLScriptArchive."Entry No." := SQLScriptArchive.GetNextEntryNo();
        SQLScriptArchive.Description := SQLScript.Description;

        SQLScriptArchive."File Extension" := SQLScript."File Extension";
        SQLScriptArchive."File Name" := SQLScript."File Name";
        SQLScriptArchive."File Type" := SQLScript."File Type";
        SQLScriptArchive."Hash Code (SHA256)" := SQLScript."Hash Code (SHA256)";
        SQLScriptArchive."Changed by" := SQLScript."Changed by";
        SQLScriptArchive."Last Change Date" := SQLScript."Last Change Date";

        //Transfer File
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        SQLScript.File.ExportStream(OutStr);
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        SQLScriptArchive.File.ImportStream(InStr, '', '');

        SQLScriptArchive.Insert();
    end;
}
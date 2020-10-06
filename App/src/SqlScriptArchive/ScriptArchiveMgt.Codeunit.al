codeunit 50105 "jdi Sql Script Archive Mgt"
{
    [EventSubscriber(ObjectType::Table, Database::"jdi Sql Script", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySqlScriptArchiveSqlScript(var Rec: Record "jdi Sql Script"; var xRec: Record "jdi Sql Script"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if not FindHash(Rec) then
            CreateSqlScriptArchive(Rec);
    end;

    local procedure FindHash(var SqlScript: Record "jdi Sql Script"): Boolean
    var
        SqlScriptArchive: Record "jdi Sql Script Archive";
    begin
        SqlScriptArchive.SetRange("Sql Script No.", SqlScript."No.");
        SqlScriptArchive.SetRange("Hash Code (SHA256)", SqlScript."Hash Code (SHA256)");
        exit(not SqlScriptArchive.IsEmpty());
    end;

    local procedure CreateSqlScriptArchive(var SqlScript: Record "jdi Sql Script")
    var
        SqlScriptArchive: Record "jdi Sql Script Archive";

        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        if not SqlScript.File.HasValue() then
            exit;

        SqlScriptArchive.Init();
        SqlScriptArchive."Sql Script No." := SqlScript."No.";
        SqlScriptArchive."Entry No." := SqlScriptArchive.GetNextEntryNo();
        SqlScriptArchive.Description := SqlScript.Description;

        SqlScriptArchive."File Extension" := SqlScript."File Extension";
        SqlScriptArchive."File Name" := SqlScript."File Name";
        SqlScriptArchive."File Type" := SqlScript."File Type";
        SqlScriptArchive."Hash Code (SHA256)" := SqlScript."Hash Code (SHA256)";
        SqlScriptArchive."Changed by" := SqlScript."Changed by";
        SqlScriptArchive."Last Change Date" := SqlScript."Last Change Date";

        //Transfer File
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        SqlScript.File.ExportStream(OutStr);
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        SqlScriptArchive.File.ImportStream(InStr, '', '');

        SqlScriptArchive.Insert();
    end;
}
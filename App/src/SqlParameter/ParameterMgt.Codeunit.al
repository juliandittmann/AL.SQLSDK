codeunit 50103 "jdi Sql Parameter Mgt"
{

    procedure CreateSqlParamenter(SQLScript: Record "jdi Sql Script")
    var
        ParamenterList: List of [Text];
        Parameter: Text;
    begin
        ParamenterList := FindSqlParamenter(SQLScript);
        foreach Parameter in ParamenterList do
            InsertSqlParamenter(SQLScript, Parameter);
    end;

    local procedure FindSqlParamenter(SQLScript: Record "jdi Sql Script") ParameterList: List of [Text];
    var
        Matches: Record Matches;
        Regex: Codeunit Regex;
        ScriptText: Text;
        SqlParemeterRegExLbl: Label '\@([^=<>\s\''''|,|;]+)', Locked = true;
    begin
        if SQLScript.GetScript(ScriptText) then begin
            Regex.Match(ScriptText, SqlParemeterRegExLbl, Matches);
            if Matches.FindSet() then
                repeat
                    ParameterList.Add(Matches.ReadValue().Remove(0, 1))
                until Matches.Next() = 0;
        end;
    end;

    local procedure InsertSqlParamenter(SQLScript: Record "jdi Sql Script"; ParamenterName: Text)
    var
        SqlParamenter: Record "jdi Sql Parameter";
    begin
        SqlParamenter.Init();
        SqlParamenter."Sql Script No." := SQLScript."No.";
        SqlParamenter.Name := CopyStr(ParamenterName, 1, 250);
        if not SqlParamenter.Insert(true) then
            SqlParamenter.Modify(true);
    end;
}

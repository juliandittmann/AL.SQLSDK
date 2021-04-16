codeunit 50103 "jdi Sql Parameter Mgt"
{
    Access = Internal;
    procedure CreateSqlParameter(SQLScript: Record "jdi Sql Script")
    var
        ParameterList: List of [Text];
        Parameter: Text;
    begin
        ParameterList := FindSqlParameter(SQLScript);
        foreach Parameter in ParameterList do
            InsertSqlParameter(SQLScript, Parameter);
    end;

    local procedure FindSqlParameter(SQLScript: Record "jdi Sql Script") ParameterList: List of [Text];
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
                    ParameterList.Add(Matches.ReadValue().Remove(1, 1));
                until Matches.Next() = 0;
        end;
    end;

    local procedure InsertSqlParameter(SQLScript: Record "jdi Sql Script"; ParameterName: Text)
    var
        SqlParameter: Record "jdi Sql Parameter";
    begin
        SqlParameter.Init();
        SqlParameter."Sql Script No." := SQLScript."No.";
        SqlParameter.Name := CopyStr(ParameterName, 1, 250);
        if not SqlParameter.Insert(true) then
            SqlParameter.Modify(true);
    end;
}

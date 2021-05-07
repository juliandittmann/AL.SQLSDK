codeunit 50103 "jdi SQL Parameter Mgt"
{
    Access = Internal;
    procedure CreateSQLParameter(SQLScript: Record "jdi SQL Script")
    var
        ParameterList: List of [Text];
        Parameter: Text;
    begin
        ParameterList := FindSQLParameter(SQLScript);
        foreach Parameter in ParameterList do
            InsertSQLParameter(SQLScript, Parameter);
    end;

    local procedure FindSQLParameter(SQLScript: Record "jdi SQL Script") ParameterList: List of [Text];
    var
        Matches: Record Matches;
        Regex: Codeunit Regex;
        ScriptText: Text;
        SQLParemeterRegExLbl: Label '\@([^=<>\s\''''|,|;]+)', Locked = true;
    begin
        if SQLScript.GetScript(ScriptText) then begin
            Regex.Match(ScriptText, SQLParemeterRegExLbl, Matches);
            if Matches.FindSet() then
                repeat
                    ParameterList.Add(Matches.ReadValue().Remove(1, 1));
                until Matches.Next() = 0;
        end;
    end;

    local procedure InsertSQLParameter(SQLScript: Record "jdi SQL Script"; ParameterName: Text)
    var
        SQLParameter: Record "jdi SQL Parameter";
    begin
        SQLParameter.Init();
        SQLParameter."SQL Script No." := SQLScript."No.";
        SQLParameter.Name := CopyStr(ParameterName, 1, 250);
        if not SQLParameter.Insert(true) then
            SQLParameter.Modify(true);
    end;
}

codeunit 50103 "jdi Sql Paramenter Mgt"
{

    procedure CreateSqlParamenter(Script: Record "jdi Sql Script")
    var
        ParamenterList: List of [Text];
        Parameter: Text;
    begin
        FindSqlParamenter(Script, ParamenterList);

        foreach Parameter in ParamenterList do
            CreateSqlParamenter(Script, Parameter);
    end;

    local procedure FindSqlParamenter(Script: Record "jdi Sql Script"; var ParameterList: List of [Text])
    var
        Regex: DotNet Regex;
        MatchCollection: DotNet MatchCollection;
        Match: DotNet Match;
        ScriptText: Text;
        SqlParemeterRegExLbl: Label '\@([^=<>\s\''''|,|;]+)', Locked = true;
    begin
        if Script.GetScript(ScriptText) then begin
            Regex := Regex.Regex(SqlParemeterRegExLbl);
            MatchCollection := Regex.Matches(ScriptText);

            foreach Match in MatchCollection do
                ParameterList.Add(Match.Value.Remove(0, 1)); //Removes @ Character
        end;
    end;

    local procedure CreateSqlParamenter(Script: Record "jdi Sql Script"; ParamenterName: Text) //TODO: missleading function name
    var
        SqlParamenter: Record "jdi Sql Parameter";
    begin
        SqlParamenter.Init();
        SqlParamenter."Sql Script No." := Script."No.";
        SqlParamenter.Name := CopyStr(ParamenterName, 1, 250);
        if not SqlParamenter.Insert(true) then
            SqlParamenter.Modify(true);
    end;
}

codeunit 50102 "jdi Sql Management"
{
    TableNo = "jdi Sql Connection";

    var
        GlobalSqlConnection: Record "jdi Sql Connection";
        TempGlobalSqlParamenter: Record "jdi Sql Parameter" temporary;

    trigger OnRun()
    begin
        GlobalSqlConnection := Rec;
    end;


    procedure SetSqlConnection(pSqlConnection: Record "jdi Sql Connection")
    begin
        GlobalSqlConnection := pSqlConnection;
    end;

    procedure SetSqlParameter(var pSqlParameter: Record "jdi Sql Parameter" temporary)
    begin
        TempGlobalSqlParamenter := pSqlParameter;
    end;

    [TryFunction]
    procedure TestConnection()
    begin
        TestConnection(GlobalSqlConnection);
    end;

    [TryFunction]
    procedure TestConnection(pSqlConnection: Record "jdi Sql Connection")
    var
        SqlConnection: DotNet SqlConnection;
    begin
        SqlConnection := SqlConnection.SqlConnection(pSqlConnection.GetConnectionString());

        SqlConnection.Open();
        SqlConnection.Close();

        Clear(SqlConnection);
    end;



    // Non Query

    [TryFunction]
    procedure TryExecuteNonQuery(SqlStatement: Text)
    begin
        ExecuteNonQuery(GlobalSqlConnection, SqlStatement);
    end;


    [TryFunction]
    procedure TryExecuteNonQuery(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text)
    begin
        ExecuteNonQuery(pSqlConnection, SqlStatement);
    end;

    procedure ExecuteNonQuery(SqlStatement: Text)
    begin
        ExecuteNonQuery(GlobalSqlConnection, SqlStatement);
    end;

    procedure ExecuteNonQuery(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
    begin
        ExecuteNonQuery(pSqlConnection, SqlStatement, TempSqlParamenter);
    end;

    procedure ExecuteNonQuery(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary)
    var
        SqlConnection: DotNet SqlConnection;
        SqlCommand: DotNet SqlCommand;
    begin
        SqlConnection := SqlConnection.SqlConnection(pSqlConnection.GetConnectionString());

        SqlCommand := SqlCommand.SqlCommand(SqlStatement, SqlConnection);
        AddParamenter(SqlParamenter, SqlCommand);

        SqlConnection.Open();
        SqlCommand.ExecuteNonQuery();
        SqlConnection.Close();

        Clear(SqlCommand);
        Clear(SqlConnection);
    end;

    //  Scalar


    //Text - With GlobalSQLConnection
    procedure ExecuteScalar(SqlStatement: Text; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;

    //Decimal - With GlobalSQLConnection
    procedure ExecuteScalar(SqlStatement: Text; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - With GlobalSQLConnection
    procedure ExecuteScalar(SqlStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseVariant);
    end;




    //Try - Text - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseText: Text)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseText);
    end;

    //Try - Decimal - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseDecimal);
    end;

    //Try - Variant - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, ResponseVariant);
    end;















    //Text - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, SqlParameter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;

    //Decimal - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, SqlParameter, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, SqlParameter, ResponseVariant);
    end;



    //Try - Text - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(SqlStatement, SqlParameter, ResponseText);
    end;

    //Try - Decimal - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SqlStatement, SqlParameter, ResponseDecimal);
    end;

    //Try - Variant - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParameter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSqlConnection, SqlStatement, SqlParameter, ResponseVariant);
    end;








    //Text - SQLConnection
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseText: Text)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;



    //Decimal - SQLConnection
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseDecimal: Decimal)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseVariant);
        if ResponseVariant.IsDecimal then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;


    //Variant - SQLConnection
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseVariant: Variant)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseVariant);
    end;





    //Try - Text - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseText: Text)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseText);
    end;

    //Try - Decimal - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseDecimal: Decimal)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseDecimal);
    end;

    //Try - Variant - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var ResponseVariant: Variant)
    var
        TempSqlParamenter: Record "jdi Sql Parameter" temporary;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, TempSqlParamenter, ResponseVariant);
    end;










    //Text - SQLConnection - SQLParamenter
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, SqlParamenter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            Evaluate(ResponseText, ResponseVariant);
    end;


    //Decimal - SQLConnection - SQLParamenter
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, SqlParamenter, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - SQLConnection - SQLParamenter
    procedure ExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    var
        SqlConnection: DotNet SqlConnection;
        SqlCommand: DotNet SqlCommand;
    begin
        SqlConnection := SqlConnection.SqlConnection(pSqlConnection.GetConnectionString());

        SqlCommand := SqlCommand.SqlCommand(SqlStatement, SqlConnection);
        AddParamenter(SqlParamenter, SqlCommand);

        SqlConnection.Open();
        ResponseVariant := SqlCommand.ExecuteScalar();
        SqlConnection.Close();

        Clear(SqlCommand);
        Clear(SqlConnection);
    end;

    //Try - Text - SQLConnection - SQLParamenter
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, SqlParamenter, ResponseText);
    end;

    //Try - Decimal - SQLConnection - SQLParamenter
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, SqlParamenter, ResponseDecimal);
    end;

    //Try - Variant - SQLConnection - SQLParamenter
    [TryFunction]
    procedure TryExecuteScalar(pSqlConnection: Record "jdi Sql Connection"; SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(pSqlConnection, SqlStatement, SqlParamenter, ResponseVariant);
    end;






    local procedure AddParamenter(var SqlParamenter: Record "jdi Sql Parameter" temporary; var SqlCommand: DotNet SqlCommand)
    begin
        if SqlParamenter.FindSet() then
            repeat
                SqlCommand.Parameters.AddWithValue(SqlParamenter.Name, SqlParamenter.Value);
            until SqlParamenter.Next() = 0;
    end;
}
codeunit 50102 "jdi SQL Management"
{
    TableNo = "jdi SQL Connection";

    var
        GlobalSQLConnection: Record "jdi SQL Connection";
        TempGlobalSQLParameter: Record "jdi SQL Parameter" temporary;

    trigger OnRun()
    begin
        GlobalSQLConnection := Rec;
    end;


    procedure SetSQLConnection(pSQLConnection: Record "jdi SQL Connection")
    begin
        GlobalSQLConnection := pSQLConnection;
    end;

    procedure SetSQLParameter(var pSQLParameter: Record "jdi SQL Parameter" temporary)
    begin
        TempGlobalSQLParameter := pSQLParameter;
    end;

    [TryFunction]
    procedure TestConnection()
    begin
        TestConnection(GlobalSQLConnection);
    end;

    [TryFunction]
    procedure TestConnection(pSQLConnection: Record "jdi SQL Connection")
    var
        SQLConnection: DotNet SQLConnection;
    begin
        SQLConnection := SQLConnection.SQLConnection(pSQLConnection.GetConnectionString());

        SQLConnection.Open();
        SQLConnection.Close();

        Clear(SQLConnection);
    end;



    // Non Query

    [TryFunction]
    procedure TryExecuteNonQuery(SQLStatement: Text)
    begin
        ExecuteNonQuery(GlobalSQLConnection, SQLStatement);
    end;


    [TryFunction]
    procedure TryExecuteNonQuery(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text)
    begin
        ExecuteNonQuery(pSQLConnection, SQLStatement);
    end;

    procedure ExecuteNonQuery(SQLStatement: Text)
    begin
        ExecuteNonQuery(GlobalSQLConnection, SQLStatement);
    end;

    procedure ExecuteNonQuery(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
    begin
        ExecuteNonQuery(pSQLConnection, SQLStatement, TempSQLParameter);
    end;

    procedure ExecuteNonQuery(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary)
    var
        SQLConnection: DotNet SQLConnection;
        SQLCommand: DotNet SQLCommand;
    begin
        SQLConnection := SQLConnection.SQLConnection(pSQLConnection.GetConnectionString());

        SQLConnection.Open();

        SQLCommand := SQLCommand.SQLCommand();
        SQLCommand.CommandText := SQLStatement;
        SQLCommand.Connection := SQLConnection;
        SQLCommand.CommandType := SQLCommand.CommandType.Text;
        SQLCommand.CommandTimeout := 0;

        AddParameter(SQLParameter, SQLCommand);

        SQLCommand.ExecuteNonQuery();
        SQLConnection.Close();

        Clear(SQLCommand);
        Clear(SQLConnection);
    end;




    //  Scalar


    //Text - With GlobalSQLConnection
    procedure ExecuteScalar(SQLStatement: Text; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;

    //Decimal - With GlobalSQLConnection
    procedure ExecuteScalar(SQLStatement: Text; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - With GlobalSQLConnection
    procedure ExecuteScalar(SQLStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseVariant);
    end;




    //Try - Text - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseText: Text)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseText);
    end;

    //Try - Decimal - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseDecimal);
    end;

    //Try - Variant - With GlobalSQLConnection
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, ResponseVariant);
    end;















    //Text - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;

    //Decimal - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - With GlobalSQLConnection + Parameter
    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
    end;



    //Try - Text - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(SQLStatement, SQLParameter, ResponseText);
    end;

    //Try - Decimal - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SQLStatement, SQLParameter, ResponseDecimal);
    end;

    //Try - Variant - With GlobalSQLConnection + Parameter
    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(GlobalSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
    end;








    //Text - SQLConnection
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseText: Text)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            ResponseText := Format(ResponseVariant);
    end;



    //Decimal - SQLConnection
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseDecimal: Decimal)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseVariant);
        if ResponseVariant.IsDecimal then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;


    //Variant - SQLConnection
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseVariant: Variant)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseVariant);
    end;





    //Try - Text - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseText: Text)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseText);
    end;

    //Try - Decimal - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseDecimal: Decimal)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseDecimal);
    end;

    //Try - Variant - SQLConnection
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var ResponseVariant: Variant)
    var
        TempSQLParameter: Record "jdi SQL Parameter" temporary;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, TempSQLParameter, ResponseVariant);
    end;










    //Text - SQLConnection - SQLParameter
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
        if ResponseVariant.IsText() then
            ResponseText := ResponseVariant
        else
            Evaluate(ResponseText, ResponseVariant);
    end;


    //Decimal - SQLConnection - SQLParameter
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    var
        ResponseVariant: Variant;
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
        if ResponseVariant.IsDecimal() then
            ResponseDecimal := ResponseVariant
        else
            Evaluate(ResponseDecimal, ResponseVariant);
    end;

    //Variant - SQLConnection - SQLParameter
    procedure ExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    var
        SQLConnection: DotNet SQLConnection;
        SQLCommand: DotNet SQLCommand;
    begin
        SQLConnection := SQLConnection.SQLConnection(pSQLConnection.GetConnectionString());

        SQLConnection.Open();

        SQLCommand := SQLCommand.SQLCommand();
        SQLCommand.CommandText := SQLStatement;
        SQLCommand.Connection := SQLConnection;
        SQLCommand.CommandType := SQLCommand.CommandType.Text;
        SQLCommand.CommandTimeout := 0;

        AddParameter(SQLParameter, SQLCommand);

        ResponseVariant := SQLCommand.ExecuteScalar();
        SQLConnection.Close();

        Clear(SQLCommand);
        Clear(SQLConnection);
    end;



    //Try - Text - SQLConnection - SQLParameter
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, SQLParameter, ResponseText);
    end;

    //Try - Decimal - SQLConnection - SQLParameter
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, SQLParameter, ResponseDecimal);
    end;

    //Try - Variant - SQLConnection - SQLParameter
    [TryFunction]
    procedure TryExecuteScalar(pSQLConnection: Record "jdi SQL Connection"; SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(pSQLConnection, SQLStatement, SQLParameter, ResponseVariant);
    end;






    local procedure AddParameter(var SQLParameter: Record "jdi SQL Parameter" temporary; var SQLCommand: DotNet SQLCommand)
    begin
        if SQLParameter.FindSet() then
            repeat
                SQLCommand.Parameters.AddWithValue(SQLParameter.Name, SQLParameter.Value);
            until SQLParameter.Next() = 0;
    end;
}
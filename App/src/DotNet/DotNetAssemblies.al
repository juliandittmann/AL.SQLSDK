dotnet
{
    assembly(Microsoft.Data.SqlClient)
    {
        type(Microsoft.Data.SqlClient.SqlConnection; SqlConnection) { }
        type(Microsoft.Data.SqlClient.SqlCredential; SqlCredential) { }
        type(Microsoft.Data.SqlClient.SqlParameter; SqlParamenter) { }
        type(Microsoft.Data.SqlClient.SqlCommand; SqlCommand) { }
        type(Microsoft.Data.SqlClient.SqlConnectionStringBuilder; SqlConnectionStringBuilder) { }
    }
}
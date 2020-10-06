
dotnet
{

    assembly(System.Core)
    {
        type(System.Security.Cryptography.SHA256CryptoServiceProvider; SHA256CryptoServiceProvider) { }
    }

    assembly(System.Data)
    {
        type(System.Data.SqlDbType; SqlDbType) { }
        type(System.Data.SqlClient.SqlConnection; SqlConnection) { }
        type(System.Data.SqlClient.SqlCredential; SqlCredential) { }
        type(System.Data.SqlClient.SqlParameter; SqlParamenter) { }
        type(System.Data.SqlClient.SqlCommand; SqlCommand) { }
        type(System.Data.SqlClient.SqlConnectionStringBuilder; SqlConnectionStringBuilder) { }
    }
}

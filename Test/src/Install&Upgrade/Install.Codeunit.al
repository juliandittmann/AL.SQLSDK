codeunit 50151 "jdi SQL API Test Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        TestToolHelper: Codeunit "jdi SQL API Test Helper";
    begin
        TestToolHelper.Create('DEFAULT', '50150..50199', true);
    end;
}
codeunit 50151 "jdi SQL Test Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        TestToolHelper: Codeunit "jdi SQL Test Helper";
    begin
        TestToolHelper.Create('DEFAULT', '50150..50199', true);
    end;
}
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = [System.IO.Path]::Combine($here, "..\iac\iac.psd1")
import-module $modulePath -Force

Describe "Assert-SpecificationType" -Tags "Specifications" {

    It "Null attributes throw exception" {
        $specification = @{server_name=$null; server_location=@{}}
        {
            Assert-SpecificationType -SpecificationList $specification
        } | Should -Not -Throw
    }

    It "other types than hashtable must throw excpetion" {
        $specification = @{attribute1="win_2"; attribute2="usa"}
        {
            Assert-SpecificationType -SpecificationList $specification
        } | Should -Throw "Bad type"
    }

    It "Only hashtable must not throw excpetion" {
        $specification = @{attribute1=@{}; attribute2=@{}}
        {
            Assert-SpecificationType -SpecificationList $specification
        } | Should -Not -Throw
    }


}
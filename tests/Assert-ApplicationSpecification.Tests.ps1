$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = [System.IO.Path]::Combine($here, "..\iac\iac.psd1")
import-module $modulePath -Force

Describe "Assert-ApplicationSpecification" -Tags "Specifications" {

    It "Empty application specification should not throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\empty_application_specifications-1.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Not -Throw
    }

    It "Empty application specification with empty environment should not throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\empty_application_specifications-2.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Not -Throw
    }

    It "Empty application specification with null attributes should not throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\empty_application_specifications-3.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Not -Throw
    }


    It "Application specification with unexpected attributes under applications must throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\bad_application_specifications-1.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Throw "Application key must contains only keys"
    }

    It "Application specification with unexpected attributes under environment must throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\bad_application_specifications-2.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Throw "Unexpected attributes found"
    }


    It "Application specification with bad attribute types must throw exception" {
        $SpecificationPath = [System.IO.Path]::Combine($here,"test-cases\bad_type_application_specifications-1.yml")
        $yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

        $loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

        {
            Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification
        } | Should -Throw "Specification must only be defined by a Hashtable"
    }


}
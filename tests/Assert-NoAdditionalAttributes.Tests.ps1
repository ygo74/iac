$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = [System.IO.Path]::Combine($here, "..\iac\iac.psd1")
import-module $modulePath

Describe "Assert-NoAdditionalAttributes" -Tags "Specifications" {

    It "Unexpected attributes throw exception" {
        $specification = @{server_name="win_2"; server_location="usa"}
        $mandatoryAttributes = @("attribute1", "attribute2")
        {
            Assert-NoAdditionalAttributes -Context "Unit tests" `
                                          -SpecificationList $specification `
                                          -ExpectedKeys $mandatoryAttributes
        } | Should -Throw "Unexpected attributes found"
    }

    It "No unexpected attributes should not throw exception" {
        $specification = @{attribute1="win_2"; attribute2="usa"}
        $mandatoryAttributes = @("attribute1", "attribute2")
        {
            Assert-NoAdditionalAttributes -Context "Unit tests" `
                                          -SpecificationList $specification `
                                          -ExpectedKeys $mandatoryAttributes
        } | Should -Not -Throw
    }

}
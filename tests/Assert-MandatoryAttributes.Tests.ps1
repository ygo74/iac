$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = [System.IO.Path]::Combine($here, "..\iac\iac.psd1")
import-module $modulePath

Describe "Assert-MandatoryAttributes" -Tags "Specifications" {

    It "Missing mandatory attributes throw exception" {
        $specification = @{server_name="win_2"; server_location="usa"}
        $mandatoryattributes = @("attribute1", "attribute2")
        {
            Assert-MandatoryAttributes -Context "Unit tests" `
                                       -SpecificationList $specification `
                                       -ExpectedKeys $mandatoryattributes
        } | Should -Throw "Missing keys in the context"
    }

    It "Mandatory attributes should not throw exception" {
        $specification = @{attribute1="win_2"; attribute2="usa"}
        $mandatoryattributes = @("attribute1", "attribute2")
        {
            Assert-MandatoryAttributes -Context "Unit tests" `
                                       -SpecificationList $specification `
                                       -ExpectedKeys $mandatoryattributes
        } | Should -Not -Throw
    }

}
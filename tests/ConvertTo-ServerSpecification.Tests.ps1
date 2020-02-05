$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = [System.IO.Path]::Combine($here, "..\iac\iac.psd1")
import-module $modulePath

Describe "ConvertTo-ServerSpecification" -Tags "Specifications" {

    It "Missing mandatory attributes throw exception" {
        $ServerSpecification = "{server_name: win_2, server_location: usa}"
        { ConvertTo-ServerSpecification -Specification $ServerSpecification } | Should -Throw "Missing mandatory attributes"
    }

    It "Mandatory attributes should not throw exception" {
        $ServerSpecification = "{server_name: win_2, server_location: usa, server_environment: dev}"
        { ConvertTo-ServerSpecification -Specification $ServerSpecification } | Should -Not -Throw
    }

    It "Function must return object with attributes" {
        $ServerSpecification = "{server_name: win_2, server_location: usa, server_environment: dev}"
        $server = ConvertTo-ServerSpecification -Specification $ServerSpecification

        $server.server_name | Should -BeExactly "win_2"
        $server.server_location | Should -BeExactly "usa"
        $server.server_environment | Should -BeExactly "dev"


    }


}
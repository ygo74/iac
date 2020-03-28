function Assert-ApplicationSpecification
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.Hashtable]
    $ApplicationSpecification
  )
  process
  {
    # -----------------------------------------------------------------------------
    # Check the loaded specification quality
    # -----------------------------------------------------------------------------

    # Check if application specification contains the mandatory top keys
    $MandatorySpecificationTopKeys = @("application", "environments")
    Assert-MandatoryAttributes -Context "Application specification" `
                              -SpecificationList $ApplicationSpecification `
                              -ExpectedKeys $MandatorySpecificationTopKeys

    # Check if application contains unexpected attributes
    $applicationKeys = @("roles", "locations")
    Assert-NoAdditionalAttributes -Context "Application key" `
                                  -SpecificationList $ApplicationSpecification.application `
                                  -ExpectedKeys $applicationKeys

    # Check if application roles and location contains only hashtable
    foreach($key in $applicationKeys)
    {
        if ($null -ne $ApplicationSpecification.application[$key])
        {
          Assert-SpecificationType -SpecificationList $ApplicationSpecification.application[$key]
        }
    }

    # Check if environment contains unexpected attributes
    $environmentKeys = @("roles", "locations","servers")
    foreach($environment in $ApplicationSpecification.environments.Keys)
    {
        # Check if environment contains unexpected attributes
        Assert-NoAdditionalAttributes -Context "Environment $environment" `
                                    -SpecificationList $ApplicationSpecification.environments[$environment] `
                                    -expectedKeys $environmentKeys

        # Check if application roles, location, servers contains only hashtable
        foreach($key in $environmentKeys)
        {
          if ($null -ne $ApplicationSpecification.environments[$environment][$key])
          {
            Assert-SpecificationType -SpecificationList $ApplicationSpecification.environments[$environment]
          }
        }

    }

  }
}

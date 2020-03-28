function Assert-SpecificationType
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
    [ValidateNotNull()]
    [System.Collections.Hashtable]
    $SpecificationList
  )
  process
  {
    # Check if application roles and location contains only hashtable
    $errorSpecifications = @()
    $SpecificationList.Keys | ForEach-Object {
      $subkey = $SpecificationList[$_]
      if ($null -eq $subkey)
      {
        # Allow null attributes
        # $nullAttribute = @{
        #   key = $key
        #   specification = $_
        #   error = "Null attribute"
        # }
        # $errorSpecifications += $nullAttribute
      }
      elseif ($subkey.GetType().FullName -ne "System.Collections.Hashtable")
      {
        $batTypeAttribute =@{
          key = $key
          specification = $_
          error = "Bad type : $($subkey.GetType().FullName)"
        }
        $errorSpecifications += $batTypeAttribute
      }
    }

    if ($errorSpecifications.Length -gt 0) {

      $errorAttributesMessage = ""
      $errorSpecifications | ForEach-Object {
        if ($errorAttributesMessage -ne "") {$errorAttributesMessage += "`r`n"}
        $errorAttributesMessage += "Attribute $($_.specification) under $($_.key) is $($_.error)"
      }

      throw "Specification must only be defined by a Hashtable.`r`n" +  $errorAttributesMessage
    }
  }
}

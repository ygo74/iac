function Assert-NoAdditionalAttributes
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$false, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Context,

    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=1)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.Hashtable]
    $SpecificationList,

    [Parameter(Mandatory=$true,ValueFromPipeline=$false, Position=2)]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ExpectedKeys

  )
  process
  {
    $diff = [Linq.Enumerable]::Except(([Object[]]$SpecificationList.Keys), $ExpectedKeys)
    if ($diff.count -gt 0)
    {
      throw "Unexpected attributes found in the $Context.`r`n" + `
            "$Context must contains only keys : $ExpectedKeys`r`n" + `
            "Found attributes : $($diff)"
    }
  }
}


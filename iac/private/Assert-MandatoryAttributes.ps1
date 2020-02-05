function Assert-MandatoryAttributes
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
    $diff = [Linq.Enumerable]::Except($ExpectedKeys, ([Object[]]$SpecificationList.Keys))
    if ($diff.count -gt 0)
    {
      throw "Missing keys in the Context $Context.`r`n" + `
            "Mandatory keys : $ExpectedKeys`r`n" + `
            "Object attributes : $([Object[]]$SpecificationList.Keys)"
    }

  }
}

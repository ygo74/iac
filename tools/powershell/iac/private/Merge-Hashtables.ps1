function Merge-Hashtables
{
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable]
        $Reference,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable]
        $New

      )
      process
      {

        $New.keys | `
            Where-Object {$_ -notin $Reference.keys} | `
            ForEach-Object {$Reference[$_] = $New[$_]}
      }
}

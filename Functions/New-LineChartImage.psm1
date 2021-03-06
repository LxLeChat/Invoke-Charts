Function New-LineChartImage{
    <#
    .SYNOPSIS
        Generate a Line Chart image file.
    .DESCRIPTION
        Generate a Line Chart image file.
    .EXAMPLE
        PS C:\> $OrderedHashtable1 = [Ordered]@{a=3;b=8;c=6}
        PS C:\> $OrderedHashtable2 = [Ordered]@{a=5;b=2;c=10}
        PS C:\> $OrderedHashtable3 = [Ordered]@{a=3;b=12}
        PS C:\> New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Hash $OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
        Create 3 ordered hashtable, with the same keys order. Generates a linechart image named LineChartFromPipeline.png in the currentd path.
    .INPUTS
        System.Collections.Specialized.OrderedDictionary
    .OUTPUTS
        PNG file.
    .NOTES
        Feel free to contribute, fork, create issues etc...
        https://github.com/LxLeChat/SimpleCharts
    #>

    [cmdletbinding()]
    param(
        [parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [ValidateScript({If($_.gettype().toString() -eq "System.Collections.Specialized.OrderedDictionary"){$True}Else{Throw "You must provide an ordered HashTable, `$hash=@{""a""=1;""b""=2} "}})]
        [System.Collections.Specialized.OrderedDictionary[]]$Hash,
        [String]$Path,
        [String]$Title,
        [Int]$Width,
        [Int]$Height,
        [String]$Color,
        [Switch]$Legend,
        [String]$LegendTitle,
        [String[]]$LegendText
    )

    Begin {
        ## Test & Define default value For Width
        If ( $null -eq $PSBoundParameters['Width'] ) {
            $PSBoundParameters.Add('Width',500)
        }

        ## Test & Define default value For Height
        If ( $null -eq $PSBoundParameters['Height'] ) {
            $PSBoundParameters.Add('Height',250)
        }

        ## Test & Define default value For Color
        If ( $null -eq $PSBoundParameters['Color'] ) {
            $PSBoundParameters.Add('Color','#58d68d')
        }

        ## Test & Define default value For Title
        If ( $null -eq $PSBoundParameters['Title'] ) {
            $PSBoundParameters.Add('Title','Default Title')
        }

        ## Test & Define default value For Title
        If ( $null -eq $PSBoundParameters['LegendTitle'] ) {
            $PSBoundParameters.Add('LegendTitle','Default Legend Title')
        }

        ## Test & Define default value For LegendText
        If ( $null -eq $PSBoundParameters['LegendText'] ) {
            $PSBoundParameters.Add('LegendText',"This is a Legend")
        }
        

        ## Test Path, if root directory doest exist, return nothing, for the moment..
        Try {
            If ( !(Test-Path -Path ([System.IO.FileInfo]$PSBoundParameters["Path"]).Directory.FullName) ) {
                Throw "Invalid Path..."
            }
        } Catch {
            Return $PSItem
        }

        ## Load necessary assemblies
        Try {
            Add-Type -AssemblyName System.Windows.Forms, System.Windows.Forms.DataVisualization -ErrorAction Stop
        } Catch {
            Return $PSItem
        }

        ## Create Chart Object
        $Chart = New-object -TypeName System.Windows.Forms.DataVisualization.Charting.Chart
        $Chart.Width = $PSBoundParameters['Width']
        $Chart.Height = $PSBoundParameters['Height']
        $Chart.Left = 0
        $Chart.Top = 0
        
        ## Title
        [void]$chart.Titles.Add($PSBoundParameters['Title'])
        $Chart.Titles["Title1"].alignment = "TopCenter"

        ## Create a ChartArea to draw on and add to chart
        $ChartArea = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.ChartArea
        $ChartArea.Name = "chart"
        $ChartArea.AxisX.LabelStyle.Angle = -90
        $chartarea.AxisX.IsLabelAutoFit = $False
        $ChartArea.AxisX.IsMarginVisible = $False
        #$ChartArea.AxisY2.Enabled = [System.Windows.Forms.DataVisualization.charting.AxisEnabled]::True
        $ChartArea.AxisX.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
        $ChartArea.AxisY.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
        $ChartArea.AxisX.MajorGrid.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
        $ChartArea.AxisY.MajorGrid.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
        
        ## Add ChartArea to chart
        $Chart.ChartAreas.Add($ChartArea)

        ## Add Legend
        If( $PSBoundParameters['Legend'].isPresent ) {
            $ChartLegend = New-Object -TypeName system.Windows.Forms.DataVisualization.Charting.Legend
            $ChartLegend.name = "Legend1"
            $ChartLegend.LegendStyle = "Table"
            $ChartLegend.Alignment  = "Center"
            $ChartLegend.Title = $PSBoundParameters['LegendTitle']
            $ChartLegend.TitleAlignment = "Near"

            $chart.Legends.Add($ChartLegend)

            $chart.Legends["Legend1"].docking = "Bottom"
        }

        ## counter variable
        $counter = 0

        ## Color Palette
        $CustomColorPalette = `
        [System.Drawing.ColorTranslator]::FromHtml("#e74c3c"),`
        [System.Drawing.ColorTranslator]::FromHtml("#9b59b6"),`
        [System.Drawing.ColorTranslator]::FromHtml("#3498db"),`
        [System.Drawing.ColorTranslator]::FromHtml("#16a085"),`
        [System.Drawing.ColorTranslator]::FromHtml("#2ecc71"),`
        [System.Drawing.ColorTranslator]::FromHtml("#f39c12"),`
        [System.Drawing.ColorTranslator]::FromHtml("#d35400"),`
        [System.Drawing.ColorTranslator]::FromHtml("#7f8c8d"),` #gris
        [System.Drawing.ColorTranslator]::FromHtml("#d2b4de"),` #violet clair
        [System.Drawing.ColorTranslator]::FromHtml("#bdc3c7"),` #gris un peu plus clair
        [System.Drawing.ColorTranslator]::FromHtml("#0e6251"),` #marron.
        [System.Drawing.ColorTranslator]::FromHtml("#34495e"),` #gris bleu
        [System.Drawing.ColorTranslator]::FromHtml("#edbb99"),`
        [System.Drawing.ColorTranslator]::FromHtml("#f1c40f"),`
        [System.Drawing.ColorTranslator]::FromHtml("#abebc6"),` #vert clair 'pop'
        [System.Drawing.ColorTranslator]::FromHtml("#196f3d"),`
        [System.Drawing.ColorTranslator]::FromHtml("#73c6b6"),`
        [System.Drawing.ColorTranslator]::FromHtml("#aed6f1"),`
        [System.Drawing.ColorTranslator]::FromHtml("#5f6a6a"),` #gris foncé
        [System.Drawing.ColorTranslator]::FromHtml("#154360"),`
        [System.Drawing.ColorTranslator]::FromHtml("#f5b7b1"),`
        [System.Drawing.ColorTranslator]::FromHtml("#922b21")
    }

    Process {
        
        Foreach ( $DataSerie in $Hash ) {
            ## Random Color
            $RandomColor = (get-random $CustomColorPalette)

            ## Dynamic Serie Name
            $SeriesName = "Data$Counter"

            ## Create new serie and add it to the chart series
            [void]$Chart.Series.Add($SeriesName)
            
            ## Configure Current Serie
            $Chart.Series[$SeriesName].Points.DataBindXY($DataSerie.Keys, $DataSerie.Values)
            $Chart.Series[$SeriesName].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
            $Chart.Series[$SeriesName]["LineTension"] = "0.295"
            $Chart.Series[$SeriesName].label = "#VALY"
            $Chart.Series[$SeriesName]["LabelStyle"] = "Top"
            #$Chart.Series[$SeriesName].Color = [System.Drawing.ColorTranslator]::FromHtml($PSBoundParameters['Color'])
            $Chart.Series[$SeriesName].Color = $RandomColor
            
            $Chart.Series[$SeriesName].LegendText = $PSBoundParameters['LegendText'][$counter]

            $Chart.Series[$SeriesName].MarkerSize = 10
            $Chart.Series[$SeriesName].MarkerStyle = [System.Windows.Forms.DataVisualization.Charting.MarkerStyle]::Star4
            #$Chart.Series[$SeriesName].MarkerColor = [System.Drawing.ColorTranslator]::FromHtml($PSBoundParameters['Color'])
            $Chart.Series[$SeriesName].MarkerColor = $RandomColor
            $Chart.Series[$SeriesName].MarkerBorderColor = [System.Drawing.ColorTranslator]::FromHtml("#616161")

            $counter++
        }
       
    }

    End {
        ## Save chart as image
        Try {
            $Chart.SaveImage($($PSBoundParameters["path"]),"png")
            [System.IO.FileInfo]$PSBoundParameters['path'] | Select-Object Mode,LastWriteTime,Name,FullName
        } Catch {
            $_
        }
    }

}


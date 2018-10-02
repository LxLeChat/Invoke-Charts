# Invoke-Charts
Basic Charting functions for Powershell.
Create png files
You provide, one or more Ordered Hashtable

# New-LineChartImage
-New-LineChartImage, usage example(s):
```powershell
New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Hash $OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```
```powershell
$OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 | New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/LineChartFromThePipeLine.png)



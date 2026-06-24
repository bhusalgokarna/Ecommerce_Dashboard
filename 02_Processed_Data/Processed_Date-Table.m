let
    // Define start and end dates to cover your full dataset
    StartDate = #date(2016, 1, 1),
    EndDate   = #date(2018, 12, 31),

    // Calculate number of days between start and end
    NumberOfDays = Duration.Days(EndDate - StartDate),

    // Generate a list of all dates
    DateList = List.Dates(StartDate, NumberOfDays + 1, #duration(1, 0, 0, 0)),

    // Convert list to table
    TableFromList = Table.FromList(DateList, Splitter.SplitByNothing()),

    // Rename the single column to Date
    RenamedColumn = Table.RenameColumns(TableFromList, {{"Column1", "Date"}}),

    // Set correct data type
    ChangedType = Table.TransformColumnTypes(RenamedColumn, {{"Date", type date}}),

    // Add Year column
    AddedYear = Table.AddColumn(ChangedType, "Year", each Date.Year([Date]), Int64.Type),

    // Add Month Number column
    AddedMonthNum = Table.AddColumn(AddedYear, "Month_Number", each Date.Month([Date]), Int64.Type),

    // Add Month Name column
    AddedMonthName = Table.AddColumn(AddedMonthNum, "Month_Name", each Date.ToText([Date], "MMMM"), type text),

    // Add Quarter column
    AddedQuarter = Table.AddColumn(AddedMonthName, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),

    // Add Week Number column
    AddedWeekNum = Table.AddColumn(AddedQuarter, "Week_Number", each Date.WeekOfYear([Date]), Int64.Type),

    // Add Day Name column
    AddedDayName = Table.AddColumn(AddedWeekNum, "Day_Name", each Date.ToText([Date], "dddd"), type text),

    // Add Year-Month for sorting (e.g. 2017-03)
    AddedYearMonth = Table.AddColumn(AddedDayName, "Year_Month", each Text.From(Date.Year([Date])) & "-" & Text.PadStart(Text.From(Date.Month([Date])), 2, "0"), type text),
    #"Changed Type" = Table.TransformColumnTypes(AddedYearMonth,{{"Year", type date}, {"Year_Month", type datetime}, {"Date", type datetime}})

in
    #"Changed Type"
use nbndata 
go
CREATE TABLE #Locations (
  Location_Key CHAR(16) COLLATE Database_Default PRIMARY KEY
)

INSERT INTO #Locations VALUES ('SR00030500010003')

WHILE 1=1 BEGIN
  INSERT INTO   #Locations
    SELECT        L.Location_Key
    FROM          Location L
    INNER JOIN    #Locations Tinc ON
                    L.Parent_Key=TInc.Location_Key
    LEFT JOIN     #Locations Texc ON
                    L.Location_Key = Texc.Location_Key
    WHERE         Texc.Location_Key IS NULL
  IF @@ROWCOUNT=0
    BREAK
END

SELECT        L.LOCATION_KEY AS LKEY,
              L.SPATIAL_REF AS GRID_REF,
              LN.ITEM_NAME AS LOC_NAME,
              L.FILE_CODE,
              dbo.ufn_RtfToPlaintext(L.DESCRIPTION) AS [DESC],
              dbo.LCReturnEastings_c(L.SPATIAL_REF, L.SPATIAL_REF_SYSTEM) AS X,
              dbo.LCReturnNorthings_c(L.SPATIAL_REF, L.SPATIAL_REF_SYSTEM) AS Y
FROM          #LOCATIONS LOCS
INNER JOIN    LOCATION L ON
              LOCS.LOCATION_KEY = L.LOCATION_KEY
INNER JOIN    LOCATION_NAME LN ON
              L.LOCATION_KEY = LN.LOCATION_KEY

DROP TABLE #Locations
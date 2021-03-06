SELECT	COUNT(TXO.TAXON_OCCURRENCE_KEY) AS [Record Count],
		CASE WHEN I.FORENAME IS NULL THEN
			CASE WHEN I.INITIALS IS NULL THEN
				CASE WHEN I.TITLE IS NULL THEN I.SURNAME
				ELSE I.SURNAME + ', ' + I.TITLE END
			ELSE I.SURNAME + ', ' + I.INITIALS END
		ELSE I.SURNAME + ', ' + I.FORENAME END AS [Full Name]

FROM	TAXON_OCCURRENCE AS TXO
		INNER JOIN SAMPLE AS S ON TXO.SAMPLE_KEY = S.SAMPLE_KEY
		INNER JOIN SURVEY_EVENT AS SE ON S.SURVEY_EVENT_KEY = SE.SURVEY_EVENT_KEY
		INNER JOIN SURVEY_EVENT_RECORDER AS SER ON SE.SURVEY_EVENT_KEY = SER.SURVEY_EVENT_KEY
		INNER JOIN INDIVIDUAL AS I ON SER.NAME_KEY = I.NAME_KEY

GROUP BY CASE WHEN I.FORENAME IS NULL THEN
			CASE WHEN I.INITIALS IS NULL THEN
				CASE WHEN I.TITLE IS NULL THEN I.SURNAME
				ELSE I.SURNAME + ', ' + I.TITLE END
			ELSE I.SURNAME + ', ' + I.INITIALS END
		 ELSE I.SURNAME + ', ' + I.FORENAME END

ORDER BY [Record Count] DESC
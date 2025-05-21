GO
CREATE OR ALTER FUNCTION tSQLt.[@tSQLt:print](@Param1 NVARCHAR(MAX) = NULL)
    RETURNS TABLE
        AS
        RETURN SELECT 'PRINT ' + X.ParamName1 as 'AnnotationCmd'
               FROM (VALUES ('''' + REPLACE(@Param1, '''', '''''') + '''')) X(ParamName1);

GO
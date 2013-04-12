-- Grant access permissions
IF EXISTS (SELECT * FROM SysObjects WHERE Id = Object_Id('[dbo].[LCReturnEastings_c]'))
BEGIN
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_Administrator')
		GRANT EXECUTE ON [dbo].[LCReturnEastings_c] TO [R2k_Administrator]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_FullEdit')
		GRANT EXECUTE ON [dbo].[LCReturnEastings_c] TO [R2k_FullEdit]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_AddOnly')
		GRANT EXECUTE ON [dbo].[LCReturnEastings_c] TO [R2k_AddOnly]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_ReadOnly')
		GRANT EXECUTE ON [dbo].[LCReturnEastings_c] TO [R2k_ReadOnly]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_RecordCardsOnly')
		GRANT EXECUTE ON [dbo].[LCReturnEastings_c] TO [R2k_RecordCardsOnly]
END
GO 
-- Grant access permissions
IF EXISTS (SELECT * FROM SysObjects WHERE Id = Object_Id('[dbo].[LCReturnNorthings_c]'))
BEGIN
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_Administrator')
		GRANT EXECUTE ON [dbo].[LCReturnNorthings_c] TO [R2k_Administrator]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_FullEdit')
		GRANT EXECUTE ON [dbo].[LCReturnNorthings_c] TO [R2k_FullEdit]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_AddOnly')
		GRANT EXECUTE ON [dbo].[LCReturnNorthings_c] TO [R2k_AddOnly]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_ReadOnly')
		GRANT EXECUTE ON [dbo].[LCReturnNorthings_c] TO [R2k_ReadOnly]
	IF EXISTS (SELECT * FROM SysUsers WHERE NAME = 'R2k_RecordCardsOnly')
		GRANT EXECUTE ON [dbo].[LCReturnNorthings_c] TO [R2k_RecordCardsOnly]
END
GO 
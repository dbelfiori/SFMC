%%[
SET @MasterID = RequestParameter("masterID")
SET @SubscriberKey = RequestParameter("SubscriberKey")
SET @Email_Address = RequestParameter("Email_Address")
SET @Option = RequestParameter("Option")


SET @DE_Lookup = 'summer_poll_de_test'
set @hasSubmitted = lookUp(@DE_Lookup, 'Option', 'MasterID', @MasterID)

IF NOT EMPTY(@hasSubmitted) THEN 
    Redirect("https://petco.com/?param=existing")
ELSE
    InsertDE(@DE_Lookup,
        'MasterID', @MasterID,
        'SubscriberKey', @SubscriberKey,
        'Email_Address', @Email_Address,
        'Option', @Option,
        'Date_Modified', formatDate(now(), 'l', 'h:mm tt')
    )
    Redirect("https://petco.com/?param=success")
ENDIF
]%%

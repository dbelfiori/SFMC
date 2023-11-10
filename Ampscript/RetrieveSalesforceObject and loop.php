<!-- %%[

SET @ProspectLeadID = AttributeValue('CD_Prospect_Lead_ID__c')

SET @prospectRow = RetrieveSalesforceObjects("CD_Prospect_Lead__c","OwnerId,DCL_ITA__c","ID", "=", @prospectleadid)

IF RowCount(@prospectRow) > 0 then

    SET @Row = Row(@prospectRow,1)

    SET @ID = field(@row, "ID")

    SET @OwnerId = field(@row, "OwnerId")

    SET @DCL_ITA__c = field(@row, "DCL_ITA__c")

ELSE

SET @OwnerError = "Prospect Detail Error"

ENDIF

 

IF @DCL_ITA__c == true then

    set @phoneNumber = '800-236-7827'

ELSE

    set @phoneNumber = '888-318-4483'

ENDIF

 

set @UserRow = LookupOrderedRows("ENT.Customer_Eligible_Offers__c_Salesforce",0,

    "DCL_Offer_APR__c ASC","DCL_Prospect_Lead__c", @ID

    )

 

set @rowCount = rowcount(@UserRow)

]%% -->

 

 

 

 

 

<table align="center" class="stackTbl" border="0" cellpadding="0" cellspacing="0" style="width:600px;" width="600">

%%[

    if @rowCount > 0 then

        SET @Row = Row(@userRow, 1)

        SET @loan_amount = field(@row, "DCL_LoanAmount__c")

        SET @expiration = field(@row, "DCL_ExpirationDate__c")

]%%

    <tr>

        <th class="textAlignCenter" colspan="3" scope="col"

            style="font-family: Helvetica, sans-serif, arial; padding: 10px 2px 10px 10px; font-size: 16px; line-height: 19px; color: #2E2E32; background-color: #EEEEF2; text-align: left;"

            valign="middle" width="25%">

            Requested loan amount: %%=format(@loan_amount, 'C2')=%%</th>

    </tr>%%[endif]%%

%%[

    if @rowCount > 0 then

    for @i = 1 to @rowCount do

        SET @Row = Row(@userRow, @i)

        SET @loan_amount = field(@row, "DCL_LoanAmount__c")

        SET @monthly_payment = field(@row, "DCL_Monthly_Payment__c")

        SET @terms_month = field(@row, "DCL_Term_Months__c")

        SET @apr_offer = field(@row, "DCL_Offer_APR__c")

]%%

 

<tr>

    <td align="left"

        style="font-family: Helvetica, sans-serif, arial; padding:12px 6px 12px 6px; font-size:16px; line-height: 19px; color:#2E2E32; border-bottom:1px solid #CCCCD2;"

        valign="middle" width="25%">

        %%=format(@monthly_payment, 'C2')=%%/month

    </td>

    <td align="center"

        style="font-family: Helvetica, sans-serif, arial; padding:12px 6px 12px 6px; font-size:16px; line-height: 19px; color:#2E2E32; border-bottom:1px solid #CCCCD2;"

        valign="middle" width="25%">

        %%=v(@apr_offer)=%%% APR</td>

    <td align="center"

        style="font-family: Helvetica, sans-serif, arial; padding:12px 6px 12px 6px; font-size:16px; line-height: 19px; color:#2E2E32; border-bottom:1px solid #CCCCD2;"

        valign="middle" width="25%">

        %%=format(@terms_month, 'N0')=%% months</td>

</tr>

 

%%[ next @i ]%%

%%[ endif ]%%

</table>
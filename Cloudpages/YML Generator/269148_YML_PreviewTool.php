%%[

SET @jsopeningTag = CONCAT("<","script")
SET @jsclosingTag = CONCAT("<","/script",">")

/* Login Credentials */
SET @USR_AC_LIST = BuildRowsetFromString('petco|jam','|')
SET @PWD_AC_LIST = BuildRowsetFromString('1ggyp3bbles|1ggyj3ffery','|')

/* PARAMETERS */
SET @USR = RequestParameter('USR')
SET @PWD = RequestParameter('PWD')

/* LOGIN CHECK */
for @i = 1 to Rowcount(@USR_AC_LIST) do
 SET @USR_AC_ROW = ROW(@USR_AC_LIST, @i)
 SET @USR_AC = Field(@USR_AC_ROW,1)
 IF @USR == @USR_AC THEN
  SET @PWD_RN = @i
 ENDIF
next @i

IF NOT EMPTY(@PWD_RN) THEN
  SET @USR_AC = FIELD(ROW(@USR_AC_LIST,@PWD_RN),1)
  SET @PWD_AC = FIELD(ROW(@PWD_AC_LIST,@PWD_RN),1)
ELSE
  SET @PWD_AC = GUID()
ENDIF

]%%
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="https://image.e.petco.com/lib/fe34157075640575771d76/m/1/fc0d2a11-01d4-40f8-9e09-b3c2ecbf527d.png">

  <title>%%=v(@JAM_Project)=%%</title>
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
  %%=ContentBlockbyKey(CONCAT(@target_id_folder, "_YML_CSS"))=%%
</head>

%%[ IF @PWD == @PWD_AC THEN /* LOGGED IN */ ]%%
  <body>
   %%=ContentBlockbyKey(CONCAT(@target_id_folder, "_YML_PreviewPage"))=%%
    %%=Concat(@jsopeningTag," src='https://unpkg.com/vue@3.0.7/dist/vue.global.prod.js' runat='client'>")=%% %%=v(@jsclosingTag)=%%
  </body>
%%[ ELSE /* LOGIN PAGE */ ]%%
 %%=ContentBlockbyKey(CONCAT(@target_id_folder, "_YML_LoginPage"))=%%
%%[ ENDIF ]%%

</html>

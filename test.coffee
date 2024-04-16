%%[set @environment = 'P']%%
%%=ContentBlockById("357816")=%%
<script runat=server>
  Platform.Load("core","1.1.1");
  Platform.Response.SetResponseHeader("Strict-Transport-Security","max-age=200");
  Platform.Response.SetResponseHeader("X-XSS-Protection","1; mode=block");
  Platform.Response.SetResponseHeader("X-Frame-Options","Deny");
  Platform.Response.SetResponseHeader("X-Content-Type-Options","nosniff");
  Platform.Response.SetResponseHeader("Referrer-Policy","strict-origin-when-cross-origin");
  Platform.Response.SetResponseHeader("Cache-Control","no-store");
  //Platform.Response.SetResponseHeader("Content-Security-Policy","default-src 'self'");
</script>

%%[
/* 
  Order taker

  ptms parameter structure
  ptms="variable=variable-value:::variable=variable-value|variable=variable-value:::variable=variable-value"

  variable=variable-value
  variable          ex. Passenger_Number
  variable-value    ex. 21 so, Passenger_Number = 21
  :::               seperates 2 variables and there value
  |                 order has ended, new one starts

*/
var @emAddr,
    @ptms,
    @mealSelections,
    @order,
    @sendemail,
    @congratulations,
    @ts_statusMsg,
    @errorCode

set @message_Description = '<p>The page you have requested is currently unavailable.</p>'
set @sendemail = '0'
set @emAddr = requestParameter('emAddr')
set @ptms = requestParameter('ptms')
set @mealSelections = requestParameter('mealSelections')
set @orders = buildRowSetFromString(@ptms, '|')

/* loop through orders seperated by '|' */
for @i = 1 to rowCount(@orders) do
  set @ordersRow = row(@orders, @i)
  set @ordersRowItem = field(@ordersRow, 1)

  /* loop through order variables seperated by ':::' */
  set @order = buildRowSetFromString(@ordersRowItem, ':::')
    /*
    Since the order comes in as one long string (ptms),
    the ampscript variables used will have to be built dynamically
    using a loop and treatAsContent to construct them.
    */
    for @j = 1 to rowCount(@order) do
      set @orderRow = row(@order, @j)
      set @orderRowField = field(@orderRow, 1)
      set @orderPropertyNameAndValue = buildRowSetFromString(@orderRowField, '=')
      
      /* order properties and values for building variables */
      set @nameColumn = row(@orderPropertyNameAndValue, 1)
      set @valueColumn = row(@orderPropertyNameAndValue, 2)
      set @name = field(@nameColumn, 1)
      set @value = field(@valueColumn, 1)

      /* 
      build variables - set @name = @value
      result - set @Passenger_Number = 1
      */
      treatAsContent( Concat( "%", "%[ SET @", @name, " = @value ]%", "%") )
    next @j
      
      set @hasMealsSelected = lookUp(@env_Advance_Booking_Qualifications, 'Meals_Selected', 'PNR_Reservation_Number', @PNR_Reservation_Number, 'PNR_Create_Date',@PNR_Create_Date,'Segment_Number',@Segment_Number,'Ticket_Number',@Ticket_Number)

      if not empty(@hasMealsSelected) then 
        /* if entry exists */
        set @message_title = '<p>You have already submitted your meal selections. Any changes to your order will need to be <span style="white-space: nowrap;">made <a class="btn_link" target="_blank" href="https://www.amtrak.com/flexdining">on board</a>.</p></span>'
        set @message_Description = ''
      else
        /* make sure Passenger_Name is letters only */
        set @Passenger_Name_Modified = ''
        for @k = 1 to length(@Passenger_Name) do
          set @char = substring(@Passenger_Name, @k, 1)
          set @Passenger_Name_Modified = iif(empty(regexmatch(@char,'[a-zA-Z0-9 ]', 0)), concat(@Passenger_Name_Modified,''), concat(@Passenger_Name_Modified, @char)) 
        next @k

        InsertDE(@env_PreTripMealSelectionData,
          'Passenger_Number', @Passenger_Number,
          'Passenger_Name', @Passenger_Name_Modified,
          'PNR_Reservation_Number', @PNR_Reservation_Number,
          'PNR_Create_Date', formatDate(@PNR_Create_Date, 'l', 'h:mm tt'),
          'Segment_Number', @Segment_Number,
          'Ticket_Number', @Ticket_Number,
          'Train_Number', @Train_Number,
          'Train_Trip_Start_Date', formatDate(@Train_Trip_Start_Date, 'l', 'h:mm tt'),
          'Meal_Period', @Meal_Period,
          'Meal_ID', @Meal_ID,
          'Quantity', @Quantity,
          'Meal_Date', formatDate(now(), 'l', 'h:mm tt'),
          'Date_Created', formatDate(now(), 'l', 'h:mm tt'),
          'Date_Modified', formatDate(now(), 'l', 'h:mm tt')
        )
        set @message_title = '<h1>Congratulations.</h1>'
        set @message_Description = '<p>You have successfully chosen your meals for your upcoming trip. Any changes will need to be made once you are <a class="btn_link" target="_blank" href="https://www.amtrak.com/flexdining">on board</a>.</p>'
        set @congratulations = 'congratulations'
        set @sendemail = '1'
      endif
next @i


/* Udpate Advance_Booking_Qualifications DE */
set @MealsFlag = '1'
UpdateDE(
  @env_Advance_Booking_Qualifications,4,
  'PNR_Reservation_Number', @PNR_Reservation_Number,
  'PNR_Create_Date', @PNR_Create_Date,
  'Segment_Number', @Segment_Number,
  'Ticket_Number', @Ticket_Number,
  'Meals_Selected', @MealsFlag,
  'Meals_Posted_Date', now()
)

/* Insert user to PreTripMealSelectionConfirmation DE */
if @sendemail == '1' then
  /* Initiate Confirmation Trigger */
  SET @ts = CreateObject("TriggeredSend")
  SET @tsDef = CreateObject("TriggeredSendDefinition")

  SetObjectProperty(@tsDef, "CustomerKey", @PTMS_MealSelection_Confirmation)
  SetObjectProperty(@ts, "TriggeredSendDefinition", @tsDef)

  SET @ts_sub = CreateObject("Subscriber")
  SetObjectProperty(@ts_sub, "EmailAddress", @emAddr)
  SetObjectProperty(@ts_sub, "SubscriberKey", @emAddr)

  SET @attr = CreateObject("Attribute")
  SetObjectProperty(@attr, "Name", "ChannelMemberID")
  SetObjectProperty(@attr, "Value", "10979464")
  AddObjectArrayItem(@ts_sub, "Attributes", @attr)

  SET @attr = CreateObject("Attribute")
  SetObjectProperty(@attr, "Name", "PNR_Reservation_Number")
  SetObjectProperty(@attr, "Value", @PNR_Reservation_Number)
  AddObjectArrayItem(@ts_sub, "Attributes", @attr)

  SET @attr = CreateObject("Attribute")
  SetObjectProperty(@attr, "Name", "PNR_Create_Date")
  SetObjectProperty(@attr, "Value", @PNR_Create_Date)
  AddObjectArrayItem(@ts_sub, "Attributes", @attr)
  
  SET @attr = CreateObject("Attribute")
  SetObjectProperty(@attr, "Name", "Segment_Number")
  SetObjectProperty(@attr, "Value", @Segment_Number)
  AddObjectArrayItem(@ts_sub, "Attributes", @attr)
  
  SET @attr = CreateObject("Attribute")
  SetObjectProperty(@attr, "Name", "Ticket_Number")
  SetObjectProperty(@attr, "Value", @Ticket_Number)
  AddObjectArrayItem(@ts_sub, "Attributes", @attr)
  
  AddObjectArrayItem(@ts, "Subscribers", @ts_sub)
  SET @ts_statusCode = InvokeCreate(@ts, @ts_statusMsg, @errorCode)
endif


]%%
<!doctype html>
<html>
<head>
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta charset="UTF-8">
 <meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
 <meta name="format-detection" content="telephone=no">
 <meta name="x-apple-disable-message-reformatting">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1"/>
    <title>Pre-Meal Selection</title>
    <link rel="stylesheet" href="https://fe5715707c630d797310.pub.s1.sfmc-content.com/huuzhzxjdwv" type="text/css">
    <script src="https://fe5715707c630d797310.pub.s1.sfmc-content.com/jutuf3iydf0"></script>
    <script src="https://fe5715707c630d797310.pub.s1.sfmc-content.com/qryias4tdlf"></script>

    <!-- adobe launch -->
    <!-- dev -->
    <script src="//assets.adobedtm.com/launch-EN2d9ddc52bb0f459688e1246a71bfddf5-development.min.js" async></script>
    <!-- stage -->
    <!-- <script src="//assets.adobedtm.com/launch-EN53bc78ae71c041d3a4aa06716ae1233c-staging.min.js" async></script> -->
    <!-- prod -->
    <!-- <script src="//assets.adobedtm.com/launch-ENc584c25b4a66446fbaa1f364f488b711.min.js" async></script> -->

    <script type="text/javascript">
      var digitalData = {
        AccountManagement: {
          AGRTier: "",
          loginStatus: "",
          AGRNumber: "",
          AGRPoints: "",
          favDeparture: "",
          favArrival: ""
        },
        PageInfo: {
          pageName: 'MealSelect:confirmOrder',
          pageType: "",
          channel: "cloud.amtrak.com",
          siteSection: "",
          siteName: "amtrak"
        },
        mealSelections: %%=v(@mealSelections)=%%
      };
    </script>
</head>
<body class="error">
<div id="root" class="container">
  <div id="top_navigation_body" class="top_navigation_body">
   <header role="banner" class="page-header">
    <div class="page-header__topbar">
      <div class="wrapper am-g">
        <div class="site-logo">
          <a href="#" class="site-logo__link" v-on:click="homePage">
          <span class="hide-from__screen">amtrak</span>
          <img src="https://image.s1.sfmc-content.com/lib/fe5715707c630d797310/m/10/9ab3babc-dca1-4766-bf94-b605d8e0a0f9.png" class="site-logo__img" alt="amtrak_logo"></a>
        </div>
        <div v-on:click="indicatorToOverview">
          <guest-indicator :guestslength="guests.length"></guest-indicator>
        </div>
      </div>
    </div>
   </header>
  </div>
  <div class="modal-confirmorder">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container %%=v(@congratulations)=%%">
          <div class="modal-message">
            %%=v(@message_title)=%%
            %%=v(@message_Description)=%%
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
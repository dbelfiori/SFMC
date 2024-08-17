<script runat="server" language="javascript">
  var prox = new Script.Util.WSProxy();
  var cols = ["Name", "Client.ID", "ParentFolder.ID", "ParentFolder.Name", "ContentType", "ID", "CustomerKey"];
  var reqID;
  var data;
  var totalResults = [];
  var filter = {
    Property: "ContentType",
    SimpleOperator: "equals",
    Value: 'asset'
  };

  var moreData = true;

  while(moreData) {
    moreData = false;

    if(reqID == null) {
      data = prox.retrieve("DataFolder", cols, filter);
    }
    else {
      data = prox.getNextBatch("DataFolder", reqID);
    }

    if(data != null) {
      moreData = data.HasMoreRows;
      reqID = data.RequestID;
      totalResults = totalResults.concat(data["Results"]);
    }
  }

  Variable.SetValue("@folder_data", Stringify(totalResults));
</script>

<style> 
input#all { margin-left:35% }
</style>
<cfoutput>
     <h1>Unsubscribe</h1>
     <p>Please enter your email address below, and select the subscriptions you would like to remove.</p>
     #startFormTag(action="removeSubscriptions")#
          #textField(id="email", objectName="member", property="emailAddress", label=l("member.label.email"))#
<div id="checkboxes">
         #checkbox(id="all", objectName="member", property="emailoptin", label=l("member.label.optoutnse"), checkedvalue="AGR-NSE")#
          #checkbox(id="mes", objectName="member", property="emailoptin", label=l("member.label.optoutstatement"), checkedvalue="AGR-MES")#
        #checkbox(id="poie", objectName="member", property="emailoptin", label=l("member.label.optoutoffers"), checkedvalue="AGR-POIE")#
         #checkbox(id="poe", objectName="member", property="emailoptin", label=l("member.label.optoutpartners"), checkedvalue="AGR-POE")#
          #checkbox(id="ccoe", objectName="member", property="emailoptin", label=l("member.label.optoutcredit"), checkedvalue="AGR-CCOE", helpText=l("member.help.optincaveat"))#
</div>
          #submitTag()#
     #endFormTag()#
 </cfoutput>
 
 
 
 
<script>
    document.getElementById('checkboxes').addEventListener('change', function(e) {
        var el = e.target;
        var inputs = document.getElementById('checkboxes').getElementsByTagName('input');
       
        // If 'all' was clicked
        if (el.id === 'all') {
       
            // loop through all the inputs, skipping the first one
            for (var i = 1, input; input = inputs[i++]; ) {
           
                // Set each input's value to 'all'.
                input.checked = el.checked;
            }
        }
       
        // We need to check if all checkboxes have been checked
        else {
            var numChecked = 0;
           
            for (var i = 1, input; input = inputs[i++]; ) {
                if (input.checked) {
                    numChecked++;
                }
            }
           
            // If all checkboxes have been checked, then check 'all' as well
            inputs[0].checked = numChecked === inputs.length - 1;
        }
    }, false);
 </script> 

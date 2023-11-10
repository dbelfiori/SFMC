 <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

<style>
     #donation-counter { background:transparent url(http://static.tumblr.com/1wyixdt/3Ozn4eamu/counter_empty.png) 0 0 no-repeat;width:260px;height:236px;margin:0 auto 10px; }
     #donations { background:transparent url(http://static.tumblr.com/1wyixdt/zqGn4eane/counter_filled.png) 0 0 no-repeat;width:0;height:236px; }
</style>
    <div id="item-id-donations" class="item item-text" data-item-type="text">
          <div class="container">
              
               <div id="donation-counter">
                    <div id="donations"></div>
               </div>
          </div>
     </div>
    
     <script>
          var donationConfig = {
               "startAmount":100000,
               "totalAmount":150000,
               "totalWidth":260,
               "offset": {
                    "left":32,
                    "right":26
               }
          }
    
          function showDonations(donationAmt) {
               if(donationAmt) {
                    var donationMeterWidth = donationConfig.totalWidth - (donationConfig.offset.left + donationConfig.offset.right);
                    var n = (donationAmt-donationConfig.startAmount)/(donationConfig.totalAmount-donationConfig.startAmount);
                   
                    var donationsWidth = donationMeterWidth*n;
                   
                    $('#donations').css('width',donationsWidth+donationConfig.offset.left);
               }
          }
         
          $(document).ready(function(e) {
         
               showDonations(125000);
              
          });
     </script>
     <!-- End Donation Counter -->
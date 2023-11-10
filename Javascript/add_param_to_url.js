var url = window.location.href; 
 var urlParts = url.split('?'); 
 if (urlParts.length > 0) { 
     var queryString = urlParts[1]; 

     var updatedQueryString = queryString + 'this_is_the_new_url'  

     var updatedUri = '?' + updatedQueryString; 
     window.history.replaceState({}, document.title, updatedUri); 
 } 

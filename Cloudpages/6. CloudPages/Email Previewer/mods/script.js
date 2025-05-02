%%=v(@scriptBegin)=%%
async function updateContent() {
// Get the value entered in the input field
const findEMVersion = document.getElementById('findEMVersion').value;
const queryParams = window.location.search;
const fetchURL = `https://mc656xjxw5s9zlrhn6jx5z5q2zq0.pub.sfmc-content.com/ot10gwhmbrn?findEMVersion=${findEMVersion}`

// Send the value to the server using AJAX
const response = await fetch(fetchURL, {
method: 'POST',
headers: {
'Content-Type': 'application/x-www-form-urlencoded',
},
body: `value=${encodeURIComponent(findEMVersion)}`
});

// Retrieve the updated content from the server
const data = await response.text();

// Update the content block with the new value
document.getElementById('contentBlock').innerHTML = data;
}
%%=v(@scriptEnd)=%%
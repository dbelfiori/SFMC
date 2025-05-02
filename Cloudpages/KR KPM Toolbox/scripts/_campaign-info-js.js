%%=v(@scriptBegin)=%%
document.addEventListener("DOMContentLoaded", () => {
    const fileUpload = document.getElementById('fileUpload');
    const dropArea = document.getElementById('dropArea');

    fileUpload.addEventListener('change', (e) => handleFile(e.target.files[0]));
    dropArea.addEventListener('dragover', (e) => e.preventDefault());
    dropArea.addEventListener('drop', (e) => {
        e.preventDefault();
        handleFile(e.dataTransfer.files[0]);
    });
});

function handleFile(file) {
    if (!file || !(file instanceof Blob)) {
        console.error("Invalid file type. Ensure you're uploading an actual Excel file.");
        return;
    }

    const reader = new FileReader();
    reader.onload = (event) => {
        const data = new Uint8Array(event.target.result);
        const workbook = XLSX.read(data, { type: "array" });
        const sheetName = workbook.SheetNames[0]; 
        const sheet = workbook.Sheets[sheetName];

        // Extract values from specific cells
        const extractCellValue = (cellAddress) => sheet[cellAddress] ? sheet[cellAddress].v : "No data found";
        const b1Value = extractCellValue("B1");
        // Check Multiple Versions

        if(b1Value === "PLEASE SAVE A COPY AND DELETE THIS ROW!") {
            const g4Value = extractCellValue("G4").trim();
            const k4Value = extractCellValue("K4").trim();
            const C4Value = extractCellValue("C4");
            document.getElementById("create_campaignCode").value = extractCellValue("B4");
            document.getElementById("create_campaignVersion").value = extractCellValue("C4");
            document.getElementById("create_campaignName").value = extractCellValue("B6");
            document.getElementById("create_campaignDate").value = extractCellValue("C6").toString().substring(0, 8);
            document.getElementById("create_campaignProfile").value = extractCellValue("P4") + " | " + extractCellValue("P6");
            document.getElementById("create_campaignLink").value = extractCellValue("B39");
            document.getElementById("create_CampaignManager").value = extractCellValue("B10");
            document.getElementById("create_Period").value = extractCellValue("D10");
            if (g4Value !== "XXX") {
                document.getElementById("create_campaignVersion").value += `, ${g4Value}`;
            }
            if (k4Value !== "XXX") {
                document.getElementById("create_campaignVersion").value += `, ${k4Value}`;
            }
        } else {
            const g3Value = extractCellValue("G3").trim();
            const k3Value = extractCellValue("K3").trim();
            const C3Value = extractCellValue("C3");
            document.getElementById("create_campaignCode").value = extractCellValue("B3");
            document.getElementById("create_campaignVersion").value = extractCellValue("C3");
            document.getElementById("create_campaignName").value = extractCellValue("B5");
            document.getElementById("create_campaignDate").value = extractCellValue("C5").toString().substring(0, 8);
            document.getElementById("create_campaignProfile").value = extractCellValue("P3") + " | " + extractCellValue("P5");
            document.getElementById("create_campaignLink").value = extractCellValue("B38");
            document.getElementById("create_CampaignManager").value = extractCellValue("B9");
            document.getElementById("create_Period").value = extractCellValue("D9");
            if (g3Value !== "XXX") {
                document.getElementById("create_campaignVersion").value += `, ${g3Value}`;
            }
            if (k3Value !== "XXX") {
                document.getElementById("create_campaignVersion").value += `, ${k3Value}`;
            }
        }
    };
    reader.readAsArrayBuffer(file);
}
%%=v(@scriptEnd)=%%
({
    doInit : function(component, event, helper) {
        component.set("v.showSpinnerNow",true);
        var today = new Date();
        today = today.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        // Get the current date
        const currentDate = new Date(today);
        
        // Create an array to store month names
        const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        
        // Get the current month and year
        let currentMonth = currentDate.getMonth()-1;
        let currentYear = currentDate.getFullYear();
        
        // Create an array to store the last 12 months' names
        const last6Months = [];
        
        // Loop through the last 12 months
        for (let i = 0; i < 6; i++) {
            // Add the month name to the array
            last6Months.push({ name: `${monthNames[currentMonth]} ${currentYear}`, value: `${currentYear}-${(currentMonth + 1).toString().padStart(2, '0')}`});
    
    // Move to the previous month
    currentMonth--;
    
    // If we reach January, move to the previous year
    if (currentMonth < 0) {
    currentMonth = 11;
    currentYear--;
}
 }
 // Sort the array based on the "value" property
 last6Months.sort((a, b) => (a.value > b.value) ? 1 : -1);

// Extract only the "name" property for the final result
const sortedMonthNames = last6Months.map(month => month.name);
component.set("v.sortedMonthNames",sortedMonthNames);
var monthsList = []; var yearList = []; 
for(var i=0; i<sortedMonthNames.length; i++){
    var selectedMonth = sortedMonthNames[i];
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var month = ''; var year = '';
    if(selectedMonth != null){
        month = selectedMonth.split(' ')[0];
        year = selectedMonth.split(' ')[1];
    }
    var monthNumber = parseInt(monthNames.indexOf(month))+1;   
    monthsList.push(monthNumber);
    yearList.push(year);
}
component.set("v.monthsList",monthsList);
component.set("v.yearList",yearList);

helper.getData(component, event, helper, 0);
},
    
})
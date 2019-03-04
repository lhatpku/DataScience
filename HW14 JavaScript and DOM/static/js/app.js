// Background color
var images = new Array('images/nasa.jpg','images/astronomy.jpg','images/ufo-2.jpg','images/ufo-header.jpg','images/ufo-main.jpg');
var nextimage=0;

var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;

  if (n > images.length) {slideIndex = 1} 
  if (n < 1) {slideIndex = images.length} ;

  $("#background")
    .attr("style", "background-image: url("+images[slideIndex-1]+"); background-size: 100%; height: 100%;")
}

// from data.js
var tableData = data;

// iterate through tbody.
// get reference to the tbody element, add input field and button

var $tbody = d3.select("tbody");
var $dateInput = d3.select("#datetime");
var $cityInput = d3.select("#city");
var $stateInput = d3.select("#state");
var $countryInput = d3.select("#country");
var $shapeInputer = d3.select("#shape");
var $searchButton = d3.select("#filter-btn");

// add an event listener to searchbutton and resetbutton and add a function
$searchButton.on("click", searchData);
// $resetButton.addEventListener("click", resetData);

// function to render filetered data to the tbody

function searchData(event){
	//to prevent the page from refreshing
    d3.event.preventDefault();

    var filter_dict = {};

    if ($dateInput.property("value") != ""){
        filter_dict = {...filter_dict,...{"datetime":$dateInput.property("value")}};
    }

    if ($cityInput.property("value") != ""){
        filter_dict = {...filter_dict,...{"city":$cityInput.property("value")}};
    }

    if ($stateInput.property("value") != ""){
        filter_dict = {...filter_dict,...{"state":$stateInput.property("value")}};
    }

    if ($countryInput.property("value") != ""){
        filter_dict = {...filter_dict,...{"country":$countryInput.property("value")}};
    }

    if ($shapeInputer.property("value") != ""){
        filter_dict = {...filter_dict,...{"shape":$shapeInputer.property("value")}};
    }

    console.log(filter_dict);
    var dataOutput = tableData;

    Object.entries(filter_dict).forEach(function([key,value]) {

        console.log(key,value);
        dataOutput = dataOutput.filter(data_dict => data_dict[key] === value);

    })

    if (dataOutput.length > 0) {
        renderTable(dataOutput);
    }

}

// function to render filetered data to the tbody
function renderTable(dataOutput) {

    $tbody.html("");

    dataOutput.forEach(function(data_row) {

        var $row = $tbody.append('tr')

        Object.entries(data_row).forEach(function([key,value]) {

            $row.append("td").text(value);
        
        })

    })
};


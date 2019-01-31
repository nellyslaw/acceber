<script type="text/javascript" src="processing.js"></script>

## Nelly 2048
<canvas data-processing-sources="nelly2048/nelly2048.pde"></canvas>

## Flappy Nelly
<canvas data-processing-sources="flappyNelly/flappyNelly.pde"></canvas>

## Hunt Schedule
<span/>
<div>
	<h5>Target Similarity Criteria</h5>
		<label for="raceSlider_name">Other</label>
		<input type="range" id="raceSlider_id" name="raceSlider_name" value="50" min="0" max="100"/>
		<label for="raceSlider_name">Asian</label>
	<h5 id="oii_p" hidden="true">Why Bother</h5>
	<h5 id="huntDate_p" hidden="true">Target Date of Birth</h5>
		<input type="date" id="huntDate_id" name="huntDate_name" hidden="true"/>
		<label for="huntDate_name" id="huntAdvice_id"></label>
</div>
<script type="text/javascript"> 
var rightNow = new Date();
var nBday = new Date(1994,01,01);
var datePicker = document.getElementById("huntDate_id");
var dateP = document.getElementById("huntDate_p");
var oiiP = document.getElementById("oii_p");
datePicker.setAttribute("max", rightNow.toISOString().substr(0,10));
var huntAdvice = document.getElementById("huntAdvice_id");

var raceSlider = document.getElementById("raceSlider_id");
raceSlider.onchange = function() {
	if (raceSlider.value === "100"){ 
		datePicker.hidden = false; 
		dateP.hidden = false;
		oiiP.hidden = true; }
	else { 
		datePicker.hidden = true; 
		dateP.hidden = true; 
		oiiP.hidden = false;
		huntAdvice.textContent = "";
		datePicker.value = ""; }
};

datePicker.onchange = function() {
	if (datePicker.value === "") { 
		huntAdvice.textContent = ""; }
	else {
		var seven_years = 1000*60*60*24*365.25*7;
		var minDate = (rightNow.getTime() + nBday.getTime())/2 - seven_years;
		if (datePicker.valueAsNumber <= minDate) {
			huntAdvice.textContent = "Hunt On Hunter.";
		}
		else {
			var huntDateMillis = 2 * (datePicker.valueAsNumber + seven_years) - nBday.getTime();
			huntAdvice.textContent = "Yikes, not now. Commence hunt on: " + new Date(huntDateMillis).toDateString() + ".";
		}	
	}
};
</script>
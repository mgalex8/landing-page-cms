var isFirstRun = localStorage['isFirstRun'];
if(typeof(isFirstRun) == 'undefined')
{
	localStorage['isFirstRun'] = 'false';
	var url = "http://myd3v.com/api/stats/install/chrome";
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.send();
}

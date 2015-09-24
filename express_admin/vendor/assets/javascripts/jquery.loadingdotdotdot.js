(function($) {

    $.Loadingdotdotdot = function(el, options) {

        var base = this;

        base.$el = $(el);

        base.$el.data("Loadingdotdotdot", base);

        base.dotItUp = function($element, maxDots, dots) {
            if (dots == maxDots) {
              $element.find("span").addClass('dot')
            }
            else {
              for (i = 0; i < dots + 1; i++) {
                $($element.find("span")[i]).removeClass('dot')
              }
            }
        };

        base.stopInterval = function() {
            clearInterval(base.theInterval);
        };

        base.init = function() {

            if ( typeof( speed ) === "undefined" || speed === null ) speed = 300;
            if ( typeof( maxDots ) === "undefined" || maxDots === null ) maxDots = 3;

            base.speed = speed;
            base.maxDots = maxDots - 1;

            base.options = $.extend({},$.Loadingdotdotdot.defaultOptions, options);

            base.dotsSpan = "";
            dots = 0;

            for(i = 0; i < base.maxDots; i++)
            {
              base.dotsSpan += "<span class='dot'>.</span>"
            }

            base.$el.html("<span>" + base.options.word + "<em>." + base.dotsSpan + "</em></span>");

            base.$dots = base.$el.find("em");
            base.$loadingText = base.$el.find("span");


            base.theInterval = setInterval(function() {
              dots = ++dots % (base.maxDots + 1);
              base.dotItUp(base.$dots, base.maxDots, dots);
            }, base.options.speed);

        };

        base.init();

    };

    $.Loadingdotdotdot.defaultOptions = {
        speed: 300,
        maxDots: 3,
        word: "Loading"
    };

    $.fn.Loadingdotdotdot = function(options) {

        if (typeof(options) == "string") {
            var safeGuard = $(this).data('Loadingdotdotdot');
      if (safeGuard) {
        safeGuard.stopInterval();
      }
        } else {
            return this.each(function(){
                (new $.Loadingdotdotdot(this, options));
            });
        }

    };

})(jQuery);

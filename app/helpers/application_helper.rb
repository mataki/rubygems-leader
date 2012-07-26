module ApplicationHelper
  def adsense
    code = <<-EOF
<script type="text/javascript"><!--
google_ad_client = "ca-pub-4089366119938060";
/* Rubygems-leader */
google_ad_slot = "3917169118";
google_ad_width = 120;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
EOF
    code.html_safe
  end

  def adsense_mob
    code = <<-EOF
<script type="text/javascript"><!--
google_ad_client = "ca-pub-4089366119938060";
/* rubygems-leader-mob */
google_ad_slot = "6146684524";
google_ad_width = 320;
google_ad_height = 50;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
EOF
    code.html_safe
  end

  def analytics
    return unless Rails.env.production?
    code = <<-EOF
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-33450752-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
EOF
    code.html_safe
  end

  def forkmeongithub
    code = <<-EOF
<a href="https://github.com/you"><img style="position: absolute; top: 0; right: 0; border: 0; z-index: 1050;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png" alt="Fork me on GitHub"></a>
EOF
    code.html_safe
  end
end

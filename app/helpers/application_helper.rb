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
end

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
end

#!/bin/bash

### Clean posts

sed -i "/layout:/d" $1
sed -i "/type:/d" $1
sed -i "/parent_id:/d" $1
sed -i "/published:/d" $1
sed -i "/password:/d" $1
sed -i "/status:/d" $1
sed -i "/meta:/d" $1
sed -i "/sq_thread_id::/d" $1
sed -i "/dsq_thread_id:/d" $1
sed -i "/_edit_last:/d" $1
sed -i "/tie_views:/d" $1
sed -i "/_vc_post_settings:/d" $1
sed -i "/_yoast_wpseo_content_score:/d" $1
sed -i "/_yoast_wpseo_primary_category:/d" $1
sed -i "/ampforwp_custom_content_editor:/d" $1
sed -i "/ampforwp_custom_content_editor_checkbox:/d" $1
sed -i "/ampforwp-amp-on-off:/d" $1
sed -i "/ampforwp-redirection-on-off:/d" $1
sed -i "/ads-for-wp-visibility:/d" $1
sed -i "/rocket_header:/d" $1
sed -i "/rocket_title:/d" $1
sed -i "/rocket_custom_title:/d" $1
sed -i "/rocket_sidebar:/d" $1
sed -i "/rocket_post_author:/d" $1
sed -i "/rocket_top_bar:/d" $1
sed -i "/rocket_footer_widgets:/d" $1
sed -i "/rocket_footer:/d" $1
sed -i "/rocket_header_separator:/d" $1
sed -i "/rocket_footer_separator:/d" $1
sed -i "/author:/d" $1
sed -i "/login:/d" $1
sed -i "/email:/d" $1
sed -i "/display_name:/d" $1
sed -i "/first_name:/d" $1
sed -i "/last_name:/d" $1
sed -i "/_yoast_wpseo_metadesc:/d" $1
sed -i "/_yoast_wpseo_title:/d" $1
sed -i "/_thumbnail_id:/d" $1
sed -i "/_yoast_wpseo_focuskw:/d" $1
sed -i "/._yoast_wpseo_linkdex:/d" $1
sed -i "/_yoast_wpseo_linkdex:/d" $1
sed -i "/_yoast_wpseo_focuskw:/d" $1
sed -i "/_thumbnail_id:/d" $1
sed -i "/_oembed_/d" $1
sed -i "/{{unknown}}/d" $1
sed -i "/_yoast/d" $1

#sed -i "/permalink:/d" $1
# sed ";https://www.masoopy.com/wp-content/uploads;/images;g" 
# sed "[!/![/g"
# sed "/permalink:/a FeaturedImage:"

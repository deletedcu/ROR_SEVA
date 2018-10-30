# require 'rubygems'
# require 'sitemap_generator'
require 'fog/aws'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://sevasports.com'

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: 'seva-sitemaps')

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://seva-sitemaps.s3.amazonaws.com/"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'weekly', :priority => 0.9
  add '/seva-score'
  add '/about-us'
  @p = Player.all
  @p.each do |n|
  	add '/players/#{n.slug}', :lastmod => n.updated_at, :priority => 0.9
	end
end

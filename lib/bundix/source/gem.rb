require 'uri'

class Bundix::Source::Gem < Bundix::Source::Base
  attr_reader :name, :version, :remotes, :urls, :rubygems_url

  def initialize(name, version, remotes, sha256 = nil)
    @name = name
    @version = version
    @remotes = remotes.map do |remote|
      remote = remote.to_s.sub(%r{/$}, '')
    end
    @sha256 = sha256
    @urls = @remotes.map do |remote|
      "#{remote}/gems/#{name}-#{version}.gem"
    end
    @rubygems_url = @urls.detect do |url|
      URI.parse(url).host == 'rubygems.org'
    end
  end

  def rubygems_org?
    @rubygems_url != nil
  end

  def cache_key
    {
      'type' => type,
      'name' => name,
      'version' => version.to_s,
      'remotes' => remotes.sort
    }
  end
end

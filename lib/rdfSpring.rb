require 'faraday'
require 'json'
require 'logger'

class RDF_spring
  attr_reader :spring
  attr_accessor :log
  attr_reader :rdfpath
  def initialize(springURL)
    @spring = Faraday.new(springURL)
    @log = Logger.new('/tmp/rdf.log')
    @rdfpath = Dir.new('/tmp/rdf')
  end

  def magazines
    response = spring.get do |request|
      request.url 'magazines'
      request.headers['Accept'] = 'application/json'
    end
    JSON.parse(response.body)['magazine']
  end

  def rdf
    magazines.each do |magazine|
      log.info 'retrieving ' + magazine['issues']
      conn = Faraday.new(url: magazine['issues'])
      
      response = conn.get do |request|
        request.headers['Accept'] = 'application/json'
      end
      issues = JSON.parse(response.body)['issues']['issue']
      if issues.kind_of?(Array)
        issues.each do |i|
          log.info i['id']
          conn = Faraday.new(url: i['url'])
          issue = conn.get do |request|
            request.headers['Accept'] = 'application/rdf+xml'
          end
          log.info 'got it'
          File.open(File.join(rdfpath, i['id']) + '.rdf', 'w') { |f| f.write(issue.body) }
        end
      else
        log.info "singleton"
      end
    end
  end

  def rdf(bmtnid)
    magazineset = magazines.select { |m| m['bmtnid'] == bmtnid }
    magazineset.each do |magazine|
      log.info 'retrieving ' + magazine['issues']
      conn = Faraday.new(url: magazine['issues'])
      
      response = conn.get do |request|
        request.headers['Accept'] = 'application/json'
      end
      issues = JSON.parse(response.body)['issues']['issue']
      if issues.kind_of?(Array)
        issues.each do |i|
          log.info i['id']
          conn = Faraday.new(url: i['url'])
          issue = conn.get do |request|
            request.headers['Accept'] = 'application/rdf+xml'
          end
          log.info 'got it'
          File.open(File.join(rdfpath, i['id']) + '.rdf', 'w') { |f| f.write(issue.body) }
        end
      else
        log.info "singleton"
      end
    end
  end


end

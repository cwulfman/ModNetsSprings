require 'spec_helper'
require 'faraday'
require 'json'

RSpec.describe 'RDF Spring' do
  describe '.new' do
    context "with a valid springs url" do
      it "can tap the magazines spring" do
        rdfspring = RDF_spring.new('http://localhost:8080/exist/restxq/springs/')
        magazines = rdfspring.magazines
        expect(magazines.count).not_to eq(0)
      end
    end
  end
  describe '.rdf' do
    it 'can retrieve rdf' do
      rdfspring = RDF_spring.new('http://localhost:8080/exist/restxq/springs/')
      rdfspring.rdf
    end
  end
end

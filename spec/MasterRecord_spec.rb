# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class User 
  UserFields = {
    :name => MasterRecord.string,
    :age => MasterRecord.integer,
  }
  include MasterRecord
end
class Item
  ItemFields = {
    :name => MasterRecord.string,
    :price => MasterRecord.integer,
  }
  include MasterRecord
end
class Country
  CountryFields = {
    :name => MasterRecord.string,
    :population => MasterRecord.integer,
    :salutation => lambda{|r| "'#{r}!!'" },
    :now => lambda{|r|"lambda{ Time.now.localtime('" + r + "')}"},
  }
  include MasterRecord
end
describe "Masterrecord" do
  describe "csv" do
    before do
      #id,name,age
      #1,ひろし,10
      #2,たけし,20
      #3,まこと,30
      #4,けん,40
      User.load_data(MasterRecord::CSV.load_file(File.expand_path("../data/user.csv", File.dirname(__FILE__)),true))
    end
    it{ expect(User.all.count).to eq(4) }
    it{ expect(User.find("1").name).to eq("ひろし") }
    it do
      expect(User.find(["3","4"]).map(&:attributes)).to eq([
        {:id => "3", :identity => "User@3", :name => "まこと", :age => 30},
        {:id => "4", :identity => "User@4", :name => "けん", :age => 40}
      ])
    end
    it{ expect(User.where(:name => "たけし",:age => 21)).to eq([]) }
    it{ expect(User.where(:name => "たけし",:age => 20).count).to eq(1) }
    it{ expect(User.find_by(:name => "ひろし").age).to eq(10) }
    it{ expect(User.find_by(:name => "たけし",:age => 20).id).to eq("2") }
    it{ expect(User.find_by.id).to eq("1") }
  end
  describe "tsv" do
    before do
      #1	あめ	30
      #2	チョコレート	40
      #3	ガム	50
      Item.load_data(MasterRecord::TSV.load_file(File.expand_path("../data/item.tsv", File.dirname(__FILE__))))
    end
    it{ expect(Item.all.count).to eq(3) }
    it do
      expect(Item.find(["2", "4"]).map(&:attributes)).to eq([
        {:id => "2",:identity => "Item@2",:name => "チョコレート",:price => 40}
      ])
    end
    it{ expect(Item.find_by(:price => 50)["name"]).to eq("ガム") }
    it{ expect(Item.find_by(:price => 50)[:id]).to eq("3") }
    it{ expect(Item.find_by(:price => 40).attributes).to eq({:id => "2",:identity => "Item@2",:name => "チョコレート",:price => 40}) }
  end
  describe "yml" do
    before do
      #1:
      #  name: "Japan"
      #  population: 120000000
      #  salutation: "こんにちは"
      #  now: "+09:00"
      #2:   
      #  name: "China"
      #  population: 500000000
      #  salutation: "您好"
      #  now: "+08:00"
      Country.load_data(
        MasterRecord::YAML.load_file(Country.fields,File.expand_path("../data/country.yml", File.dirname(__FILE__))))
      @now = Time.new(2011,12,18,1,1,0)
      allow(Time).to receive(:now).and_return(@now)
    end
    it{ expect(Country.all.count).to eq(2) }
    it{ expect(Country.find_by(:population => 500000000).name).to eq("China") }
    it{ expect(Country.all.map(&:salutation)).to eq(["こんにちは!!","您好!!"]) }
    it{ expect(Country.find("1").now.call.to_s).to eq("2011-12-18 01:01:00 +0900") }
    it{ expect(Country.find("2").now.call.to_s).to eq("2011-12-18 00:01:00 +0800") }
  end

  describe "expired_at" do
    before do
      Item.load_data(MasterRecord::TSV.load_file(File.expand_path("../data/item.tsv", File.dirname(__FILE__))))
    end

    it { expect(Item.expired_at).to eq((Time.current + Item.cache_seconds).strftime("%Y/%m/%d %H:%M:%S")) }
  end
end

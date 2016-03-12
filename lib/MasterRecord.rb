# coding: utf-8
require 'master_record/factory'
require 'master_record/csv'
require 'master_record/tsv'
require 'master_record/yaml'
module MasterRecord
  def self.included(c)
    fields = c.const_get("#{c}Fields")
    c.instance_variable_set("@fields",fields)
    def c.fields
      @fields
    end

    def c.create_master_record(datum)
      Factory.build(self.to_s,datum,@fields)
    end

    def c.load_data(datum)
      Object.send(:remove_const,"#{self}Data") if Object.const_defined?("#{self}Data")
      eval(create_master_record(datum))
      self.reload
    end

    def c.reload
      @data_timestamp = Time.current.to_i
      klass = Object.const_get("#{self}Data")
      master_records = klass.const_get("#{self}Records")
      self.instance_variable_set("@master_records",master_records)
    end

    # Auto load TSV-File by class_name
    c.load_data(TSV.load_file(ENV["TSV_ROOT_DIR"] + c.to_s.tableize + ".tsv", true)) if ENV["TSV_ROOT_DIR"]

    data_exist =  Class.const_defined?("#{c}Data".to_sym)

    if data_exist
      klass = Object.const_get("#{c}Data")
      master_records = klass.const_get("#{c}Records")
      c.instance_variable_set("@master_records",master_records)
    else
      c.instance_variable_set("@master_records",{})
    end

    fields.keys.each do |f|
      define_method(f) { @info.send(:fetch, f) }
    end

    def initialize(id)
      @id = id.to_s
      @identity = "#{self.class.name}@#{id}"
      rec = self.class.instance_variable_get("@master_records")
      @info = rec[@id]
    end

    def attributes
      @info.merge({:id => @id,:identity => @identity})
    end

    def [](field)
      attributes[field.to_sym]
    end

    attr_reader :identity, :id

    def c.all
      self.check_ttl
      @master_records.keys.map do |id|
        self.new(id)
      end
    end

    def c.find(condition)
      self.check_ttl
      if condition.is_a? Array
        condition.map { |id| access(id.to_s) }.compact
      else
        access(condition.to_s)
      end
    end

    def c.access(id)
      @master_records[id] ? new(id) : nil
    end

    def c.find_by(condition=nil)
      self.check_ttl
      return @master_records.count == 0 ? nil : new(@master_records.keys.first) unless condition
      @master_records.detect do |id,rec|
        break new(id) if coincide?(id,rec,condition)
      end
    end

    def c.where(condition)
      self.check_ttl
      @master_records.select do |id,rec|
        coincide?(id,rec,condition)
      end.map{|k,v| new(k)}
    end

    # TimeToLiveを確認して期間を過ぎていたらデータを再読み込みさせる
    def c.check_ttl
      self.reload if Time.current.to_i > (@data_timestamp || 0) + self.cache_seconds
    end

    # TODO: キャッシュ期間を外部で管理できるようにする
    def c.cache_seconds
      600
    end

    def c.coincide?(id,rec,condition)
      condition.each do|k,v| 
        if k.to_s == "id" 
          break nil if id != v
        else
          break nil if rec[k.to_sym] != v
        end
      end != nil
    end
  end
end

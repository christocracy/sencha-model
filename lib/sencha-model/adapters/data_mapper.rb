##
# DataMapper adapter for Sencha::Model mixin
#

module Sencha
  module Model
    module ClassMethods
      
      def sencha_primary_key
        self.key.first.name
      end
      
      def sencha_column_names
        self.properties.collect {|p| p.name.to_s }
      end
      
      def sencha_columns_hash
        if @sencha_columns_hash.nil?
          @sencha_columns_hash = {}
          self.properties.each do |p|
            @sencha_columns_hash[p.name] = p
          end
        end
        @sencha_columns_hash
      end
      
      def sencha_allow_blank(col)
         (col === self.key.first) ? true : col.nullable?
      end
      
      def sencha_type(col)
        type = ((col.type.respond_to?(:primitive)) ? col.type.primitive : col.type).to_s
        case type
          when "DateTime", "Date", "Time"
            type = :date
          when "String"
            type = :string
          when "Float"
            type = :float
          when "Integer", "BigDecimal"
            type = :int
          else
            type = "auto"
        end
      end
      
      def sencha_associations
        if @sencha_associations.nil?  
          @sencha_associations = {}
          self.relationships.keys.each do |key|
            assn = self.relationships[key]
            @sencha_associations[key.to_sym] = {
              :name => key, 
              :type => type = (assn.options[:max].nil? && assn.options[:min].nil?) ? :belongs_to : (assn.options[:max] > 1) ? :many : nil ,
              :class => assn.parent_model,
              :foreign_key => assn.child_key.first.name,
              :is_polymorphic => false # <-- No impl. for DM is_polymorphic.  Anyone care to implement this?
            }
          end
        end
        @sencha_associations
      end
    end
  end
end


##
# ActiveRecord adapter to Whorm::Model mixin.
#
module Sencha
  module Model
    module ClassMethods
      def sencha_primary_key
        self.primary_key.to_sym
      end
      
      def sencha_column_names
        begin
          self.column_names.map(&:to_sym)
        rescue
          nil
        end
      end
      
      def sencha_columns_hash
        self.columns_hash.symbolize_keys
      end
      
      ##
      # determine if supplied Column object is nullable
      # @param {ActiveRecord::ConnectionAdapters::Column}
      # @return {Boolean}
      #
      def sencha_allow_blank(col)
        # if the column is the primary key always allow it to be blank.
        # Otherwise we could not create new records with sencha because
        # new records have no id and thus cannot be valid
        col.name == self.primary_key || col.null
      end
      
      ##
      # returns the default value
      # @param {ActiveRecord::ConnectionAdapters::Column}
      # @return {Mixed}
      #
      def sencha_default(col)
        col.default
      end
      
      ##
      # returns the corresponding column name of the type column for a polymorphic association
      # @param {String/Symbol} the id column name for this association
      # @return {Symbol}
      def sencha_polymorphic_type(id_column_name)
        id_column_name.to_s.gsub(/_id\Z/, '_type').to_sym
      end
      
      ##
      # determine datatype of supplied Column object
      # @param {ActiveRecord::ConnectionAdapters::Column}
      # @return {String}
      #
      def sencha_type(col)
        type = col.type.to_s
        case type
          when "datetime", "date", "time", "timestamp"
            type = "date"
          when "text"
            type = "string"
          when "integer"
            type = "int"
          when "decimal"
            type = "float"
        end
        type
      end
      
      ##
      # return a simple, normalized list of AR associations having the :name, :type and association class
      # @return {Array}
      #
      def sencha_associations
        @sencha_associations ||= self.reflections.inject({}) do |memo, (key, assn)|
          type = (assn.macro === :has_many || assn.macro === :has_and_belongs_to_many) ? :many : assn.macro
          memo[key.to_sym] = {
            :name => key.to_sym, 
            :type => type, 
            :class => assn.options[:polymorphic] ? nil : assn.klass,
            :foreign_key => assn.foreign_key.to_sym,
            :is_polymorphic => !!assn.options[:polymorphic]
          }
          memo
        end
      end
    end
  end
end


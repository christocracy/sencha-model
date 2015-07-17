class Test::Unit::TestCase
  ##
  # Asserts that the passed list of fields are specified in the sencha_fields call
  # in the model class.
  # @fieldset {Symbol} fieldset (optional, set to :default if missing)
  # @options {Hash} Should contain a :fields key with an array of fields to check for
  #
  def self.should_have_sencha_fields_for_fieldset fieldset = :default, fields = []
    klass = described_type
    should "have the correct extjs_fields" do
      assert !fields.empty?, "an array of fields must be passed.  Example: (:fieldset_name, [:name, :id])"
      fields.each do |field|
        found_record = klass.sencha_get_fields_for_fieldset(fieldset).find do|record_field|
          record_field[:name].to_sym == field.to_sym
        end
        assert_not_nil found_record, "sencha field #{field} isn't listed in the #{klass.name} model"
      end
    end
  end
end

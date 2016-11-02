# http://samuelmullen.com/2013/12/validating-presence-of-associations-and-foreign-keys-in-rails/
class ExistenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank? && record.send("#{attribute}_id".to_sym).blank?
      record.errors[attribute] << I18n.t("errors.messages.existence")
    end
  end
end
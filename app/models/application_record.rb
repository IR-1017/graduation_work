# frozen_string_literal: true

# すべてのActiveRecordモデルの基底クラス
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

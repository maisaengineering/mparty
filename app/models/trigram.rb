#this will be used to store a "fuzzy index" of all the models and fields you will be indexing
class Trigram < ActiveRecord::Base
  include Fuzzily::Model
end
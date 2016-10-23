#!/usr/bin/ruby
# -*- coding: utf-8 -*-

class Licences
  # Licence
  class Licence
    require 'digest/md5'
    attr_reader :licence_id, :division, :category,
                :s_plice, :name, :class_name, :group
    attr_accessor :score
    def initialize(params)
      @licence_id = params[:licence_id]
      @division = params[:division]
      @category = params[:category]
      @group = params[:group]
      @score = params[:score]
      @name = params[:name]
      @class_name = params[:class_name]
      @training_date = params[:training_date]
      @registration_plice = params[:registration_plice]
      @personal = nil
    end

    def full_name
      "#{@name} #{@class_name}".strip
    end

    def plice(unit_plice)
      @s_plice = unit_plice * @score.total
    end

    def personal?
      true if @personal
    end

    def personalize(person, licence_data)
      raise 'allrady personalize data' if personal?
      clone.add_personal_data(person, licence_data)
    end

    def add_personal_data(person, licence_data)
      @personal = [person, [licence_data]]
      self
    end

    def person
      personal? ? @personal[0] : {}
    end

    def personal_data
      personal? ? @personal[1].first : {}
    end

    def md5
      str = "#{licence_id}#{personal_data[:licence_number]}}"
      Digest::MD5.hexdigest(str)
    end

    def add_licence_data(licence_data)
      @personal[1] << licence_data if personal?
      self
    end

    def publish_count
      personal? ? @personal[1].size : 0
    end

    def sinsei?
      return unless personal?
      @personal[1].first[:sinsei] ? true : false
    end

    def personal_score
      if personal?
        @score.personal(person.division.to_sym, sinsei?)
      else
        0
      end
    end

    def personal_payment(_unit_plice)
      personal_score * _uint_plice
    end
  end
end

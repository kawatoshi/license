#!/usr/bin/ruby
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'people'
require 'licence'
class Division
end

# Licences
class Licences
  require 'digest/md5'
  def initialize
    @list = {}
    @unit_plice = 200
    @max_total_plice = 25_000
    @inspection_plice = 2_000
  end

  def size
    @list.size
  end

  def [](num)
    @list[@list.keys[num]]
  end

  def full_size
    counter = 0
    each do |_key, value|
      counter += value.publish_count
    end
    counter
  end

  def divisions
    ary = []
    @list.collect { |_key, l| ary << l.division }
    ary.flatten.uniq
  end

  def groups
    ary = []
    @list.collect { |_key, l| ary << l.group }
    ary.uniq
  end

  def each
    @list.each { |key, value| yield(key, value) }
  end

  def add(licence)
    if find_id(licence.md5)
      licence = find_id(licence.md5).add_licence_data(licence.personal_data)
    end
    @list.update(licence.md5 => licence)
  end

  def include_licence?(licence)
    find_id(licence.md5)
  end

  def find_id(id)
    @list[id]
  end

  def find_licence_id(id)
    @list.each do |key, value|
      return find_id(key) if id == value.licence_id
    end
    nil
  end

  def select_licence_id(id)
    li = Licences.new
    @list.each do |_key, value|
      li.add(value) if id == value.licence_id
    end
    li
  end

  def select_division(division)
    li = Licences.new
    @list.each do |_key, value|
      li.add(value) if value.division.include?(division)
    end
    li
  end

  def select_group(group)
    li = Licences.new
    @list.each do |_key, value|
      li.add(value) if value.group == group
    end
    li
  end

  def set_plice
    each { |_key, value| value.plice(@unit_plice) }
    self
  end
end

class Licences
  # Score
  class Score
    attr_accessor :counter_wait

    def initialize(difficality, act, need, counter_wait)
      @difficality = difficality.to_i
      @act = act.to_i
      @need = need.to_i
      @counter_wait = counter_wait
    end

    def total
      @difficality + @act + @need
    end

    def sinsei(sinsei)
      sinsei ? -1 : 0
    end

    def wait(division)
      w = @counter_wait[division]
      w ? -1 * w : 0
    end

    def personal(division, sinsei)
      total + sinsei(sinsei) + wait(division)
    end
  end
end

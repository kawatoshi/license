# People
class People
  def initialize
    @list = {}
  end

  def add(person)
    @list.update(person.name => person)
  end

  def size
    @list.size
  end

  def each
    @list.each { |key, value| yield(key, value) }
  end

  def find_name(name)
    each do |key, value|
      return @list[key] if value.name == name
    end
    nil
  end
  # Person
  class Person
    attr_accessor :id, :name, :division, :site
    def initialize(params)
      @name = params[:name]
      @division = params[:division]
      @site = params[:site]
    end
  end
end

class Division
end

#!/usr/bin/env ruby

# file: indexer101.rb

require 'c32'
require 'thread'
require 'thwait'


class Indexer101
  using ColouredText
    
  class Index
    
    attr_reader :h
    attr_accessor :index    
    
    def initialize()          
    end
    
    def build(a)
      
      threads = []
      threads << Thread.new do
        @index = Hash[a.map(&:to_sym).zip([''] * a.length)]
      end
      
      threads << Thread.new { @h = group a }
      ThreadsWait.all_waits(*threads)      
            
    end
    
    def inspect()
      h = @h ? @h.inspect[0..30] + "..." : nil
      "#<Indexer101::Index @h=#{h.inspect}>"
    end
    
    private

    def group(a, length=0)

      h = a.group_by {|x| x[0..length]}

      h.each do |key, value|

        if length+1 < value.max.length - 1 then
          h2 = group value, length + 1      
          h[key] = h2 unless h2.length < 2 and value.length < 2
        end

      end
      
      h3 = h.inject({}) do |r,x|
        r.merge(x[0].to_sym => x[-1])
      end

    end
    
  end

  def initialize(filename='indexer.dat', debug: false)
    
    @filename, @debug = filename, debug
    
    puts
    puts 'Indexer101'.highlight +  " ready to index".green 
    puts

    @indexer = Index.new()
    
  end

  def build(a)
    
    t = Time.now
    @indexer.build(a)    
    t2 = Time.now - t
    
    puts "%d words indexed".info % a.length
    puts "index built in %.2f seconds".info % t2 
    
    self
  end
  
  def index()
    @indexer.index
  end  
  
  def read(filename=@filename)
    
    t = Time.now
    
    File.open(filename) do |f|  
      @indexer = Marshal.load(f)  
    end
    
    t2 = Time.now - t
    
    puts "index contains %d words".info % @indexer.index.length
    puts "index read in %.2f seconds".info % t2 
    
  end
  
  def save(filename=@filename)

    File.open(filename, 'w+') do |f|  
      Marshal.dump(@indexer, f)  
    end 
    
  end

  def search(s, limit: 10)

    t = Time.now
    a = scan_path s
    puts ('a: ' + a.inspect[0..100] + '...').debug if @debug
    
    i = scan_key @indexer.h, a
    
    r = @indexer.h.dig(*a[0..i])
    puts ('r: ' + r.inspect[0..100] + '...').debug if @debug
    
    return r if r.is_a? Array
    
    results = scan_leaves(r).sort_by(&:length).take(limit)
    t2 = Time.now - t
    puts "search took %.2f seconds" % t2 if @debug
    
    return results
    
  end

  private

  def scan_key(h, keys, index=0)

    r = h.fetch keys[index]

    puts ('r: ' + r.inspect[0..100] + '...').debug if @debug
    
    if r.is_a?(Hash) and index+1 < keys.length and r.fetch keys[index+1] then
      scan_key r, keys, index+1
    else
      index
    end 

  end
  
  def scan_leaves(h)

    h.inject([]) do |r,x|
      key, value = x

      if value.is_a? Array then
        r += value 
      else
        r += scan_leaves value
      end

      r
    end
  end

  def scan_path(s, length=0)
    
    puts 'inside scan_path'.info if @debug
    
    r = [s[0..length].to_sym]
    
    if length < s.length - 1 then
      r += scan_path(s, length+1)
    else
      r
    end
  end

end

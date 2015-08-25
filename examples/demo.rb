require 'stringtree'

class Main
  def main(argc)
    puts "StringTree Ruby Demo"

    begin
      root = File.dirname(__FILE__)
      @st = StringTree::Tree.new
      puts "Loading Dictionary..."
      @count = 0
      File.open("#{root}/dictionary.txt", "r") do |infile|
        while line = infile.gets
          line = line.strip
          @st.add(line, @count+=1)
          @st.add(line.upcase, @count+=1)
        end
      end

      t=Time.now
      puts "Optimizing Dictionary..."
      @st.optimize
      puts "Optimized #{@count} entries in "+sprintf("%.2f",(Time.now-t)*1000)+"ms"

      puts "-Loading Hamlet-------------------"
      load "#{root}/hamlet.txt"
      do_match "hamlet.tokens.txt"

      puts "--Loading War And Peace-----------"
      load "#{root}/warandpeace.txt"
      do_match "warandpeace.tokens.txt"

      do_partial_matching
    rescue Exception => e
      puts "StringTree demo has encountered an error (#{e.message}). Please run again."
    end
  end

  def load(file_name)
    @contents = File.open(file_name,'rb').read
  end

  def do_match(output_file_name=nil)
    t=Time.now
    puts "Matching #{@count} entries in #{@contents.length} bytes..."
    list = []
    @st.match_all(@contents) { |match| list << match }
    interval = (Time.now-t)*1000

    puts list.length.to_s+" entities matched in "+sprintf("%.2f",interval)+"ms ("+sprintf("%.2f", list.length / interval * 1000)+" entities/s)"

    unless output_file_name.nil?
      puts "Writing File #{output_file_name}"
      File.open(output_file_name,'wb') do |f|
        list.each do |item|
          f.write item.offset.to_s + ": #{item.node} #{item.node.value} (#{item.node.length})\n"
        end
      end
    end
  end

  def do_partial_matching
    puts "-Partial Matching -----------------"
    puts "-Type 'exit' to quit"
    while true do
      print "> "
      x = gets.chomp
      return if x == 'exit'
      partials = @st.partials(x)
      str = ""
      unless partials.nil?
        partials.collect { |partial| str += "#{partial} " }
      else
        str =  "No Matches Found for '#{x}'"
      end
      puts str
    end
  end
end

@main = Main.new
@main.main(0)